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

-- Autosave open files when window loses focus
-- NOTE: doesn't work w/ untitled buffers
-- TODO: move to lua-native autocmd when it's released
vim.cmd('au FocusLost * silent! wa')

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- Change the leader but retain the ability to backwards char search
vim.g.mapleader = ","
vim.api.nvim_buf_set_keymap(0, '', '\\', ',', {noremap = true})

-- global options
local o = vim.o
local g = vim.g
-- window options
local wo = vim.wo
-- buffer options
local bo = vim.bo
-- vim options?
local opt = vim.opt

g.terraform_align = 1
g.terraform_fmt_on_save = 1

opt.laststatus = 3
-- Disable showing the bufferline because I have not used it in over a decade
opt.showtabline = 0
-- Make sure nvim knows about the Python version we prefer
o.pyxversion = 3
-- Abbrev. of messages (avoids 'hit enter')
opt.shortmess:append "mnrxoOtT"
-- Allow for cursor beyond last character
o.virtualedit = "onemore"
-- Turn on backups
o.backup = true
o.backupdir = os.getenv("HOME") .. "/.vimbackup"
-- Persistent undo
o.undofile = true
o.undolevels = 1000
o.undoreload = 10000
-- Highlight current line
o.cursorline = true
-- Global clipboard access
o.clipboard = "unnamedplus"
-- Line numbers on
o.number = true
o.relativenumber = true
-- Show matching brackets/parenthesis
o.showmatch = true
-- Case insensitive search
o.ignorecase = true
-- Case sensitive when uc present
o.smartcase = true
-- Command <Tab> completion, list matches, then longest common part, then all.
o.wildmode = "list:longest,full"
-- Backspace and cursor keys wrap too
o.whichwrap = "b,s,h,l,<,>,[,]"
-- Lines to scroll when cursor leaves screen
o.scrolljump = 5
-- Minimum lines to keep above and below cursor
o.scrolloff = 3
-- Highlight problematic whitespace
o.listchars = "tab:› ,trail:•,extends:#,nbsp:."
-- Tabs are spaces, not tabs
o.expandtab = true
-- Let backspace delete indent
o.softtabstop = 2
-- Prettier colors
o.termguicolors = true
-- Enable indent guides
o.tabstop = 2
o.shiftwidth = 2
g.indent_guides_start_level = 2
g.indent_guides_guide_size = 1
g.indent_guides_enable_on_vim_startup = 1

vim.opt.updatetime = 300
-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
--
-- Useful for vim-fugitive
vim.opt.signcolumn = "yes"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
    { import = "plugins.lang" }
  },
  change_detection = {
    enabled = false,
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
