function dependabot --description "Approve or merge Dependabot PRs with fallback rebase"
    set dry_run 0
    set action ""
    set merge_method "merge"

    # Parse args
    for arg in $argv
        switch $arg
            case approve merge rebase
                set action $arg
            case --dry-run
                set dry_run 1
            case --rebase
                set merge_method rebase
            case '*'
                echo "Unknown argument: $arg"
                return 1
        end
    end

    if test -z "$action"
        echo "Usage:"
        echo "  dependabot approve [--dry-run]"
        echo "  dependabot merge [--dry-run] [--rebase]"
        echo "  dependabot rebase [--dry-run]"
        return 1
    end

    # Fetch eligible Dependabot PRs
    if test $action = rebase
        # Rebase: ALL Dependabot PRs
        set prs (gh pr list \
            --json number,author \
            --jq '.[]
                | select(
                    .author.login == "app/dependabot"
                    or .author.login == "dependabot[bot]"
                )
                | .number')
    else
        # Approve / Merge: only PRs without failing checks
        set prs (gh pr list \
            --json number,author,statusCheckRollup \
            --jq '.[]
                | select(
                    (.author.login == "app/dependabot" or .author.login == "dependabot[bot]")
                    and (
                        .statusCheckRollup == null
                        or all(.statusCheckRollup[]?;
                            (.conclusion == "SUCCESS" or .conclusion == "SKIPPED")
                        )
                    )
                )
                | .number')
    end

    if test (count $prs) -eq 0
        echo "No eligible Dependabot PRs found."
        return 0
    end

    for pr in $prs
        if test $dry_run -eq 1
            echo "[dry-run] Would $action PR #$pr"
            continue
        end

        switch $action
            case approve
                echo "Approving PR #$pr"
                gh pr review $pr --approve

            case merge
                echo "Merging PR #$pr"
                if test $merge_method = "merge"
                    gh pr merge $pr -dm
                else
                    gh pr merge $pr -dr
                end

                if test $status -ne 0
                    echo "Merge failed for PR #$pr → asking Dependabot to rebase"
                    gh pr comment $pr --body "@dependabot rebase"
                end

            case rebase
                echo "Asking Dependabot to rebase PR #$pr"
                gh pr comment $pr --body "@dependabot rebase"
        end
    end
end
