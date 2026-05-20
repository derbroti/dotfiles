""""""""""""""""""""
" FZF
"
"
let $FZF_DEFAULT_COMMAND = "rg --files --glob '!*.d' --glob '!*.o'"

let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_colors =
\ { 'fg':        ['fg', 'Normal'],
  \ 'bg':        ['bg', 'Normal'],
  \ 'hl':        ['fg', 'SearchInv'],
  \ 'fg+':       ['fg', 'CursorLine'],
  \ 'bg+':       ['bg', 'CursorLine'],
  \ 'hl+':       ['fg', 'IncSearchInv'],
  \ 'info':      ['fg', 'PreProc'],
  \ 'border':    ['fg', 'Error'],
  \ 'scrollbar': ['fg', 'SearchInv'],
  \ 'prompt':    ['fg', 'Conditional'],
  \ 'pointer':   ['fg', 'IncSearchInv'],
  \ 'marker':    ['fg', 'Keyword'],
  \ 'spinner':   ['fg', 'Label'],
  \ 'header':    ['fg', 'Comment'] }
let s:fzf_prompt = "\e[38;5;13m$\e[0m "
let g:fzf_my_options = ['--scheme=history', '--border=none',  '--info=inline-right',
                     \  '--no-separator',   '--scrollbar=██', '--ellipsis=…',
                     \  '--keep-right',     '--tabstop=4',    '--multi',
                     \  '--prompt='.s:fzf_prompt]

fun s:fzf_run(dir)
    let opts = { 'options': g:fzf_my_options, 'dir': '' }
    if !empty(a:dir)
        if isdirectory(glob(a:dir))
            let opts.dir = a:dir
        else
            echohl WarningMsg | echo "Error: Path: \"" . a:dir . "\" does not exist." | echohl None
            return
        endif
    else
        let opts.dir = getcwd()
    endif
    call extend(opts['options'], ['--prompt=' . fnamemodify(opts.dir, ':p:~:h') . s:fzf_prompt])
    call fzf#run(fzf#wrap('FZF', opts, 0))
endfun

nnoremap <silent> <C-p> :LS<cr>
" does not show up until more chars are typed
" nnoremap [99;50~ :LS<space>
command! -complete=dir -nargs=? LS :call <SID>fzf_run(<q-args>)

