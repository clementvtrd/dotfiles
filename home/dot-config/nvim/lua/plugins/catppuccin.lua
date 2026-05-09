return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    opts = {
      flavour = "auto",

      background = {
        light = "latte",
        dark = "frappe",
      },

      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = true,
        mini = true,
        which_key = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      transparent_background = true,
      show_end_of_buffer = false,
    },
  },
}
