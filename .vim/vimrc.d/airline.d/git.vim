let b:current_git_branch = ""
au BufEnter * let b:current_git_branch = substitute(system('git -C ' . expand('%:p:h') . ' branch --show-current 2> /dev/null'), '\n', '', '')


fun On_get_branch()
    return (empty(b:current_git_branch)) ? '' : g:airline_symbols.branch . ' ' . b:current_git_branch
endfun
call airline#parts#define_raw('branch', '%{On_get_branch()}')



