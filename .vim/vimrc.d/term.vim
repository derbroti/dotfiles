""""""""""""""
" terminal....
"

let g:term_ssh = "ssh " . g:SessionServer
let g:term_options = { 'term_rows': 20,
                   \   'vertical': 0,
                   \   'hidden': 0,
                   \   'term_finish': 'close',
                   \   'norestore': 1
                   \ }

" TODO clashes with spell check...
" nnoremap <silent> <leader>s :below :call term_start(&shell,     g:term_options)<cr>
" nnoremap <silent> <leader>S :below :call term_start(g:term_ssh, g:term_options)<cr>

