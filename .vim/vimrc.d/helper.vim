fun s:bufferPopup()
    if &ft == 'qf' | return | endif " not not open in qf buffer

    let s:Buffers = <SID>getBuffers()
    call popup_menu(s:Buffers['items'], { 'title': " Select Buffer ",
                                        \ 'padding': [0,0,0,0],
                                        \ 'highlight': 'YankColor',
                                        \ 'borderhighlight': ['YankColorBorder'],
                                        \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                                        \ 'callback': '<SID>SelectBuffer'} )
endfun

" open buffer selection popup - the selected buffer is opened in the current window
nnoremap <silent> <leader>? :call <SID>bufferPopup()<cr>



"""""""""""""""""""
"
" switch between source and header

let s:altCpp = {'src': ['cpp', 'cc'], 'hdr': ['h', 'hpp']}

fun s:findAndSetPartner(kind)
    for l:hdr in s:altCpp[a:kind]
        let l:altFile = expand('%:r') . '.' . l:hdr
        if filereadable(l:altFile)
            if bufwinnr(l:altFile) <= 0
                let l:curFile = expand('%')
                silent exec ':hide :e ' . l:altFile
                call setreg('#', l:curFile)
            else
                call setreg('#', l:altFile)
            endif
        endif
    endfor
endfun

let s:quickfix_bufnr = -1

fun s:toggleAltFile()
    if &ft == 'cpp'
        let l:curExt = expand('%:e')
        if index(s:altCpp['hdr'], l:curExt) >= 0
           call s:findAndSetPartner('src')
        else
           call s:findAndSetPartner('hdr')
        endif
    elseif &ft == 'qf'
        if &bt == 'nofile'
            exe 'silent b + ' . s:quickfix_bufnr
        elseif &bt == 'quickfix'
            let s:quickfix_bufnr = bufnr('%')
            exe 'silent b + ' . g:asyncrun_raw_output_bufnr
        endif
    endif
endfun

nnoremap <silent> <leader>a :call <SID>toggleAltFile()<cr>


" jump to last cursor position when opening files / ignore commits
" from: :help restore-cursor
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exec "normal! g`\""
    \ | endif


""""""""""""""

" undotree & tagbar helper
"

fun ToggleTagbarUndotree(tag, undo)
    if a:tag && a:undo || ! a:tag && ! a:undo
        return " never display both or neither...
    endif
    if a:tag
        if undotree#UndotreeIsVisible()
            call undotree#UndotreeHide()
        endif
        call tagbar#ToggleWindow()
    elseif a:undo
        if tagbar#IsOpen()
            call tagbar#CloseWindow()
        endif
        call undotree#UndotreeToggle()
    endif
endfun


"""""""""""

" based on: https://github.com/cjuniet/clang-format.vim
" The visual selection mode replaces only the selected lines
fun s:clangFormat(vis) range
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

    let l:cmd  = "clang-format --style=file:" . g:vimrc_path . "/formatter/.clang-format"
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
nnoremap <silent> <M-f> :call <SID>clangFormat(0)<cr>
vnoremap <silent> <M-f> :call <SID>clangFormat(1)<cr>


"""""""""""""""""
fun! s:getBuffers()
    let l:bufs = getbufinfo()
    let l:dict = {'items': [], 'bufnr': []}
    for l:buf in l:bufs
        let l:type = getbufvar(l:buf.bufnr, '&ft')
        " ignore help, buffer that have a cursorlineopt with 'line'
        " (should cover things like netrw,tagbar,undotree, etc),
        " and all unloaded and unlisted buffers
        if l:type == 'help' || l:type == 'qf' || &cursorlineopt == 'line' || !l:buf.loaded || !l:buf.listed
            continue
        endif
        " TODO shorten names...
        " airline#util#shorten(getreg('/'), 300, 8)
        let l:name = empty(l:buf.name) ? g:unnamed_buffer_name : l:buf.name
        call add(l:dict['items'], ' ('.l:buf.bufnr.') '.l:name.' ')
        call add(l:dict['bufnr'], l:buf.bufnr)
    endfor
    return l:dict
endfun

" TODO make command b! and take care of Q to not blindly close everything...
fun s:SelectBuffer(id, result)
    if a:result > 0
        if ! getbufvar('%', '&modified')
            exec 'b ' . s:Buffers['bufnr'][a:result - 1]
        else
            :echohl WarningMsg | echo "Can't switch: buffer is not saved..."| echohl None
        endif
    endif
endfun


" close buffers and their tabs without confirming and ignoring side panels like
" tagbar, undotree or nerdtree
" cancels and quits diff mode
fun s:CheckIfLastWindowToClose()
    if &diff
        :cquit
        return
    endif

    let l:win = filter(range(1, winnr('$')), 'getwinvar(v:val, "&cursorlineopt") == "line"')
    if winnr('$') == len(l:win) + 1
        if tabpagenr('$') == 1
            :quitall
        else
            " quit highest nr first, otherwise numbers would change
            for l:w in reverse(l:win)
                :exe l:w . 'wincmd q'
            endfor
        endif
    endif

    :quit
endfun

nnoremap <silent> Q :call <SID>CheckIfLastWindowToClose()<cr>


" from https://vi.stackexchange.com/a/20661/40602
fun! s:CountTrailingWhites()
    let l:s = @/
    redir => l:cnt
        silent exe '%s/\s\+$//en'
    redir END
    let @/ = l:s
    call histdel('/', -1)
    return matchstr(cnt, '\d\+')
endfun

let g:maxNumTrailWhite = 5
augroup BUFWRITEHELPER
    autocmd!
    " based on: https://stackoverflow.com/q/8309728/2350114
    " Strip trailing whitespaces on each save
    " but ask if there are more than X many if we simply want to keep them
    " (legacy code and not getting annoyed with huge diffs)
    fun s:StripTrailingWhitespaces()
        let l = line(".")
        let c = col(".")

        let l:choice = 1
        let l:ctw = <SID>CountTrailingWhites()

        if l:ctw > get(g:, 'maxNumTrailWhite', 50)
            let l:choice = confirm("Found ".l:ctw." trailing whites - keep them?", "&Yes\n&No", 1)
            if l:choice == 2
                "prevents 'press enter to continue' dialog
                :set cmdheight=4
            else
                return
            endif
        endif

        let l:s = @/
        silent exe '%s/\s\+$//e'
        let @/ = l:s
        call histdel('/', -1)

        if l:choice == 2
            :set cmdheight=1
            :redraw
        endif

        call cursor(l, c)
    endfun

    au BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END


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

" DEPRECATED
" press # to match and highlight word under cursor
""" nnoremap <silent> # :exec 'match HighlightMatch /'.expand('<cword>').'/'<CR>
" works for multiple lines in visual(block) mode
""" vnoremap <silent> # :call <SID>HighlightVisualSelection()<CR>
" clear highlighted word
" code: ^[[24;2~ mapped to: <shift>+<alt>++
""" nnoremap <silent> <S-F12> :match<CR>

" do not move cursor when searching word under cursor
" nnoremap <silent> * :set hlsearch<bar>:let @/='\'.expand("<cword>").'\>'<CR>

