-- init.lua

-- Bootstrap lazy.nvim package manager
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

-- Basic settings
vim.g.mapleader = " "  -- Set leader key to space
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-- Plugin specifications
require("lazy").setup({
    -- Color schemes
    { "rebelot/kanagawa.nvim" },
    { "morhetz/gruvbox" },
    
    -- Git integration
    { "tpope/vim-fugitive" },
    
    -- LSP Configuration
    { "neovim/nvim-lspconfig" },
    
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "go", "lua", "vim", "vimdoc" },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
            })
        end,
    },
    
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    
    -- Go Development
    { "fatih/vim-go" },
    
    -- Status Line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'gruvbox'
                }
            })
        end
    }
})

-- Color scheme setup
vim.cmd([[colorscheme gruvbox]])
vim.opt.background = "dark"

-- LSP setup for Go
require('lspconfig').gopls.setup{
    cmd = {"gopls"},
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
}

-- Keybindings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General mappings
keymap("n", "<leader>w", ":w<CR>", opts)                    -- Save file
keymap("n", "<leader>q", ":q<CR>", opts)                    -- Quit
keymap("n", "<C-h>", "<C-w>h", opts)                        -- Window navigation
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Telescope mappings
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)    -- Find files
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)     -- Find text
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)       -- Find buffers
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)     -- Find help

-- LSP mappings
keymap("n", "gd", vim.lsp.buf.definition, opts)                 -- Go to definition
keymap("n", "gr", vim.lsp.buf.references, opts)                 -- Find references
keymap("n", "K", vim.lsp.buf.hover, opts)                       -- Hover documentation
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)            -- Rename symbol
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)       -- Code actions
keymap("n", "<leader>e", vim.diagnostic.open_float, opts)      -- Show diagnostics

-- Go specific mappings
keymap("n", "<leader>gt", ":GoTest<CR>", opts)                 -- Run tests
keymap("n", "<leader>gr", ":GoRun<CR>", opts)                  -- Run current file
keymap("n", "<leader>gi", ":GoImpl<CR>", opts)                 -- Generate interface implementation
keymap("n", "<leader>gd", ":GoDef<CR>", opts)                  -- Go to definition
keymap("n", "<leader>gD", ":GoDoc<CR>", opts)                  -- Show documentation

-- Git mappings (vim-fugitive)
keymap("n", "<leader>gs", ":Git<CR>", opts)                    -- Git status
keymap("n", "<leader>gc", ":Git commit<CR>", opts)             -- Git commit
keymap("n", "<leader>gp", ":Git push<CR>", opts)               -- Git push
keymap("n", "<leader>gl", ":Git pull<CR>", opts)               -- Git pull

-- Format on save for Go files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format()
    end,
})
