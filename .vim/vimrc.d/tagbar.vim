""""""""""""
" tagbar config
"
"
let g:tagbar_width = 40
" no help but blank likes are shown
let g:tagbar_compact = 2
" we take care of this
let g:tagbar_wrap = 1
let g:tagbar_show_balloon = 0
let g:tagbar_highlight_method = 'scoped-stl'
" too much clutter when enabled...
" let g:tagbar_show_data_type = 1
" no balloons TODO does not work?
let g:tagbar_silent = 1
" use the existing file, do not create an extra tmp copy
let g:tagbar_use_cache = 0

let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#tagbar#searchmethod = 'scoped-stl'

nnoremap <silent> <leader>t :call ToggleTagbarUndotree(1, 0)<cr>
"TODO might be useful
" :TagbarTogglePause

autocmd FileType tagbar set cursorlineopt=line
                    \ | setlocal breakat=',:'
                    \ | hi TagbarHighlight term=underline ctermfg=10 cterm=Bold,underline

" force cursor to always be leftmost, to not be in the way
au FileType tagbar nnoremap <buffer> <up> 0k
au FileType tagbar nnoremap <buffer> <down> 0j

