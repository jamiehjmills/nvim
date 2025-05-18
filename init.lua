vim.cmd("set shiftwidth=2")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    { "catppuccin/nvim", name = "catppuccin" },
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      },
      lazy = false,
      opts = {
        filesystem = {
          filtered_items = {
            visible = true,  -- Show hidden files
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      },
    },
    -- {
    --   "nvim-treesitter/nvim-treesitter",
    --   build = ":TSUpdate",
    --   event = { "BufReadPost", "BufNewFile" },
    --   dependencies = {
    --     "nvim-treesitter/nvim-treesitter-textobjects",
    --   },
    --   config = function()
    --     require("nvim-treesitter.configs").setup({
    --       highlight = { enable = true },
    --       indent = { enable = true },
    --       ensure_installed = {
    --         "bash", "html", "json", "lua", "luadoc", "markdown",
    --         "python", "tsx", "typescript", "vim", "vimdoc", "yaml"
    --       },
    --       sync_install = false, -- Install parsers synchronously
    --       auto_install = true,  -- Auto install missing parsers when entering buffer
    --       incremental_selection = {
    --         enable = true,
    --         keymaps = {
    --           init_selection = "<C-space>",
    --           node_incremental = "<C-space>",
    --           scope_incremental = false,
    --           node_decremental = "<bs>",
    --         },
    --       },
    --     })
    --   end,
    -- },
    {
      "akinsho/bufferline.nvim",
      dependencies = { 
        "nvim-tree/nvim-web-devicons",
        "catppuccin/nvim" -- Add explicit dependency
      },
      version = "*",
      config = function()
        -- This ensures catppuccin is loaded before trying to use its integrations
        require("bufferline").setup({
          options = {
            mode = "buffers",
            diagnostics = "nvim_lsp",
            offsets = {
              {
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
                separator = true,
              }
            },
            separator_style = "slant",
            show_buffer_close_icons = true,
            show_close_icon = true,
            color_icons = true,
            always_show_bufferline = true,
          },
          highlights = require("catppuccin.groups.integrations.bufferline").get(),
        })
      end,
      keys = {
        { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
        { "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Pick to close" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      },
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-s>", builtin.live_grep, {})
vim.keymap.set("n", "<C-n>", function()
  vim.cmd("Neotree filesystem reveal left")
end, { desc = "Open Neo-tree file explorer" })

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
