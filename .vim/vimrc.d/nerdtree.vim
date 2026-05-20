""""""""""""
" nerdtree config
"

let NERDTreeAutoCenter = 0
let NERDTreeNaturalSort = 1
let NERDTreeBookmarksFile = '/dev/null'
let NERDTreeMarkBookmarks = 0
let NERDTreeShowBookmarks = 0
" single: folder open; double: file open
let NERDTreeMouseMode = 1
let NERDTreeShowHidden = 1
let NERDTreeSortOrder = ['[\/]$']
let NERDTreeWinSize = 30 " s:NetrwWidth
let NERDTreeMinimalUI = 1
" open only what I tell you to open
let NERDTreeCascadeOpenSingleChildDir = 0
let NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 'p', 'keepopen': 1, 'stay': 0}, 'dir': {}}

au FileType nerdtree set cursorlineopt=line

function! s:MyNERDTreeToggle()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    exe ":NERDTreeClose"
  elseif empty(bufname('%'))
    exe ":NERDTreeCWD"
  else
    exe ":NERDTreeFind"
  endif
endfunction
nnoremap <silent> <leader><tab> :call <SID>MyNERDTreeToggle()<cr><bar>:call ResizeFileBrowser(0.2, '')<cr>

" force cursor to always be leftmost, to not be in the way
au FileType nerdtree nnoremap <buffer> <up> 0k
au FileType nerdtree nnoremap <buffer> <down> 0j
" reset tree - e.g.: set root back to original dir
au FileType nerdtree nnoremap <silent><buffer> <C-c> :NERDTree<cr>

"""""""""

""" nnoremap <C-f> y/<C-r>0<cr>



