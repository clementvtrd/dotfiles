return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language servers listed in `servers` below (and the ones coming from
        -- the LazyVim lang extras) are installed by mason-lspconfig, so only
        -- the extra CLI tools need to be listed here.
        "gofumpt",
        "prettierd",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- html/typescript/tsx come from LazyVim, php from the lang.php extra
    opts = { ensure_installed = { "css", "scss" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Go
        gopls = {},
        -- HTML / CSS: no LazyVim extra ships these, configure them here.
        -- TypeScript (vtsls), PHP (intelephense), Tailwind and ESLint come
        -- from the extras in lazyvim.json.
        html = {},
        cssls = {},
        emmet_ls = {
          filetypes = {
            "css",
            "html",
            "javascriptreact",
            "less",
            "php",
            "scss",
            "typescriptreact",
          },
        },
      },
    },
  },
}
