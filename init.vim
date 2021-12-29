if &shell =~# 'fish$'
    set shell=bash
endif

" Enable better colors in neovim
set termguicolors
syntax enable

" Shift key fixes
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q   q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
    command! -bang Tabn tabn<bang>
endif


""" Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>

"""" coc.nvim
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>""
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Terraform settings
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

""" Rainbow Parenthesis
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" XML formatter
function! DoFormatXML() range
    " Save the file type
    let l:origft = &ft

    " Clean the file type
    set ft=

    " Add fake initial tag (so we can process multiple top-level elements)
    exe ":let l:beforeFirstLine=" . a:firstline . "-1"
    if l:beforeFirstLine < 0
        let l:beforeFirstLine=0
    endif
    exe a:lastline . "put ='</PrettyXML>'"
    exe l:beforeFirstLine . "put ='<PrettyXML>'"
    exe ":let l:newLastLine=" . a:lastline . "+2"
    if l:newLastLine > line('$')
        let l:newLastLine=line('$')
    endif

    " Remove XML header
    exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

    " Recalculate last line of the edited code
    let l:newLastLine=search('</PrettyXML>')

    " Execute external formatter
    exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

    " Recalculate first and last lines of the edited code
    let l:newFirstLine=search('<PrettyXML>')
    let l:newLastLine=search('</PrettyXML>')

    " Get inner range
    let l:innerFirstLine=l:newFirstLine+1
    let l:innerLastLine=l:newLastLine-1

    " Remove extra unnecessary indentation
    exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

    " Remove fake tag
    exe l:newLastLine . "d"
    exe l:newFirstLine . "d"

    " Put the cursor at the first line of the edited code
    exe ":" . l:newFirstLine

    " Restore the file type
    exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

set packpath^=~/.config/nvim/
packadd minpac

lua <<EOF

vim.call('minpac#init')

-- global options
local o = vim.o
local g = vim.g
-- window options
local wo = vim.wo
-- buffer options
local bo = vim.bo
-- vim options?
local opt = vim.opt

g.mapleader = ","
-- Change the leader but retain the ability to backwards char search
vim.api.nvim_buf_set_keymap(0, '', '\\', ',', {noremap = true})

-- Make sure nvim knows about the Python version we prefer
o.pyxversion = 3
-- Abbrev. of messages (avoids 'hit enter')
opt.shortmess:append "mnrxoOtT"
-- Allow for cursor beyond last character
o.virtualedit = "onemore"

-- Turn on backups
o.backup = true
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

-- Use indents of 2 spaces
o.shiftwidth = 2
-- Tabs are spaces, not tabs
o.expandtab = true
-- An indentation every two columns
o.tabstop = 2
-- Let backspace delete indent
o.softtabstop = 2

-- Autosave open files when window loses focus
-- NOTE: doesn't work w/ untitled buffers
-- TODO: move to lua-native autocmd when it's released
vim.cmd('au FocusLost * silent! wa')

-- TreeSitter config
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

-- Set the colorscheme in Lua
vim.cmd('set background=light')
vim.cmd('colorscheme solarized-flat')

-- Setup devicons
require'nvim-web-devicons'.setup {
  default = true
}
icons = require "nvim-nonicons"

-- setup statusline
require'lualine'.setup {
  options = {
    theme = 'solarized_light'
  }
}
require'bufferline'.setup {
  options = {
    separator_style = "slant"
  }
}

telescope = require'telescope'

telescope.load_extension('fzf')
EOF

call minpac#add('k-takata/minpac', {'type': 'opt'})

""" Language Specific Plugins
" Haskell
call minpac#add('neovimhaskell/haskell-vim')

"Fish
call minpac#add('dag/vim-fish')

" The Javascript World
call minpac#add('pangloss/vim-javascript')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('maxmellon/vim-jsx-pretty')
call minpac#add('HerringtonDarkholme/yats.vim')

" Terraform
call minpac#add('hashivim/vim-terraform')

""" Themes & Fonts
call minpac#add('yamatsum/nvim-nonicons')
call minpac#add('kyazdani42/nvim-web-devicons')
call minpac#add('ishan9299/nvim-solarized-lua')

""" Completion plugins
call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})

""" Command palette-style plugins
call minpac#add('nvim-lua/plenary.nvim')
call minpac#add('nvim-telescope/telescope.nvim')
call minpac#add('nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'})

""" Status and bufferline plugins

call minpac#add('nvim-lualine/lualine.nvim')
call minpac#add('akinsho/bufferline.nvim')

""" Utilities
call minpac#add('scrooloose/nerdcommenter')
call minpac#add('myusuf3/numbers.vim')
call minpac#add('kien/rainbow_parentheses.vim')
call minpac#add('vim-scripts/restore_view.vim')
call minpac#add('godlygeek/tabular')
call minpac#add('Townk/vim-autoclose')
call minpac#add('tpope/vim-fugitive')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('nathanaelkane/vim-indent-guides')
call minpac#add('dbakker/vim-lint')
call minpac#add('guns/vim-sexp')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-vinegar')
call minpac#add('tpope/vim-obsession')

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

nnoremap <silent> <C-P> :Telescope find_files<CR>
