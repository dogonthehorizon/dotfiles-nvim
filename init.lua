-- global options
local o = vim.o
local g = vim.g
-- window options
local wo = vim.wo
-- buffer options
local bo = vim.bo
-- vim options?
local opt = vim.opt

g.packpath = '~/.config/nvim'
vim.cmd('packadd minpac')

vim.call('minpac#init')

vim.cmd("call minpac#add('k-takata/minpac', {'type': 'opt'})")


-- Change the leader but retain the ability to backwards char search
g.mapleader = ","
vim.api.nvim_buf_set_keymap(0, '', '\\', ',', {noremap = true})


vim.cmd("command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})")
vim.cmd("command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()")
vim.cmd("command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()")
---- Language Specific Plugins
-- Haskell
vim.cmd("call minpac#add('neovimhaskell/haskell-vim')")

-- Racket
vim.cmd("call minpac#add('wlangstroth/vim-racket')")
vim.cmd("call minpac#add('Olical/conjure')")

-- Fish
vim.cmd("call minpac#add('dag/vim-fish')")

-- Terraform
vim.cmd("call minpac#add('hashivim/vim-terraform')")

g.terraform_align = 1
g.terraform_fmt_on_save = 1

---- Themes & Fonts
vim.cmd("call minpac#add('kyazdani42/nvim-web-devicons')")
vim.cmd("call minpac#add('sainnhe/everforest')")
vim.cmd("call minpac#add('catppuccin/nvim')")
require("catppuccin").setup({
  flavour = 'macchiato'
})

---- Completion plugins
vim.cmd("call minpac#add('neoclide/coc.nvim', {'branch': 'release', 'do': {-> system('yarn install --frozen-lockfile')}})")

local keyset = vim.keymap.set
function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- <TAB>: completion.
local coc_opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', coc_opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], coc_opts)
-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], coc_opts)


-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gD", [[:Telescope coc diagnostics<CR>]], {silent = true})
keyset("n", "gy", [[:Telescope coc type_definitions<CR>]], {silent = true})
keyset("n", "gr", [[:Telescope coc references<CR>]], {silent = true})
keyset("n", "gR", [[<Plug>(coc-rename)]], {silent = true})

-- Remap keys for applying codeAction to the current line.
keyset('n', '<leader>ac',  [[<Plug>(coc-codeaction)]], { silent = true })
-- Apply AutoFix to problem on the current line.
keyset('n', '<leader>qf',  [[<Plug>(coc-fix-current)]], { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

---- Command palette-style plugins
vim.cmd("call minpac#add('nvim-lua/plenary.nvim')")
vim.cmd("call minpac#add('nvim-telescope/telescope.nvim')")
vim.cmd("call minpac#add('nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'})")
vim.cmd("call minpac#add('fannheyward/telescope-coc.nvim')")

telescope = require'telescope'

telescope.setup({
  extensions = {
    coc = {
      prefer_locations = true,
      push_cursor_on_edit = true,
    }
  },
})

telescope.load_extension('fzf')
t_builtins = require('telescope.builtin')

-- Open find_files w/ C-p
keyset('n', '<C-p>', t_builtins.find_files, {})
keyset('n', '<leader>fg', t_builtins.live_grep, {})


---- Utilities
vim.cmd("call minpac#add('scrooloose/nerdcommenter')")
vim.cmd("call minpac#add('godlygeek/tabular')")
vim.cmd("call minpac#add('Townk/vim-autoclose')")
vim.cmd("call minpac#add('tpope/vim-fugitive')")
vim.cmd("call minpac#add('airblade/vim-gitgutter')")
vim.cmd("call minpac#add('nathanaelkane/vim-indent-guides')")
vim.cmd("call minpac#add('dbakker/vim-lint')")
vim.cmd("call minpac#add('guns/vim-sexp')")
vim.cmd("call minpac#add('tpope/vim-surround')")
vim.cmd("call minpac#add('tpope/vim-vinegar')")
vim.cmd("call minpac#add('tpope/vim-obsession')")

vim.cmd("call minpac#add('hiphish/rainbow-delimiters.nvim')")
require'rainbow-delimiters'


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
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime = 300
-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
--
-- Useful for coc.nvim && vim-fugitive
opt.signcolumn = "yes"

-- Autosave open files when window loses focus
-- NOTE: doesn't work w/ untitled buffers
-- TODO: move to lua-native autocmd when it's released
vim.cmd('au FocusLost * silent! wa')

-- Disable word mapping because it messes with LSP type checking
-- in languages like Python.
g["conjure#mapping#doc_word"] = false

vim.cmd("au BufWrite *.py :silent call CocAction('runCommand', 'python.sortImports')")

-- TreeSitter config
vim.cmd("call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})")
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}

require'nvim-treesitter.parsers'.filetype_to_parsername.mdx = 'markdown'

-- Set the colorscheme in Lua
o.background = 'dark'
vim.cmd.colorscheme "catppuccin"

-- Setup devicons
require'nvim-web-devicons'.setup {
  default = true
}

-- setup statusline
vim.cmd("call minpac#add('nvim-lualine/lualine.nvim')")
require'lualine'.setup {
  options = {
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_x = { 'g:coc_status' }
  }
}
-- Shift key fixes
vim.cmd("command! -bang -nargs=* -complete=file E e<bang> <args>")
vim.cmd("command! -bang -nargs=* -complete=file W w<bang> <args>")
vim.cmd("command! -bang -nargs=* -complete=file Wq wq<bang> <args>")
vim.cmd("command! -bang -nargs=* -complete=file WQ wq<bang> <args>")
vim.cmd("command! -bang Wa wa<bang>")
vim.cmd("command! -bang WA wa<bang>")
vim.cmd("command! -bang Q   q<bang>")
vim.cmd("command! -bang QA qa<bang>")
vim.cmd("command! -bang Qa qa<bang>")
vim.cmd("command! -bang Tabn tabn<bang>")

-- Fugitive
keyset('n', '<leader>gs', t_builtins.git_status, {})
vim.api.nvim_set_keymap('n', '<leader>gd',  [[:Gdiff<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc',  [[:Git commit<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gb',  [[:Git blame<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gl',  [[:Git log<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp',  [[:Git push<CR>]], { noremap = true, silent = true })

-- Fru fru screen shots
vim.cmd("call minpac#add('narutoxy/silicon.lua')")

require("silicon").setup({
  output = "~/Desktop/silicon-${year}-${month}-${date}-${time}.png",
  font   = 'PragmataPro Mono Liga',
  bgColor = g.terminal_color_4
})
vim.api.nvim_set_keymap('v', '<leader>ss',  [[:lua require("silicon").visualise_api({})<CR>]], { noremap = true, silent = true })

-- Markdown previews
vim.cmd("call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! | call mkdp#util#install()'})")

vim.cmd("call minpac#add('David-Kunz/gen.nvim')")

require('gen').setup({
  model = "ein:latest",
  show_model = true,
  display_mode="split"
})

vim.api.nvim_set_keymap('v', '<leader>]',  ':Gen<CR>', { silent = true, noremap = true })
