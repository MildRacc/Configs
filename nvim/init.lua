-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Plugins
require("lazy").setup({
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "rust-analyzer" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
            ["rust_analyzer"] = function()
                require("lspconfig").rust_analyzer.setup({
                    settings = {
                        ["rust-analyzer"] = {
                            inlayHints = {
                                enable = true,
                                bindingModeHints = { enable = true },
                                chainingHints = { enable = true },
                                closingBraceHints = { enable = true },
                                closureReturnTypeHints = { enable = true },
                                lifetimeElisionHints = { enable = true },
                                parameterHints = { enable = true },
                                typeHints = { enable = true },
                            },
                        },
                    },
                })
            end,
        },
      })
    end
  },
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 125,
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        direction = "vertical",
        close_on_exit = true,
        shell = vim.o.shell,
        perist_size = true,
        persise_mode = true,
      })
    end
  },


  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "rust", "lua" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
      vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
    end
  },

  -- Color scheme
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end
  },
})

-- LSP Keymaps (set after LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end
})

vim.keymap.set({"n", "i"}, "<leader>tt", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set({"t"}, "<leader>tt", "<C-\\><C-n><cmd>ToggleTerm<CR>", { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true})

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true})
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true})
vim.keymap.set("t", "<C-h>", "<C-\\>h", { noremap = true, silent = true})
vim.keymap.set("t", "<C-l>", "<C-\\>l", { noremap = true, silent = true})

vim.keymap.set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
