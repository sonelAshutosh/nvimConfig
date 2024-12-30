vim.o.number = true              -- Show line numbers
vim.o.relativenumber = true      -- Show relative line numbers
vim.o.shiftwidth = 4            -- Number of spaces for indentation
vim.o.expandtab = true          -- Use spaces instead of tabs
vim.o.smartindent = true        -- Smart indentation
vim.o.swapfile = false          -- Disable swap files

-- Clipboard (optional, uncomment to use system clipboard)
-- vim.o.clipboard = "unnamedplus"

-- Load Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Setup with Lazy.nvim
require("lazy").setup({
    "folke/lazy.nvim",  -- Lazy.nvim plugin manager
    {
        "nvim-telescope/telescope.nvim",  -- Telescope for fuzzy searching
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-treesitter/nvim-treesitter",  -- Treesitter for syntax highlighting
        build = ":TSUpdate",  -- Updates and installs parsers
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { 
                    "lua", 
                    "python", 
                    "javascript", 
                    "html", 
                    "css", 
                    "tsx",  -- Includes React (JSX/TSX)
                    "typescript", 
                },
                highlight = { enable = true },  -- Enable Treesitter syntax highlighting
            })
        end,
    },
    "neovim/nvim-lspconfig",  -- LSP support
    {
        "hrsh7th/nvim-cmp",      -- Autocompletion plugin
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
            "hrsh7th/cmp-buffer",    -- Buffer source for nvim-cmp
            "hrsh7th/cmp-path",      -- Path source for nvim-cmp
            "saadparwaiz1/cmp_luasnip",  -- Snippet source for nvim-cmp
            "L3MON4D3/LuaSnip",      -- Snippet engine
        },
        config = function()
            local cmp = require("cmp")
            local lspconfig = require("lspconfig")

            -- Setup nvim-cmp
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)  -- Use LuaSnip for expanding snippets
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
                    { name = "nvim_lsp" },  -- LSP completion
                    { name = "buffer" },    -- Buffer completion
                    { name = "path" },      -- Path completion
                    { name = "luasnip" },   -- Snippet completion
                },
            })

            -- Setup LSP (Example for Python)
            lspconfig.pyright.setup{}  -- Use Pyright for Python LSP support
            lspconfig.ts_ls.setup{} -- Use TSServer for JavaScript/TypeScript LSP support

        end,
    },
    "nvim-lualine/lualine.nvim",  -- Status line plugin
    "nvim-tree/nvim-tree.lua",    -- File explorer plugin
    {
        "nvim-neo-tree/neo-tree.nvim",  -- Neo-tree plugin
        branch = "v2.x",  -- Use the v2.x branch for the latest stable version
        dependencies = {
            "nvim-lua/plenary.nvim",  -- For necessary utility functions
            "kyazdani42/nvim-web-devicons",  -- For file icons
            "MunifTanjim/nui.nvim",    -- Dependency for Neo-tree UI
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = true,  -- Show hidden files (adjust as needed)
                    },
                },
                window = {
                    position = "right",  -- Position the Neo-tree window to the left
                    width = 30,         -- Set width of the Neo-tree window
                },
            })
        end,
    },
    { 
        "catppuccin/nvim",  -- Catppuccin theme
        name = "catppuccin",  -- Alias for convenience
        priority = 1000,  -- Ensure it loads first
    },
})

-- Catppuccin Theme Configuration
require("catppuccin").setup({
    flavour = "mocha",  -- Choose theme flavour (latte, frappe, macchiato, mocha)
})

-- Set colorscheme
vim.cmd([[colorscheme catppuccin]])

-- Set leader key to space
vim.g.mapleader = " "

-- Neo-tree keybindings
vim.api.nvim_set_keymap("n", "<Leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Keybindings for Telescope
vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })  -- Search files
vim.api.nvim_set_keymap("n", "<Leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })   -- Search text in files
vim.api.nvim_set_keymap("n", "<Leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })     -- List open buffers
vim.api.nvim_set_keymap("n", "<Leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })    -- Search help tags

