set nocompatible
"set term=alacritty
set term=xterm-256color

" do not allow code exec in modelines
set nomodelineexpr

set belloff=all

" curly underline
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

set encoding=utf-8

" used for anyrc
" https://stackoverflow.com/a/3384476/2350114
" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
" what is the name of the directory containing this file?
" https://stackoverflow.com/a/18734557/8205759
let s:vimrc_path = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/.vim'
" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:vimrc_path, &runtimepath, s:vimrc_path)
" echo &runtimepath

syntax on
colorscheme smyck
hi Comment cterm=italic

" automatically change working directory on file open / (buffer/window) switch
set autochdir

" do not show 'search hit BOTTOM'
set shortmess+=s

set wildmenu
" show as list like a terminal
" can't select in them though...
set wildmode=list:longest

" limit pop-up height - currently set for limiting the spell suggestions
set pumheight=10

" keep 1000 entries in the history (useful for searching)
set history=1000

" keep split views equal in size
autocmd VimResized * wincmd =

""""""""""
" air-line
" only load these extensions
" original: ['quickfix', 'netrw', 'term', 'whitespace', 'po', 'wordcount', 'keymap']
let g:airline_extensions = ['netrw', 'term', 'whitespace', 'searchcount', 'coli']

" the default - modified, slightly, by me
let g:airline_theme='dark'

" react to focus events
let g:airline_focuslost_inactive = 1

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
let g:airline_symbols.whitespace = ''
let g:airline_symbols.ellipsis = '…'

" mode names
let g:airline_mode_map = {
    \ 'niI' : 'I-(NORMAL)',
    \ 'niR' : 'R-(NORMAL)',
    \ 'niV' : 'vR-(NORMAL)',
    \ 'ic' : 'INSERT COMPL GEN',
    \ 'Rc' : 'REPLACE COMP GEN'
    \ }

" algo1: - do not do: <tab><space><tab>
"        - do not have more spaces than tab-width
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#whitespace#mixed_indent_format = "[%s]…"
let g:airline#extensions#whitespace#mixed_indent_file_format = "[%s]⋮"


"""""""
"
" diff/merge config

fun s:diffview()
    wincmd l " focus middle window
    " always start on line 1
    exec 'norm gg'
endfun

if &diff
    autocmd VimEnter * :call <SID>diffview()
endif



"""""""

"""""""
" netrw
"

" tree
let g:netrw_liststyle = 3
"disable i (changing liststyle)
au FileType netrw nnoremap <buffer> i <nop>
" open file in previous window
let g:netrw_browse_split = 4
" open file on right side
let g:netrw_altv = 1
" 20%
let g:netrw_winsize = 20
" no header in file list
let g:netrw_banner = 0
" more colors
let g:netrw_special_syntax = 1
" highlight line
let g:netrw_bufsettings = "noma nomod nonu nobl nowrap ro nornu cursorlineopt=line"
"do not sort by folders first
let g:netrw_sort_sequence = ''
" always get fresh dir listing
let g:netrw_fastbrowse = 0
" show errors only
let g:netrw_errorlvl = 2
" show errors as echoerr
let g:netrw_use_errorwindow = 0
" do not open external program
let g:netrw_nogx = 1
" disable x map completely
au FileType netrw nnoremap <buffer> x <nop>
" disable bookmark history?! - throws errors..
let g:netrw_dirhistmax = 0
" show preview in vert-split
let g:netrw_preview = 1
" disable mouse buttons - see below for our replacements
let g:netrw_mousemaps = 0

" split new buffer to the right
set splitright

""""""

" do not yank everything into clipboard, only */+ reg
set clipboard=

if has('independent_clip_regs')
    set icr=star,plus

    " based on: https://sunaku.github.io/tmux-yank-osc52.html
    augroup RemoteYank
        autocmd!
        fun Yank(text) abort
            if ! empty($SSH_CLIENT)
                if ! has('clipboard_working') && ! has('independent_clip_regs') && (v:event.regname == '')
                    echohl ErrorMsg | echo "Err: Neither a working clipboard nor a working star reg found!" | echohl None
                elseif v:event.regname == '*'
                    let escape = system('~/.anyrc/.anyrc.d/.tmux/yank.sh', a:text)
                    if v:shell_error
                        echohl ErrorMsg | echo "Err: \"".escape."\"" | echohl None
                    else
                        if empty(a:text)
                            call setreg(v:event.regname, escape)
                        endif
                    endif
                endif
            endif
        endfun

        fun WriteYank() abort
            call Yank(getreg(v:event.regname))
        endfun

        fun ReadYank() abort
            call Yank('')
        endfun

        autocmd WriteClipPost * call WriteYank()
        autocmd ReadClipPre   * call ReadYank()
    augroup END
endif

" enable file plugin, detection and indent
filetype plugin indent on

" do not draw a vsplit indicator
" but use color
set fillchars+=vert:\ ,
hi VertSplit ctermbg=235
hi StatusLine ctermbg=235
" colors the bottom intersection
hi StatusLineNC ctermbg=235

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
au FIleType python let g:airline#extensions#coli#columns+=80
au FileType ruby   set softtabstop=2 tabstop=2 shiftwidth=2

au FileType mkern set listchars=tab:◦\ ,trail:•

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
" initial - will be replaced on focus change in coli.vim
hi TabLineFill   ctermfg=DarkBlue
hi TabLine       ctermfg=Black ctermbg=DarkBlue cterm=None
hi TabLineSel    ctermfg=Blue  ctermbg=Black    cterm=None
hi TabLineSelMod ctermfg=129   ctermbg=Black    cterm=None
hi TabLineMod    ctermfg=201   ctermbg=DarkBlue cterm=Bold

" make the status bar more visible if we have one than one window open
" makes it also more visible if we split vertically, but well... you can't have it all...
augroup StatusColWhenWin
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

" insert mode cursor: orange bar; other modes cursor: white block
let &t_SI = "\e[6 q\e]12;orange\x7"
let &t_SR = "\e[2 q\e]12;white\x7"
let &t_EI = "\e[2 q\e]12;white\x7"

set number
"expect to start at line 1 -> abs mode
set norelativenumber

" toggle rel/abs line numbers (in normal mode only)
" M-F7 code: ^[[18;2~ mapped to: <alt>+<esc>
nnoremap <silent> <M-F7> :call airline#extensions#coli#toggleAbsRel()<CR>
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
nnoremap <expr><silent><C-c> v:hlsearch ? ":nohl<bar>:call airline#extensions#coli#Cccheck()<CR><bar>:call <SID>NetrwAutoHScroll()<cr>" : "<C-c>"
" restore original C-c function when in cmd window (the expr map does not really work here)
au CmdwinEnter * nnoremap <C-c> <C-c>
au CmdWinLeave * nnoremap <expr><silent><C-c> v:hlsearch ? ":nohl<bar>:call airline#extensions#coli#Cccheck()<CR>" : "<C-c>"

" normal->insert->(insert)->search->C-c->linenumber fail
" in short: when pressing C-c from insert mode we need to check the abs/rel numbering
inoremap <nowait><silent><C-c> <ESC><bar>:call airline#extensions#coli#Cccheck()<CR>

hi Search cterm=NONE ctermfg=232 ctermbg=13
hi IncSearch cterm=NONE ctermfg=0 ctermbg=207
" initial - will be replaced on focus change in coli.vim
hi SearchBar cterm=NONE ctermfg=13 ctermbg=0

" from https://vi.stackexchange.com/a/20661/40602
fun! s:CountTrailingWhites()
  redir => l:cnt
    silent exe '%s/\s\+$//en'
  redir END
  return matchstr( cnt, '\d\+' )
endfun

command W :noautocmd :w

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
            let l:choice = confirm("Found ".l:ctw." trailing whites - keep them?", "&Yes\n&No\n&Cancel", 1)
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
fun s:GetVisualLineSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, '\n')
endfunction

fun s:HighlightVisualSelection()
    exec ':match HighlightMatch /' . <SID>GetVisualLineSelection() . '/'
endfun

hi HighlightMatch cterm=NONE ctermfg=Black ctermbg=6
" press * to match word under cursor
nnoremap <silent> * :exec 'match HighlightMatch /'.expand('<cword>').'/'<CR>
" works for multiple lines in visual(block) mode
vnoremap <silent> * :call <SID>HighlightVisualSelection()<CR>
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

" C-y is our tmux prefix, so do not scroll when we press it in vim
" scroll-wheel scrolling still works
nnoremap <C-y> <nop>

" enable ctrl+z (suspend to background) while in insert mode
" in all other modes it works automagically
inoremap <silent> <C-z> <C-o>:stop<cr>

" move cursor multiple lines (compare tmux settings)
nnoremap <S-Up> 5k
nnoremap <S-Down> 5j
inoremap <silent> <S-Up> <C-o>5k
inoremap <silent> <S-Down> <C-o>5j
vnoremap <S-Up> 5k
vnoremap <S-Down> 5j
" super fast S-F9  code: ^[[20;2~ mapped to: <shift>+<alt>+<up>
"            S-F10 code: ^[[21;2~ mapped to: <shift>+<alt>+<down>
nnoremap <S-F9> 10k
nnoremap <S-F10> 10j
inoremap <silent> <S-F9> <C-o>10k
inoremap <silent> <S-F10>  <C-o>10j
vnoremap <S-F9> 10k
vnoremap <S-F10> 10j

" scroll to top/bottom
nnoremap <silent> <C-Up> :0<CR>
nnoremap <silent> <C-Down> :$<CR>
inoremap <silent> <C-Up> <C-o>:0<CR>
inoremap <silent> <C-Down> <C-o>:$<CR>
vnoremap <silent> <C-Up> gg<CR>
vnoremap <silent> <C-Down> <S-g>

" make consistent to zsh and macos
" <alt>+<left/right> jumps words
nnoremap <M-Left> b
nnoremap <M-Right> e
" inoremap <silent><nowait> <M-Left> <c-o>b
" inoremap <silent><nowait> <M-Right> <c-o>e
vnoremap <M-Left> b
vnoremap <M-Right> e
cnoremap <M-Left> <S-Left>
cnoremap <M-Right> <S-Right>
" <ctrl>+<left/right> jumps to start/end of line
nnoremap <C-Left> 0
nnoremap <C-Right> $
" inoremap <silent><nowait> <C-Left> <c-o>0
" inoremap <silent><nowait> <C-Right> <c-o>$
vnoremap <C-Left> 0
vnoremap <C-Right> $
cnoremap <C-Left> <C-b>
cnoremap <C-Right> <C-e>

" shift+mouseclick scrolls down?!
" TODO this does not fix it...
" nnoremap <S-leftmouse> <nop>
" inoremap <S-leftmouse> <nop>
" vnoremap <S-leftmouse> <nop>

" <fn>+<enter>
" toggle paste mode
nnoremap <silent> <ins> :set paste!<cr>

" M-tab
" toggle replacing tabs with spaces
nnoremap <silent> [1;88P :set expandtab!<cr>
" TODO why does this still trigger expandtab???
" right now we get kicked out of insert mode...
inoremap <silent> [1;88P <nop>

" map leader to <space> (for custom shortcuts without modifier keys)
let mapleader = ' '
" deactivate space - in case we press leader and nothing else, we would otherwise move the cursor
nnoremap <space> <nop>
" buffer
nnoremap <silent> <leader>n :call <SID>CheckIfNetrwOnlyOpen()<cr>
" tabs
nnoremap <silent> <leader>c :tabnew<CR>
" prev tab / next tab
" M-F10 code: ^[[21;3~ mapped to <fn>+<cmd>+<alt>+<left>
" M-F11 code: ^[[23;3~ mapped to <fn>+<cmd>+<alt>+<right>
nnoremap <silent> <M-F10> gT
nnoremap <silent> <M-F11> gt
" windows
" C-F{1 2 4} code: ^[[{1;5P 1;5Q 1;5S} mapped to <fn>+<cmd>+{<left> <right> <down>}
" M-F4       code: ^[[1;3S mapped to <fn>+<cmd>+<up>
nnoremap <silent> [1;5P <C-w><Left>
nnoremap <silent> [1;5Q <C-w><Right>
nnoremap <silent> [1;3S <C-w><Up>
nnoremap <silent> [1;5S <C-w><Down>

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
" TODO breaks normal ctrl-p... drops us out of insert mode
"inoremap <expr> <CR> pumvisible() ? "<C-y><Esc>" : "<CR>"

" TODO make them pretty
" popup colors
hi Pmenu      cterm=none ctermfg=black ctermbg=white
hi PmenuSel   cterm=none ctermfg=black ctermbg=blue
hi PmenuSbar  cterm=none ctermfg=black ctermbg=white
hi PmenuThumb cterm=none ctermfg=white ctermbg=darkblue

"""""""""""""""""
" netrw continued

" width in chars
let s:NetrwWidth = 30

fun s:ResizeNetrw(percent, win)
    :exec 'vert '.a:win.'res '.string(min([float2nr(floor(&columns * a:percent)), s:NetrwWidth]))
    let s:cur_nw_perc=a:percent
endfun

augroup AutoResizeNetrw
    fun s:AutoResizeNetrw()
        let l:win = filter(range(1, winnr('$')), 'getwinvar(v:val, "&filetype") == "netrw"')
        for l:w in l:win
            call <SID>ResizeNetrw(0.2, l:w)
        endfor
    endfun
    autocmd!
    " resize file browser if adequate
    autocmd VimResized * :call <SID>AutoResizeNetrw()
augroup END

" toggle open file browser - ensure that it is only 20% wide
nnoremap <silent> <leader><tab> :Lexplore<CR><bar>:call <SID>ResizeNetrw(0.2, '')<CR>

" if it is a folder: just switch to it
" if it is a file: check if there is an open window, otherwise open an empty one
" so netrw will open the file in the right spot
fun! NetrwOpenThis(islocal)
    "TODO: what if not is local?
    let l:word = netrw#Call('NetrwGetWord')
    if l:word !~ '[\/]$'
        if winnr('$') == 1
            :vnew
            " select previous window => the netrw browser
            wincmd p
            call <SID>ResizeNetrw(0.2, '')
        endif
    endif
    let l:dir = netrw#Call('NetrwBrowseChgDir', 1, l:word)
    call netrw#LocalBrowseCheck(l:dir)
endfun

fun! s:LeftMouse(islocal)
    call <SID>MouseClick(a:islocal, 0)
endfun

fun! s:MouseClick(islocal, file)
    if &ft != "netrw"
        return
    endif
    let ykeep= @@
    " check if the status bar was clicked on instead of a file/directory name
    while getchar(0) != 0
        "clear the input stream
    endwhile

    let c          = getchar()
    let mouse_lnum = v:mouse_lnum
    let wlastline  = line('w$')
    let lastline   = line('$')
    if mouse_lnum >= wlastline + 1 || v:mouse_win != winnr()
        let @@= ykeep
        return
    endif

    if a:islocal
        if exists("b:netrw_curdir")
            let l:word = netrw#Call('NetrwGetWord')
            if l:word =~ '[\/]$'
                let l:dir = netrw#Call('NetrwBrowseChgDir', 1, l:word)
                NetrwKeepj call netrw#LocalBrowseCheck(l:dir)
            elseif a:file
                call NetrwOpenThis(a:islocal)
            endif
        endif
    else
        echoerr "remote click not yet implemented - derbroti"
    " TODO...
    " else
    "     if exists("b:netrw_curdir")
    "         NetrwKeepj call s:NetrwBrowse(0,s:NetrwBrowseChgDir(0,s:NetrwGetWord()))
    "     endif
    endif
    let @@= ykeep
endfun

let g:Netrw_UserMaps = [["<cr>","NetrwOpenThis"]]

" netrw_usermaps does not work, as we can not first feed <leftmouse>...
au FileType netrw nnoremap <buffer><silent> <leftmouse> <leftmouse>:call <SID>LeftMouse(1)<cr>
au FileType netrw nnoremap <buffer><silent> <2-leftmouse> :<C-u>call <SID>MouseClick(1, 1)<cr>

fun s:NetrwAutoHScroll()
    " go to first col in line
    normal 0
    let l:line = getline(".")
    let l:cnt = 0
    for l:i in l:line
        " my netrw is set to print depth as spaces
        if l:i == ' '
            let l:cnt += 1
        else
            break
        endif
    endfor
    " leave one space so the cursor occupies it and does not sit on the first letter
    if l:cnt > 1
        exe 'normal z'.(l:cnt-1).'l'
    endif
endfun

fun s:relResizeNetrw(inc)
    let s:cur_nw_perc=get(s:, 'cur_nw_perc', 0.3) + a:inc
     :exec 'vert res '.string(float2nr(floor(&columns * s:cur_nw_perc)))
endfun

" scroll so far that as much as possible of the file name is visible
au CursorMoved * if &ft=='netrw'|:call <SID>NetrwAutoHScroll()|endif

" widen the view - in case of long file names
au FileType netrw nnoremap <buffer><silent> <tab> :call <SID>relResizeNetrw(0.05)<cr>
" shrink back to orig. size
au FileType netrw nnoremap <buffer><silent> <S-tab> :call <SID>ResizeNetrw(0.2, '')<CR>

fun s:CheckIfOnlyWindowClose()
    if winnr('$') == 1 && &ft == 'netrw'
        :quit
    endif
endfun

fun s:CheckIfNetrwOnlyOpen()
    if &ft == 'netrw'
        if winnr('$') == 1
            :vnew
            wincmd p
            call <SID>ResizeNetrw(0.2, '')
        else
            " do nothing
        endif
    else
        if ! getbufvar('%', '&modified')
            :enew
        else
            :echohl WarningMsg | echo "Have unsaved buffer..."| echohl None
        endif
    endif
endfun

" quit if we are the last window
" Note: to close a buffer without quitting: use :bd
" (overwrites ex mode...)
nnoremap <silent> Q :quit<cr><bar>:call <SID>CheckIfOnlyWindowClose()<cr>

"if we have a search in netrw, n would not work together with autohscroll...
" <shift>+n just works...
" this jumps down one line and then looks for the next match
" Note: this will skip a further match in a line
au FileType netrw nnoremap <buffer><silent><expr> n &ft=='netrw' ? 'jn':'n'

"""""""""""""""""
fun! s:GetBuffers()
    let l:bufs = getbufinfo()
    let l:dict = {'items': [], 'bufnr': []}
    for l:buf in l:bufs
        let l:type = getbufvar(l:buf.bufnr, '&ft')
        " ignore help, netrw, and all unloaded and unlisted buffers
        if l:type == 'help' || l:type == 'netrw' || ! (l:buf.loaded || l:buf.listed)
            continue
        endif
        " TODO shorten names...
        " airline#util#shorten(getreg('/'), 300, 8)
        let l:name = (empty(l:buf.name) ? '[No Name]' : l:buf.name)
        call add(l:dict['items'], '('.l:buf.bufnr.') '.l:name)
        call add(l:dict['bufnr'], l:buf.bufnr)
    endfor
    return l:dict
endfun

fun s:SelectBuffer(id, result)
    if a:result > 0
        if ! getbufvar('%', '&modified')
            exec 'b ' . s:Buffers['bufnr'][a:result - 1]
        else
            :echohl WarningMsg | echo "Have unsaved buffer..."| echohl None
        endif
    endif
endfun

fun s:BufferPopup()
    let s:Buffers = <SID>GetBuffers()
    call popup_menu(s:Buffers['items'], #{title: "Select Buffer",
                                        \ padding: [0,1,0,1],
                                        \ borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                                        \ callback: '<SID>SelectBuffer'}
                                        \ )
endfun

" open buffer selection popup - the selected buffer is opened in the current window
nnoremap <silent> <leader>? :call <SID>BufferPopup()<cr>


" based on: https://github.com/cjuniet/clang-format.vim
" The visual selection mode replaces only the selected lines
fun s:ClangFormat(vis) range
    if (&ft != 'c' && &ft != 'cpp')
       return
    endif
    if (executable("clang-format") != 1)
        echoerr "clang-format not found!"
        return
    endif

    " line and col each start at one
    let l:cursor = line2byte(line(".")) + col(".") -2
    let l:scroll = line('w$')

    let l:cmd  = "clang-format --style=file:" . s:vimrc_path . "/formatter/.clang-format"
    let l:args = " -cursor=" . l:cursor

    if (a:vis)
        " In visual mode we pass the file from line 1 till the
        " bottom of the selection, making sure that indentations work.
        let l:args .= " -lines=" . a:firstline . ":" . a:lastline
        let l:inp   = join(getline(1, a:lastline), "\x0a")
    else
        let l:inp = join(getline(1, '$'), "\x0a")
    endif

    let l:formatted  = system(l:cmd . l:args, l:inp)
    let l:form_lines = split(l:formatted, '\n')
    let l:header     = remove(l:form_lines, 0)

    " clang-format header example:
    " { "Cursor": 2092, "IncompleteFormat": false }
    "
    if match(l:header, 'false') == -1
        echoerr "Error: Incomplete format!"
        return
    endif

    let l:cursor = matchstr(l:header, '"Cursor": \zs\d\+\ze')
    if (l:cursor == "")
        echoerr "Error: No cursor information received - stopping"
        return
    endif
    let l:cursor += 1 " vim starts counting at 1

    if (a:vis)
        " Since we chopped of all lines below our selection, we can make sure
        " to pick only the replaced lines (even if the formatted code is now shorter or longer)
        " by chopping of everything above our selection
        let l:form_lines = l:form_lines[a:firstline-1:] " zero-indexed array

        " delete the entire selection (i.e.: the old code)
        " puts us on the first line after the selection
        silent :'<,'>d
        " insert formatted code
        " since we are on the first line below the deleted selection
        " we have to insert our text above (-1) the current line / the original selection
        silent call append(a:firstline -1, l:form_lines)
    else
        silent :%delete _
        call setline(1, l:form_lines)
    endif

    exec 'norm ' . l:scroll . 'z-'
    exec 'goto ' . l:cursor
endfun

exec "set <M-f>=\e[99;10~"
nnoremap <silent> <M-f> :call <SID>ClangFormat(0)<cr>
vnoremap <silent> <M-f> :call <SID>ClangFormat(1)<cr>

" jump to last cursor position when opening files
" from: :help restore-cursor
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' && &ft != 'netrw'
    \ |   exe "normal! g`\""
    \ | endif
