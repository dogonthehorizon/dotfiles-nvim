if &shell =~# 'fish$'
    set shell=bash
endif

set packpath^=~/.config/nvim/
packadd minpac

call minpac#init()
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

""" Themes
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('altercation/vim-colors-solarized')
call minpac#add('ryanoasis/vim-devicons')

""" Completion plugins
call minpac#add('neoclide/coc.nvim', {'branch': 'release'})

""" Utilities
call minpac#add('w0rp/ale')
call minpac#add('junegunn/fzf.vim')
call minpac#add('scrooloose/nerdcommenter')
call minpac#add('myusuf3/numbers.vim')
call minpac#add('kien/rainbow_parentheses.vim')
call minpac#add('vim-scripts/restore_view.vim')
call minpac#add('godlygeek/tabular')
call minpac#add('vim-airline/vim-airline')
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

" Change the leader but retain the ability to backwards char search
let mapleader = ","
noremap \ ,

set t_Co=256 "256 color support
set background=light
colorscheme solarized

" Autosave open files when window loses focus
" Note: this doesn't support saving untitled buffers
au FocusLost * silent! wa

" Remove the ugly pipe separator for windows
set fillchars+=vert:\ 

" Enhance the functionality of '%'
runtime macros/matchit.vim


" vim-airline config
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
" end vim-airline config

set pyxversion=3                               " Make sure nvim knows about
set shortmess+=mnrxoOtT                        " Abbrev. of messages (avoids 'hit enter')
set virtualedit=onemore                        " Allow for cursor beyond last character

set backup                                     " allow backups
set backupdir=~/.local/share/nvim/backup
set undofile                                   " persistent undo
set undodir=~/.local/share/nvim/undo
set undolevels=1000
set undoreload=10000

set showmode                                   " Display the current mode
set cursorline                                 " Highlight current line
set clipboard=unnamedplus                          " OSX clipboard access.

set linespace=0                                " No extra spaces between rows
set number                                     " Line numbers on
set showmatch                                  " Show matching brackets/parenthesis
set ignorecase                                 " Case insensitive search
set smartcase                                  " Case sensitive when uc present
set winminheight=0                             " Windows can be 0 line high
set wildmode=list:longest,full                 " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]                  " Backspace and cursor keys wrap too
set scrolljump=5                               " Lines to scroll when cursor leaves screen
set scrolloff=3                                " Minimum lines to keep above and below cursor
set foldenable                                 " Auto fold code
set list
set listchars="tab:›\ ,trail:•,extends:#,nbsp:." " Highlight problematic whitespace
set nowrap                                     " Disable line wrapping by default
set colorcolumn=80                             " Set a visual column marker at 80 chars

set shiftwidth=2                               " Use indents of 2 spaces
set expandtab                                  " Tabs are spaces, not tabs
set tabstop=2                                  " An indentation every two columns
set softtabstop=2                              " Let backspace delete indent

" Automatically wrap j and k to the next/prev line
nnoremap j gj
nnoremap k gk

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

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" For when you forget to sudo.. Really write the file.
cmap w!! w !sudo tee % >/dev/null

if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
endif

""" FZF

" ripgrep
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
set grepprg=rg\ --vimgrep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" Overriding fzf.vim's default :Files command.
" Pass zero or one args to Files command (which are then passed to Fzf_dev). Support file path completion too.
command! -nargs=? -complete=file Files call Fzf_dev(<q-args>)

nnoremap <silent> <C-P> :Files<CR>


" Files + devicons
function! Fzf_dev(qargs)
  let l:fzf_files_options = '--color fg:-1,bg:-1,hl:33,fg+:235,bg+:254,hl+:33 --color info:136,prompt:136,pointer:234,marker:234,spinner:136 --preview "bat --theme=\"Solarized (light)\" --style=numbers,changes --color always {2..-1} | head -'.&lines.'" --expect=ctrl-t,ctrl-v,ctrl-x --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all'

  function! s:files(dir)
    let l:cmd = $FZF_DEFAULT_COMMAND
    if a:dir != ''
      let l:cmd .= ' ' . shellescape(a:dir)
    endif
    let l:files = split(system(l:cmd), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(lines)
    if len(a:lines) < 2 | return | endif

    let l:cmd = get({'ctrl-x': 'split',
                 \ 'ctrl-v': 'vertical split',
                 \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
    
    for l:item in a:lines[1:]
      let l:pos = stridx(l:item, ' ')
      let l:file_path = l:item[pos+1:-1]
      execute 'silent '. l:cmd . ' ' . l:file_path
    endfor
  endfunction

  call fzf#run({
        \ 'source': <sid>files(a:qargs),
        \ 'sink*':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction

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

" ale
" Ensure that Ale uses Stack to properly configure project deps when linting.
let g:ale_linters = {
\  'haskell': ['stack_build', 'stack_ghc'],
\  'python':  ['pylint']
\}

let g:ale_fixers = {
\  'python': ['black'],
\  'go': ['goimports', 'gofmt']
\}

" Fix files automatically on save.
let g:ale_fix_on_save = 1

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

" Maps Coquille commands to <F2> (Undo), <F3> (Next), <F4> (ToCursor)
au FileType coq call coquille#FNMapping()
