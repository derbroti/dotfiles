""""""""""""""""
" ctrlsf.vim
"
"

let g:ctrlsf_fold_result = 0
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_winsize = '100%'
let g:ctrlsf_auto_focus = {"at" : "start"}
let g:ctrlsf_backend = 'rg'
let g:ctrlsf_extra_backend_args = { 'rg': '--no-messages --sort-files' }
let g:ctrlsf_case_sensitive = 'smart'
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_follow_symlinks = 1
let g:ctrlsf_context = '-B 2 -A 2'
let g:ctrlsf_indent = 0
let g:ctrlsf_regex_pattern = 1

fun! g:CtrlSFAfterMainWindowInit()
    setlocal wrap
    setlocal breakindent
    setlocal linebreak
    " sane default
    setlocal breakindentopt=min:0,shift:4
endfun
fun! g:CtrlSFAfterDone()
    " TODO: a re-render would be a good idea...  fix non-incremental drawing... view.vim
    exec 'setlocal breakindentopt=min:0,shift:' . ctrlsf#view#Indent()
endfun


com! -n=* -comp=customlist,ctrlsf#comp#Completion RG :call ctrlsf#Search(<q-args>)
nnoremap <C-f> :RG<space>


