""""""

"""""""""""""
" Yank helper
"

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


""""

let s:yank_store = []
let s:yank_max = 50

fun s:StoreYank()
    if v:event.operator == 'y'
        let l:yank = join(v:event.regcontents, "\<NL>")
        " avoid dups
        if empty(s:yank_store) || l:yank != s:yank_store[0]
            let s:yank_store = [l:yank] + s:yank_store[:s:yank_max]
        endif
    endif
endfun
fun s:SelectYank(id, result)
    if a:result > 0
        let l:selected = remove(s:yank_store, a:result - 1)
        call setreg('', l:selected)
        " sort selected yank to front
        let s:yank_store = [l:selected] + s:yank_store
    endif
endfun
" check yankstor length and ignore keys that are not possible...
fun s:keyFilter(id, key)
    if match(a:key, '^[0-9]$') != -1
        call popup_close(a:id, str2nr(a:key) + 1)
    elseif match(a:key, '^[a-z]$') != -1
     call popup_close(a:id, (char2nr(a:key) - char2nr('a')) + 10 + 1)
    else
        call popup_filter_menu(a:id, a:key)
    endif
    return v:true
endfun
fun s:ShowYank()
    let l:space_right = &columns - col('.')
    let l:pop_opt = { 'title': " Select Yank ",
                    \ 'padding': [0,0,0,0],
                    \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                    \ 'pos': 'botleft',
                    \ 'highlight': 'YankColor',
                    \ 'borderhighlight': ['YankColorBorder'],
                    \ 'line': 'cursor-1',
                    \ 'col': 'cursor+1',
                    \ 'zindex': '200',
                    \ 'drag': 0,
                    \ 'wrap': 0,
                    \ 'cursorline': 1,
                    \ 'maxwidth': float2nr(l:space_right * 0.75),
                    \ 'maxheight': &pumheight * 2,
                    \ 'scrollbar': 1,
                    \ 'callback': '<SID>SelectYank'}

    let l:pop_opt['filter'] = '<SID>keyFilter'
    if l:space_right < col('.')
        let l:pop_opt['pos'] = 'botright'
        let l:pop_opt['maxwidth'] = float2nr(col('.') * 0.75)
    endif
    " leaves room for … and the border
    let l:format_space = l:pop_opt['maxwidth'] - 4 - 1

    " pad here, so the highlight covers all (padding is not covered by the selection highlight)
    let l:ShortenYanks = { idx, val -> ' ' . ((idx > 9) ? nr2char((char2nr('a') + (idx - 10))) : idx) . ') ' . (strcharlen(val) >= l:format_space ?
                          \ val[0:l:format_space] . '…' : val) . ' ' }
    call popup_menu(mapnew(s:yank_store, l:ShortenYanks), l:pop_opt)
endfun

augroup YankBank
    autocmd!
    autocmd TextYankPost * call <SID>StoreYank()
    nnoremap <silent> <leader>p :call <SID>ShowYank()<cr>
augroup END
