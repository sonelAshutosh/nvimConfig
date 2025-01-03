-- Basic Settings (already present in your config)
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.g.mapleader = " "

-- Clipboard (optional)
-- vim.o.clipboard = "unnamedplus"

-- Load Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Setup
require("lazy").setup({
    "folke/lazy.nvim", -- Lazy.nvim plugin manager

    -- Telescope for fuzzy searching
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "python", "javascript", "html", "css", "tsx", "typescript" },
                highlight = { enable = true },
            })
        end,
    },

    -- LSP support
    "neovim/nvim-lspconfig",

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "luasnip" },
                },
            })
        end,
    },

    -- Null-LS for external tools
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.formatting.black,
                },
            })
        end,
    },

    -- Inlay Hints
    {
        "simrat39/inlay-hints.nvim",
        config = function()
            require("inlay-hints").setup()
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        version = "*",  -- Use the latest version
        config = function()
            require("ibl").setup({
                indent = {
                    char = "│",  -- Character for the indent guides
                },
                scope = {
                    enabled = true,  -- Enable scope guides
                    show_start = true,  -- Show the start of the scope
                    show_end = false,  -- Hide the end of the scope
                },
            })
        end,
    },

    -- Terminal Toggle
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<C-t>]],
                direction = "horizontal",
            })
        end,
    },

    -- AI-Assisted Code Completion
    --{
    --    "Exafunction/codeium.nvim",
    --    config = function()
    --        require("codeium").setup({})
    --    end,
    --},

    -- Smooth Scrolling
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({
                -- Customize scrolling speed and behavior here
                easing_function = "quadratic", -- Default easing function
                hide_cursor = false,           -- Keep the cursor visible while scrolling
            })
        end,
    },

    -- Catppuccin Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    },
})

-- Colorscheme
require("catppuccin").setup({ flavour = "mocha" })
vim.cmd([[colorscheme catppuccin]])

-- Ripgrep installation (Make sure it is installed on your system)
-- You can install it using your package manager:
-- For Debian/Ubuntu: sudo apt install ripgrep
-- For macOS (with Homebrew): brew install ripgrep

-- Neo-tree File Explorer Keybinding
vim.api.nvim_set_keymap("n", "<Leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Telescope Keybindings
vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })

-- ToggleTerm Keybinding
vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm<CR>", { noremap = true, silent = true })

-- Inlay Hints Setup
require("inlay-hints").setup()
