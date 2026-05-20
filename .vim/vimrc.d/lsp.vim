""""""""""
" vim-lsp & asyncomplete & asyncomplete-lsp
"
"

let g:asyncomplete_auto_popup = 0
let g:asyncomplete_popup_delay = 10

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" :
                            \ <SID>check_back_space() ? "\<TAB>" :
                            \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"



" TODO setup local LSP if no session...
" if g:SessionServer != "" && g:SessionPathMap != []
    " let g:lsp_semantic_enabled = 1

    let g:lsp_log_verbose = 0
    let g:lsp_log_file = expand('~/vim-lsp.log')
    let g:asyncomplete_log_file = expand('~/vim-asyncomplete.log')
    " log everything clangd logs (it is set to info)
    let g:lsp_show_message_log_level = "log"
    let g:lsp_show_message_request_enabled = 1
    let g:lsp_work_done_progress_enabled = 1

    let g:lsp_diagnostics_signs_error = {'text': ''} " ' ✘'}
    let g:lsp_diagnostics_signs_warning = {'text': ''} " ' ‼'}
    let g:lsp_diagnostics_signs_information = {'text': ''} " ' ⅰ'}
    let g:lsp_diagnostics_signs_hint = {'text': ''} " ' ⚑'}

    hi LspErrorText ctermfg=160
    hi LspWarningText ctermfg=208
    hi LspInformationText cterm=bold ctermfg=51
    hi LspHintText cterm=bold ctermfg=226

    hi LspErrorHighlight cterm=underline ctermul=160
    hi LspWarningHighlight cterm=underline ctermul=208
    hi LspInformationHighlight cterm=underline ctermul=51
    hi LspHintHighlight cterm=underline ctermul=226

    let g:lsp_use_native_client = 1
    let g:lsp_experimental_workspace_folders = 1
    let g:lsp_async_completion = 1

    let g:lsp_untitled_buffer_enabled = 0
    let g:lsp_fold_enabled = 0
    " does not work... hacked 'vim-lsp/autoload/lsp/ui/vim/output.vim'...
    let g:lsp_hover_conceal = 1
    let g:lsp_preview_fixup_conceal = 1
    let g:lsp_ignorecase = v:true
    let g:lsp_document_highlight_enabled = 0
    " clutter due to the 'refactor' code action that is allowed very often
    let g:lsp_document_code_action_signs_enabled = 0
    let g:lsp_signature_help_delay = 500
    let g:lsp_format_sync_timeout = 1000
    let g:lsp_diagnostics_enabled = 1
    let g:lsp_diagnostics_highlights_enabled = 1
    let g:lsp_diagnostics_highlights_insert_mode_enabled = 1
    let g:lsp_diagnostics_echo_cursor = 1
    let g:lsp_diagnostics_echo_delay = 200
    let g:lsp_diagnostics_signs_enabled = 1
    let g:lsp_diagnostics_signs_delay = 200
    let g:lsp_diagnostics_signs_priority_map = {'LspError': 4, 'LspWarning': 3, 'LspHint': 2, 'LspInformation': 1}

    let g:lsp_diagnostics_signs_insert_mode_enabled = 1
    " enabling it is too distracting
    let g:lsp_diagnostics_virtual_text_enabled = 0
    " let g:lsp_diagnostics_virtual_text_prefix = '# '
    " let g:lsp_diagnostics_virtual_text_align = 'after'
    let g:lsp_code_action_ui = 'float'

    " TODO maybe keep lsp on during merge but disable diagnostics
    if ! &diff
               " && executable('clangd') " not needed here... using server

      augroup ONLSP
       autocmd!

        fun On_update_status()
            let l:status = lsp#get_server_status(&ft)
            let l:color = 15
            if l:status == "running" || &ft != 'cpp'
                let l:color = 77
            elseif  l:status == "unknown server" || l:status == "exited" || l:status == "failed"
                let l:color = 160
            elseif l:status == "starting" || l:status == "not running"
                let l:color = 214
            endif
            let g:airline#themes#dark#palette.normal['airline_x'][2] = l:color
            return airline#parts#filetype()
        endfun
        call airline#parts#define_raw('filetype', '%{On_update_status()}')
        call airline#update_statusline()

        let s:lss_tmplate = {"error": "", "status": ""}
        let s:lsp_server_status = {'': s:lss_tmplate, 'cpp': s:lss_tmplate}

        fun On_lsp_state_change(update, state, change)
            if !empty(get(s:lsp_server_status, &ft, {}))
                if !a:update
                    return get(s:lsp_server_status[&ft], a:state, "")
                else
                    " do update
                    let s:lsp_server_status[&ft][a:state] = a:change
                    call airline#update_statusline()
                endif
            endif
            return ''
        endfun
        call airline#parts#define_raw('lsp_error', '%{On_lsp_state_change(0, "error", "")}')

        fun On_lsp_status(update)
            if !empty(get(s:lsp_server_status, &ft, {}))
                if !a:update
                    return get(s:lsp_server_status, &ft, "")["status"]
                else
                    let l:ret = ""
                    "  [{'token': 'backgroundIndexProgress', 'percentage': 6, 'message': '78/1127', 'title': 'indexing', 'server': 'cpp'}]
                    for prog in lsp#get_progress()
                        if get(prog, 'title', "") == 'indexing' && get(prog, 'server', "") == &ft
                            let l:ret = "indexing " . get(prog, "percentage", "") . "\% "
                            break
                        endif
                    endfor
                    " do update
                    let s:lsp_server_status[&ft]["status"] = l:ret
                    call airline#update_statusline()
                endif
            endif
            return ''
        endfun
        call airline#parts#define_raw('lsp_status', '%{On_lsp_status(0)}')

        fun On_lsp_diag_update()
            if !empty(get(s:lsp_server_status, &ft, {}))
                if !exists('b:lsp_buffer_status')
                    let b:lsp_buffer_status = {"": {}}
                endif
                let b:lsp_buffer_status[&ft] = lsp#get_buffer_diagnostics_counts()
                call airline#update_statusline()
            endif
        endfun

        fun On_lsp_diag_print(category, symbol)
            if !exists('b:lsp_buffer_status')
                let b:lsp_buffer_status = {"": {}}
            endif
            let l:cnt = get(get(b:lsp_buffer_status, &ft, {}), a:category, "")
            let l:ret = l:cnt . a:symbol . "\ua0"
            return (l:cnt > 0) ? l:ret : ''
        endfun
        call airline#parts#define_raw('lsp_warning_count',     '%{On_lsp_diag_print("warning", "‼")}')
        call airline#parts#define_raw('lsp_information_count', '%{On_lsp_diag_print("information", "ⅰ")}')
        call airline#parts#define_raw('lsp_error_count',       '%{On_lsp_diag_print("error", "✘")}')
        call airline#parts#define_raw('lsp_hint_count',        '%{On_lsp_diag_print("hint", "⚑")}')


        "  --path-mappings=' . reduce(g:SessionPathMap, { res, val -> res . val[1] . '=' . substitute(val[0], '\\', '', 'g') . ',' }, '')
        "   '--malloc-trim',
        "
        au User lsp_setup call lsp#register_server({
            \ 'name': 'cpp',
            \ 'env': {'IMAGE':       'acd458275f13',
            \         'NAME_PREFIX': 'clangd-18',
            \         'NOTTY' :      '1',
            \         'NOCD'  :      '1',
            \         'PLAIN' :      '1'},
            \ 'cmd': {server_info->['limu', 'clangd-18', '--log=verbose', '--background-index', '--background-index-priority=background',
            \                       '-j', '2', '--all-scopes-completion', '--completion-style=detailed', '--clang-tidy', '--pch-storage=memory',
            \                       '--rename-file-limit=0', '--limit-results=0', '--limit-references=0', '--header-insertion=never',
            \                       '--header-insertion-decorators', '--function-arg-placeholders', '--path-mappings=/Volumes/podmu/_usr_include=/usr/include']},
            \ 'allowlist': ['c', 'cpp'],
            \ 'root_uri': {server_info->lsp#utils#path_to_uri(
            \ lsp#utils#find_nearest_parent_file_directory(
            \        lsp#utils#get_buffer_path(),
            \        ['.ccls', 'compile_commands.json', '.git/']))},
            \ 'config': { 'hover_conceal': 1 }
            \ })
        au User lsp_setup call lsp#register_server({'name': 'td', 'cmd': {server_info->['/opt/homebrew/opt/llvm@20/bin/tblgen-lsp-server', '--tablegen-compilation-database=/Volumes/podmu/llvm-project/build/tablegen_compile_commands.yml']}, 'allowlist': ['tablegen'],'root_uri': {server_info->lsp#utils#path_to_uri(
            \ lsp#utils#find_nearest_parent_file_directory(
            \        lsp#utils#get_buffer_path(),
            \        ['.ccls', 'tablegen_compile_commands.yml', '.git/']))} })
        au User lsp_server_exit call On_lsp_state_change(1, "error", "Lsp exited")
        au User lsp_server_init call On_lsp_state_change(1, "error", "")
        au User lsp_progress_updated call On_lsp_status(1)
        au User lsp_diagnostics_updated call On_lsp_diag_update()
      augroup END
    endif

    fun s:lsp_jump(cmd)
        if &modified
            echo "LSP: Buffer unsaved, can't jump."
        else
            :execute "normal \<Plug>(" . a:cmd . ")"
        endif
    endfun

    function! s:on_lsp_buffer_enabled()
        setlocal omnifunc=lsp#complete
        " ensure that this is set
        setlocal signcolumn=number
        let &errorformat .= ",%-GCompiling %.%#,%-GLinking %.%#,%-GINFO:%.%#"

        " TODO have same jump tracking for this...
        nmap <buffer> <leader>gD :call <SID>lsp_jump("lsp-declaration")<cr>
        nmap <silent><buffer> <leader>gd :call <SID>lsp_jump("lsp-definition")<cr>
        nmap <buffer> <leader>ga <plug>(lsp-code-action)
        nmap <buffer> <leader>g[ <plug>(lsp-previous-error-nowrap)
        nmap <buffer> <leader>g] <plug>(lsp-next-error-nowrap)
        nmap <buffer> <leader>gr <plug>(lsp-references)

        " TODO: check these... for unsaved file and where to open the result etc...
        " nmap <buffer> <leader>gs <plug>(lsp-document-symbol-search)
        nmap <buffer> <leader>gS <plug>(lsp-workspace-symbol-search)
        nmap <buffer> <leader>rn <plug>(lsp-rename)
        " disable for now - tagbar should take care of this
        " if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
        " TODO might be useful
        "nmap <buffer> K <plug>(lsp-hover)
        " TODO any of these needed?
        "nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
        "nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
        nmap <buffer> gi <plug>(lsp-implementation)
        """" conflicts with vim's gt nmap <buffer> gt <plug>(lsp-peek-type-definition)
        hi ArgSelDelim ctermbg=45 ctermfg=17
        hi ArgSel ctermbg=45 ctermfg=17
        au Syntax * syntax match ArgSelDelim /`/
        au Syntax * syntax region ArgSel matchgroup=ArgSelDelim start=/`/ end=/`/
    endfunction

    augroup lsp_install
        au!
        " call s:on_lsp_buffer_enabled only for languages that have the server registered.
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
" else
"     call airline#parts#define_function('filetype', 'airline#parts#filetype')
"     call airline#update_statusline()
" endif
