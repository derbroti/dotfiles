let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.colnr = ''
let g:airline_symbols.crypt = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.executable = '' " '⚙'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.readonly = ''
let g:airline_symbols.whitespace = ''
let g:airline_symbols.ellipsis = '…'

" mode names
let g:airline_mode_map = {
    \ 'niI' : 'I-NORMAL',
    \ 'niR' : 'R-NORMAL',
    \ 'niV' : 'vR-NORMAL',
    \ 'Rv'  : 'V-REPLACE',
    \ 'ic'  : 'INSERT COMPL GEN',
    \ 'Rc'  : 'REPLACE COMP GEN'
    \ }

" algo1: - do not do: <tab><space><tab>
"        - do not have more spaces than tab-width
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#whitespace#mixed_indent_format = "[%s]…"
let g:airline#extensions#whitespace#mixed_indent_file_format = "[%s]⋮"

let g:airline#extensions#searchcount#search_term_limit = 60

" only load these extensions
" original: ['quickfix', 'netrw', 'term', 'whitespace', 'po', 'wordcount', 'keymap']
let g:airline_extensions = ['quickfix', 'term', 'whitespace', 'searchcount', 'coli', 'tagbar', 'undotree', 'fzf']

let g:airline_filetype_overrides = {'nerdtree': [ '%#airline_a_bold#Files', '' ]}

" the default - modified, slightly, by me
let g:airline_theme = 'dark'

" react to focus events
let g:airline_focuslost_inactive = 1

let g:airline_highlighting_cache = 1



