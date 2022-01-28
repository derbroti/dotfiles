set nocompatible
"set term=alacritty
"set term=iTerm2
set term=xterm-256color

set belloff=all

" curly underline
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

set encoding=utf-8

syntax on
colorscheme smyck
hi Comment cterm=italic

"let g:debug_me = ""

" do not show 'search hit BOTTOM'
set shortmess+=s

set wildmenu
" show as list like a terminal
" can't select in them though...
set wildmode=list:longest

" limit pop-up height - currently set for limiting the spell suggestions
set pumheight=10

""""""""""
" air-line
" only load these extensions
" original: ['quickfix', 'netrw', 'term', 'whitespace', 'po', 'wordcount', 'keymap']
let g:airline_extensions = ['netrw', 'term', 'whitespace', 'po', 'keymap', 'searchcount', 'coli']

" the default - modified, slightly, by me
let g:airline_theme='dark'

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.colnr = '|'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.readonly = '[ro]'
let g:airline_symbols.whitespace = 'Ξ'

"""""""

" let g:statuscalled = 0
" let g:refreshcalled = 0
" let g:refresh_hard_called = 0
" let g:tablinecalled = 0
" function! MyTabLine()
"     let g:tablinecalled += 1
"     let s = w:airline_last_m ." ".g:refresh_hard_called. " " .g:refreshcalled. " " .g:statuscalled . " ".g:tablinecalled. " | reg:\"".getreg('/')."\" (". len(getreg('/')).") status:\"".'%{ airline#extensions#searchcount#status(1) }'. "\""
"     return s
" endfun
" set tabline=%!MyTabLine()


" TODO check if still needed - anyrc?
" https://stackoverflow.com/a/3384476/2350114
" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h') . '/.vim'
" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)
" echo &runtimepath

" enable file plugin, detection and indent
filetype plugin indent on

"" line widths and such
"  will be visible in all but normal mode (see coli.vim)
let g:airline#extensions#coli#columns=100
hi ColorColumn ctermbg=235
"set width one less, so the columns line stays clear
set textwidth=99
" the default
set formatoptions=croql
set list
set listchars=tab:•◦,trail:•
" Backspace over indentation, end-of-line, and start-of-line.
set backspace=indent,eol,start

" make uses real tabs
au FileType make set noexpandtab
" Go uses tabs
au FileType go set noexpandtab tabstop=4 shiftwidth=4
" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
au FIleType python let g:airline#extensions#coli#columns=80
au FileType ruby   set softtabstop=2 tabstop=2 shiftwidth=2

" switch mode goes brrrr
set timeoutlen=1000
set ttimeoutlen=5
augroup EscapeGoesBRRRR
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END

set cmdwinheight=10

" set my tabline and set its colors
set tabline=%!MyTabbyLine()
set showtabline=2
hi TabLineFill   ctermfg=DarkBlue
hi TabLineSel    ctermfg=Blue  ctermbg=Black    cterm=None
hi TabLine       ctermfg=Black ctermbg=DarkBlue cterm=None
hi TabLineSelMod ctermfg=231 ctermbg=53 cterm=None

" make the status bar more visible if we have one than one window open
" makes it also more visible if we split vertically, but well... you can't have it all...
fun s:statusColorHack()
    if tabpagewinnr(tabpagenr(), "$") > 1
        let g:airline#themes#dark#palette.normal['airline_c'][3]=235
        let g:airline#themes#dark#palette.normal['airline_x'][3]=235
        let g:airline#themes#dark#palette.normal_modified['airline_c'][3]=235
    else
        let g:airline#themes#dark#palette.normal['airline_c'][3]=234
        let g:airline#themes#dark#palette.normal['airline_x'][3]=234
        let g:airline#themes#dark#palette.normal_modified['airline_c'][3]=234
    endif
endfun
augroup StatusColWhenWin
    autocmd!
    au WinEnter * :call <SID>statusColorHack()
    au WinLeave * :call <SID>statusColorHack()
augroup END

" hack to avoid errors in old vim versions, looking at you rechenknecht...
set cursorline
try
    set cursorlineopt=number
catch
endtry

set number
"set relativenumber
hi CursorLineNr ctermbg=234 ctermfg=11 cterm=None

" toggle rel/abs line numbers (in normal mode only)
" code: ^[[23;2~ mapped to: <cmd>+<esc>
nnoremap <silent> <S-F11> :call airline#extensions#coli#toggleAbsRel()<CR>
inoremap <S-F11> <nop>
vnoremap <S-F11> <nop>

set ttymouse=sgr
set mouse=a
set ruler

"TODO is this a good idea?
set noswapfile
set nobackup
set nowritebackup
" undo goes BRRRRRR
set undolevels=9999

set wrap
set linebreak
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nofoldenable

" prints ''x line yanked'' etc for x starting from 1
set report=0

set hlsearch
set incsearch
set ignorecase
set smartcase
" <ctrl>+c clears search (hides it, reg keeps the value) + clear linenumber highlight
nnoremap <expr><silent><C-c> v:hlsearch ? ":nohl<bar>:call airline#extensions#coli#Cccheck()<CR>" : "<C-c>"
" restore original C-c function when in cmd window (the expr map does not really work here)
au CmdwinEnter * nnoremap <C-c> <C-c>
au CmdWinLeave * nnoremap <expr><silent><C-c> v:hlsearch ? ":nohl<bar>:call airline#extensions#coli#Cccheck()<CR>" : "<C-c>"

" normal->insert->(insert)->search->C-c->linenumber fail
" in short: when pressing C-c from insert mode we need to check the abs/rel numbering
inoremap <nowait><silent><C-c> <ESC><bar>:call airline#extensions#coli#Cccheck()<CR>

hi Search cterm=NONE ctermfg=232 ctermbg=13
hi SearchBar cterm=NONE ctermfg=13 ctermbg=0
hi IncSearch cterm=NONE ctermfg=0 ctermbg=207

" from https://vi.stackexchange.com/a/20661/40602
fun! s:CountTrailingWhites()
  redir => l:cnt
    silent exe '%s/\s\+$//en'
  redir END
  return matchstr( cnt, '\d\+' )
endfun

let g:maxNumTrailWhite = 5
augroup BUFWRITEHELPER
    autocmd!
    " based on: https://stackoverflow.com/q/8309728/2350114
    " Strip trailing whitespaces on each save
    " but ask if there are more than X many if we simply want to keep them (legacy code and not
    " getting annoyed with huge diffs)
    fun s:StripTrailingWhitespaces()
        let l = line(".")
        let c = col(".")
        let l:ctw = <SID>CountTrailingWhites()
        if l:ctw > get(g:, 'maxNumTrailWhite', 50)
            let l:choice = confirm("Found ".l:ctw." trailing whites - keep them?", "&Yes\n&No", 1)
            if l:choice == 2
                "prevents 'press enter to continue' dialog
                :set cmdheight=4
                %s/\s\+$//e
            endif
            :set cmdheight=1
            :redraw
        else
            %s/\s\+$//e
        endif
        call cursor(l, c)
    endfun
    au BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END

" don't show mode or status - airline does this
" but do show command
set showcmd
set noshowmode
set laststatus=0

" from: https://stackoverflow.com/a/6271254/2350114
fun s:get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    exec ':match HighlightMatch /' . join(lines, '\n') . '/'
endfunction

hi HighlightMatch cterm=NONE ctermfg=Black ctermbg=6
" press * to match word under cursor
nnoremap <silent> * :exec 'match HighlightMatch /'.expand('<cword>').'/'<CR>
" works for multiple lines in visual(block) mode
vnoremap <silent> * :call <SID>get_visual_selection()<CR>
" clear highlighted word
" code: ^[[24;2~ mapped to: <shift>+<alt>++
nnoremap <silent> <S-F12> :match<CR>

" TODO maybe some day...
"" alt+j
"nnoremap º gj
"vnoremap º gj
"" alt+k
"nnoremap ∆ gk
"vnoremap ∆ gk
"" alt+4
"nnoremap ¢ g$
"vnoremap ¢ g$

" map alt+up/down to not jump over wrapped lines
nnoremap <M-Up> gk
vnoremap <M-Up> gk
inoremap <M-Up> <C-o>gk
nnoremap <M-Down> gj
vnoremap <M-Down> gj
inoremap <M-Down> <C-o>gj

" scroll only one line
set scroll=1
nnoremap <silent> <ScrollWheelUp> <C-y>
nnoremap <silent> <ScrollWheelDown> <C-e>
inoremap <silent> <ScrollWheelUp> <C-x><C-y>
inoremap <silent> <ScrollWheelDown> <C-x><C-e>
vnoremap <silent> <ScrollWheelUp> <C-y>
vnoremap <silent> <ScrollWheelDown> <C-e>

" enable ctrl+z (suspend to background) while in insert mode
" in all other modes it works automagically
inoremap <silent> <C-z> <C-o>:stop<cr>

" move cursor multiple lines (compare tmux settings)
nnoremap <S-Up> 5k
nnoremap <S-Down> 5j
inoremap <S-Up> <C-o>5k
inoremap <S-Down> <C-o>5j
vnoremap <S-Up> 5k
vnoremap <S-Down> 5j
" super fast S-F9 code:  ^[[20;2~ mapped to: <shift>+<alt>+<up>
"            S-F10 code: ^[[21;2~ mapped to: <shift>+<alt>+<down>
nnoremap <S-F9> 10k
nnoremap <S-F10> 10j
inoremap <S-F9> <C-o>10k
inoremap <S-F10>  <C-o>10j
vnoremap <S-F9> 10k
vnoremap <S-F10> 10j

" scroll to top/bottom
nnoremap <silent> <C-Up> :0<CR>
nnoremap <silent> <C-Down> :$<CR>
inoremap <silent> <C-Up> <C-o>:0<CR>
inoremap <silent> <C-Down> <C-o>:$<CR>
vnoremap <silent> <C-Up> gg<CR>
vnoremap <silent> <C-Down> <S-g>

" map leader to <space> (for custom shortcuts without modifier keys)
let mapleader = ' '
" deactivate space - in case we press leader and nothing else, we would otherwise move the cursor
nnoremap <space> <nop>
" tabs
nnoremap <silent> <leader>c :tabnew<CR>
nnoremap <silent> <leader><leader><Right> gt
nnoremap <silent> <leader><leader><Left> gT
" windows

nnoremap <silent> <leader><Up> <C-w><Up>
nnoremap <silent> <leader><Down> <C-w><Down>
nnoremap <silent> <leader><Left> <C-w><Left>
nnoremap <silent> <leader><Right> <C-w><Right>

" spell check
hi SpellBad   cterm=italic,undercurl ctermfg=None ctermbg=None ctermul=196
hi SpellLocal cterm=italic,undercurl ctermfg=None ctermbg=None ctermul=201
hi SpellCap   cterm=undercurl        ctermfg=None ctermbg=None ctermul=46
hi SpellRare  cterm=undercurl        ctermfg=None ctermbg=None ctermul=45
nnoremap <silent> <leader>6 :set spell! spelllang=en_us<CR>
" suggest at most 10 corrections
set spellsuggest=best,10
set spellfile=~/.vim/spell/my-words.utf-8.add
" based on: https://stackoverflow.com/q/25777205/2350114
"           https://stackoverflow.com/a/25777332/2350114
nnoremap <expr> <leader>s &spell ? "a<C-x><C-s>" : ""
inoremap <expr> <CR> pumvisible() ? "<C-y><Esc>" : "<CR>"

" do not set a clipboard - we manually manage the register
set clipboard=
