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

-- The Javascript World
vim.cmd("call minpac#add('pangloss/vim-javascript')")
vim.cmd("call minpac#add('leafgarland/typescript-vim')")
vim.cmd("call minpac#add('maxmellon/vim-jsx-pretty')")
vim.cmd("call minpac#add('HerringtonDarkholme/yats.vim')")

-- Terraform
vim.cmd("call minpac#add('hashivim/vim-terraform')")

g.terraform_align = 1
g.terraform_fmt_on_save = 1

---- Themes & Fonts
vim.cmd("call minpac#add('yamatsum/nvim-nonicons')")
vim.cmd("call minpac#add('kyazdani42/nvim-web-devicons')")
vim.cmd("call minpac#add('sainnhe/everforest')")

---- Completion plugins
vim.cmd("call minpac#add('neoclide/coc.nvim', {'branch': 'release', 'do': {-> system('yarn install --frozen-lockfile')}})")

vim.cmd("autocmd! CompleteDone * if coc#pum#visible() == 0 | pclose | endif")

-- Too lazy to convert this to Lua.
vim.cmd([[
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]])

-- <TAB>: completion.
vim.api.nvim_set_keymap('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "<Tab>" : coc#refresh()', { expr = true, silent = true, noremap = true })
vim.api.nvim_set_keymap('i', '<cr>', "coc#pum#visible() ? coc#pum#confirm() : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'", { expr = true, silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true })

vim.api.nvim_set_keymap('n', 'gd',  [[<Plug>(coc-definition)]], { silent = true })
vim.api.nvim_set_keymap('n', 'gy',  [[<Plug>(coc-type-definition)]], { silent = true })
vim.api.nvim_set_keymap('n', 'gi',  [[<Plug>(coc-implementation)]], { silent = true })
vim.api.nvim_set_keymap('n', 'gr',  [[<Plug>(coc-references)]], { silent = true })

-- Remap keys for applying codeAction to the current line.
vim.api.nvim_set_keymap('n', '<leader>ac',  [[<Plug>(coc-codeaction)]], { silent = true })
-- Apply AutoFix to problem on the current line.
vim.api.nvim_set_keymap('n', '<leader>qf',  [[<Plug>(coc-fix-current)]], { silent = true })

-- " Use K to show documentation in preview window.
vim.cmd([[
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
]])
 vim.api.nvim_set_keymap('n', 'K', ':call ShowDocumentation()<CR>', { silent = true })

---- Command palette-style plugins
vim.cmd("call minpac#add('nvim-lua/plenary.nvim')")
vim.cmd("call minpac#add('nvim-telescope/telescope.nvim')")
vim.cmd("call minpac#add('nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'})")

---- Status and bufferline plugins

vim.cmd("call minpac#add('nvim-lualine/lualine.nvim')")
vim.cmd("call minpac#add('akinsho/bufferline.nvim', {'rev': 'main'})")

---- Utilities
vim.cmd("call minpac#add('scrooloose/nerdcommenter')")
vim.cmd("call minpac#add('myusuf3/numbers.vim')")
vim.cmd("call minpac#add('kien/rainbow_parentheses.vim')")
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


-- Change the leader but retain the ability to backwards char search
g.mapleader = ","
vim.api.nvim_buf_set_keymap(0, '', '\\', ',', {noremap = true})

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

-- Rainbow parenthesis
vim.cmd("au VimEnter * RainbowParenthesesToggle")
vim.cmd("au Syntax * RainbowParenthesesLoadRound")
vim.cmd("au Syntax * RainbowParenthesesLoadSquare")
vim.cmd("au Syntax * RainbowParenthesesLoadBraces")

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
}

require'nvim-treesitter.parsers'.filetype_to_parsername.mdx = 'markdown'

-- Set the colorscheme in Lua
o.background = 'dark'
g.everforest_enable_italic=1
vim.cmd('colorscheme everforest')

-- Setup devicons
require'nvim-web-devicons'.setup {
  default = true
}
icons = require "nvim-nonicons"

-- setup statusline
require'lualine'.setup {
  options = {
    component_separators = '|',
    section_separators = { left = '', right = '' },
  }
}
require'bufferline'.setup {
  options = {
    separator_style = "slant"
  }
}

telescope = require'telescope'
telescope.load_extension('fzf')
-- Open find_files w/ C-p
vim.api.nvim_set_keymap('n', '<C-p>',  [[:Telescope find_files<CR>]], { noremap = true, silent = true })

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
vim.api.nvim_set_keymap('n', '<leader>gs',  [[:Git<CR>]], { noremap = true, silent = true })
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
