return {
  -- Diffview : visualiser les diffs et l'historique
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",              desc = "Diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",     desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",       desc = "Repo history" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>",             desc = "Close diff" },
    },
  },
  -- Gitsigns : signes dans la gutter + blame inline
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,           -- blame sur la ligne courante
      current_line_blame_opts = {
        delay = 500,
      },
    },
  },
}