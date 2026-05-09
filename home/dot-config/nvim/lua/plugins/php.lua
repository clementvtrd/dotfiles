return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                mazSize = 5000000,
              },
            },
          },
        },
      },
    },
  },
}
