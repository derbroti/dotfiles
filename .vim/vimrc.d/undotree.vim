""""""""""
" undotree
"
"
nnoremap <silent> <leader>u :call ToggleTagbarUndotree(0, 1)<cr>

" diff over whole bottom, tree on right
let g:undotree_WindowLayout = 4

let g:undotree_HelpLine = 0
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_CursorLine = 1
autocmd FileType undotree set cursorlineopt=line

let g:undotree_TreeNodeShape   = 'ο'
let g:undotree_TreeReturnShape = '⟍'
let g:undotree_TreeVertShape   = '│'
let g:undotree_TreeSplitShape  = '╱'

fun g:Undotree_CustomMap()
    nmap <buffer> j <plug>UndotreeNextState
    nmap <buffer> <up> <plug>UndotreeNextState
    nmap <buffer> k <plug>UndotreePreviousState
    nmap <buffer> <down> <plug>UndotreePreviousState
endfun


""""""

