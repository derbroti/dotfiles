"""""""

"""""""
" netrw
"

" tree
let g:netrw_liststyle = 3
" disable i (changing liststyle)
au FileType netrw nnoremap <buffer> i <nop>
" disable t (interferes with tagbar maps)
au FileType netrw nnoremap <buffer> t <nop>
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
"do sort by folders first - breaks already broken netrw...
"let g:netrw_sort_sequence = '[\/]$'
let g:netrw_sort_sequence = ''
" sort case independent
let g:netrw_sort_options = "i"
" always get fresh dir listing
" TODO this is a workaround for https://github.com/vim/vim/issues/9807
let g:netrw_fastbrowse = 2
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

" force cursor to always be leftmost, to not be in the way
au FileType netrw nnoremap <buffer> <up> 0k
au FileType netrw nnoremap <buffer> <down> 0j

" width in chars
let s:NetrwWidth = 30

fun ResizeFileBrowser(percent, win)
    :exec 'vert '.a:win.'res '.string(min([float2nr(floor(&columns * a:percent)), s:NetrwWidth]))
    let s:cur_nw_perc=a:percent
    if &ft == 'netrw'
        if exists("b:netrw_curdir")
            let g:netrw_winsize = min([float2nr(floor(&columns * a:percent)), s:NetrwWidth])
            call netrw#Call('NetrwRefresh', 1, w:netrw_treetop)
        endif
    elseif &ft == 'nerdtree'
        call g:NERDTreeRender()
    endif
endfun

augroup AutoResizeNetrw
    fun s:AutoResizeNetrw()
        " DISABLE
        return
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
" DISABLE
" nnoremap <silent> <leader><tab> :Lexplore<CR><bar>:call <SID>ResizeNetrw(0.2, '')<CR>

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
            call ResizeFileBrowser(0.2, '')
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
    " DISABLE
    return

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

fun s:relResizeFileBrowser(inc)
    let s:cur_nw_perc=get(s:, 'cur_nw_perc', 0.3) + a:inc
    :exec 'vert res '.string(float2nr(floor(&columns * s:cur_nw_perc)))
    if &ft == 'netrw'
        if exists("b:netrw_curdir")
            let g:netrw_winsize = float2nr(floor(&columns * s:cur_nw_perc))
            call netrw#Call('NetrwRefresh', 1, w:netrw_treetop)
        endif
    elseif &ft == 'nerdtree'
        call NERDTreeRender()
    endif
endfun

" scroll so far that as much as possible of the file name is visible
" DISABLE
" au CursorMoved * if &ft=='netrw'|:call <SID>NetrwAutoHScroll()|endif

" widen the view - in case of long file names
au FileType netrw,nerdtree nnoremap <buffer><silent> <tab> :call <SID>relResizeFileBrowser(0.05)<cr>
" shrink back to orig. size
au FileType netrw,nerdtree nnoremap <buffer><silent> <S-tab> :call ResizeFileBrowser(0.2, '')<CR>

" DISABLE
" fun s:CheckIfNetrwOnlyOpen()
"     if &ft == 'netrw' || &ft == 'nerdtree'
"         if winnr('$') == 1
"             :vnew
"             wincmd p
"             call ResizeFileBrowser(0.2, '')
"         else
"             " do nothing
"         endif
"     else
"         if ! getbufvar('%', '&modified')
"             :enew
"         else
"             :echohl WarningMsg | echo "Can't switch buffer is not saved..." | echohl None
"         endif
"     endif
" endfun

"if we have a search in netrw, n would not work together with autohscroll...
" <shift>+n just works...
" this jumps down one line and then looks for the next match
" Note: this will skip a further match in a line
" DISABLE
" au FileType netrw nnoremap <buffer><silent><expr> n &ft=='netrw' ? 'jn':'n'



