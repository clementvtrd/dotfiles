return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- TypeScript / JS
        "typescript-language-server",
        "eslint-lsp",
        "prettierd",
        -- Go
        "gopls",
        "gofumpt",
        -- PHP
        "intelephense",
        -- HTML / CSS / Tailwind
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "emmet-ls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {},
        gopls = {},
        intelephense = {},
        tailwindcss = {},
        emmet_ls = {
          filetypes = { "html", "css", "php", "javascriptreact", "typescriptreact" },
        },
      },
    },
  },
}