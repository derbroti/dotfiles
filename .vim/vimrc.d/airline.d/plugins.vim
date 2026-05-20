" initialize Tabline and Searchbar colors
call airline#extensions#coli#ColorTabline()

" make the status bar more visible if we have one than one window open
" makes it also more visible if we split vertically, but well... you can't have it all...
augroup StatusColWhenWin
fun s:statusColorHack()
    if tabpagewinnr(tabpagenr(), "$") > 1
        let g:airline#themes#dark#palette.normal['airline_c'][3] = 235
        let g:airline#themes#dark#palette.normal['airline_w'][3] = 235
        let g:airline#themes#dark#palette.normal_modified['airline_c'][3] = 235
    else
        let g:airline#themes#dark#palette.normal['airline_c'][3] = 234
        let g:airline#themes#dark#palette.normal['airline_w'][3] = 234
        let g:airline#themes#dark#palette.normal_modified['airline_c'][3] = 234
    endif
endfun
    autocmd!
    au WinEnter * :call <SID>statusColorHack()
    au WinLeave * :call <SID>statusColorHack()
augroup END


" toggle rel/abs line numbers (in normal mode only)
" M-F7 code: ^[[18;2~ mapped to: <alt>+<esc>
nnoremap <silent> <M-F7> :call airline#extensions#coli#toggleAbsRel()<CR>

" <ctrl>+c clears search (hides it, reg keeps the value) + clear linenumber highlight
nnoremap <expr><silent><C-c> v:hlsearch ? ":nohl<bar>:call airline#extensions#coli#Cccheck()<CR>" : "<C-c>"
" restore original C-c function when in cmd window (the expr map does not really work here)
au CmdwinEnter * nnoremap <C-c> <C-c>
au CmdWinLeave * nnoremap <expr><silent><C-c> v:hlsearch ? ":nohl<bar>:call airline#extensions#coli#Cccheck()<CR>" : "<C-c>"

" normal->insert->(insert)->search->C-c->linenumber fail
" in short: when pressing C-c from insert mode we need to check the abs/rel numbering
inoremap <nowait><silent><C-c> <ESC><bar>:call airline#extensions#coli#Cccheck()<CR>
