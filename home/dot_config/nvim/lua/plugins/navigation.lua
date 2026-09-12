return {
  -- Harpoon 2 : bookmarks de fichiers ultra-rapides
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      -- Ajouter un fichier
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })
      -- Ouvrir le menu
      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })
      -- Navigation directe vers les 4 premiers fichiers
      vim.keymap.set("n", "<C-h>", function()
        harpoon:list():select(1)
      end)
      vim.keymap.set("n", "<C-t>", function()
        harpoon:list():select(2)
      end)
      vim.keymap.set("n", "<C-n>", function()
        harpoon:list():select(3)
      end)
      vim.keymap.set("n", "<C-s>", function()
        harpoon:list():select(4)
      end)
    end,
  },
  -- Telescope : améliorations supplémentaires
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "vendor/", "dist/" },
      },
    },
    keys = {
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- fichiers cachés visibles mais grisés
          hide_dotfiles = false, -- affiche les .env, .gitignore, etc.
          hide_gitignored = false,
        },
      },
      window = {
        mappings = {
          -- Overrides the default "scroll_preview" so Cmd+B (sent as Ctrl+B)
          -- also closes the tree when focus is already inside it
          ["<C-b>"] = function()
            require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
          end,
        },
      },
    },
  },
}

