set nocompatible
set encoding=utf-8
set term=xterm-256color

syntax on
colorscheme smyck

let mapleader = ' '
let g:unnamed_buffer_name = '[No Name]'

" curly underline
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" TODO
" double, dotted and dasehd underlines
" let &t_Us = "\e[4:2m"
" let &t_ds = "\e[4:4m"
" let &t_Ds = "\e[4:5m"

" italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" insert mode cursor: white bar; other modes cursor: white block
let &t_SI = "\e[6 q\e]12;white\x7"
let &t_SR = "\e[2 q\e]12;white\x7"
let &t_EI = "\e[2 q\e]12;white\x7"

" do not allow code exec in modelines
set nomodelineexpr

set belloff=all

" set to speedup tagbar's refresh
set updatetime=1500

set signcolumn=number

" allow visual block to select rectangle, even if lines are too short
set virtualedit=block

set noautochdir

" do not show 'search hit BOTTOM'
set shortmess+=s
" do not show completion messages like 'match 1 of 2'
set shortmess+=c

set wildmenu
" show as list like a terminal
" can't select in them though...
set wildmode=list:longest

" limit pop-up height
set pumheight=10

" keep 1000 entries in the history (useful for searching)
set history=1000

set nobackup
set nowritebackup

set swapfile
" double slash: swap file name is build from its complete path name
let s:swp_dir = g:vimrc_path . '/.safetynet/swp//'
if !isdirectory(s:swp_dir)
    call mkdir(s:swp_dir, 'p', 0700)
endif
" swap directory
let &directory = s:swp_dir

set undofile
" undo goes BRRRRRR
set undolevels=9999
let s:undo_dir = g:vimrc_path . '/.safetynet/undo//'
if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p', 0700)
endif
let &undodir = s:undo_dir

" split new buffer to the right
set splitright

" do not yank everything into clipboard, only */+ reg
set clipboard=

" enable file plugin, detection and indent
filetype plugin indent on

" do not draw a vsplit indicator
" but use color
set fillchars+=vert:\\xa0

set textwidth=159 " TODO was: 99
set colorcolumn=+1 " = textwidth + 1

set formatoptions=croql

set list
set listchars=tab:•◦,trail:•

fun s:multispace(w)
    return repeat('\\xa0', a:w) . repeat(''.repeat('\\xa0', a:w-1), 12*a:w)
endfun
au BufWinEnter * exec 'setlocal listchars+=leadmultispace:' . s:multispace(or(&shiftwidth, &tabstop))

" Backspace over indentation, end-of-line, and start-of-line.
set backspace=indent,eol,start

" switch mode goes brrrr
set timeoutlen=1000
set ttimeoutlen=5
augroup EscapeGoesBRRRR
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END

set cmdwinheight=10

let g:tablineIgnoreFt = ['ctrlsf']
set tabline=%!MyTabbyLine()
set showtabline=2

set sessionoptions=globals,blank,buffers,tabpages,winsize,terminal

set cursorline
set cursorlineopt=number

set number
" will be changed by coli plugin
set norelativenumber

set mouse=a
set ttymouse=sgr

set ruler

set wrap
set linebreak
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nofoldenable
set foldcolumn=0

" prints ''x line yanked'' etc for x starting from 1
set report=0

set hlsearch
set incsearch
set ignorecase
set smartcase

" don't show mode or status - airline does this
" but do show command
set showcmd
set noshowmode

" suggest at most 10 corrections
set spellsuggest=best,10
set spellfile=~/.vim/spell/my-words.utf-8.add

" set to the vim default
set completeopt=menu,preview

set rtp+=/opt/homebrew/opt/fzf

