"""""
" required plugins:
"
" asyncomplete.vim      - https://github.com/prabirshrestha/asyncomplete.vim.git
" asyncomplete-lsp.vim  - https://github.com/prabirshrestha/asyncomplete-lsp.vim.git
"
" ctrlsf.vim            - https://github.com/derbroti/ctrlsf.vim  // feature/experimental
" undotree              - https://github.com/derbroti/undotree
" tagbar                - https://github.com/derbroti/tagbar
" vim-airline           - https://github.com/derbroti/vim-airline
" vim-lsp               - https://github.com/derbroti/vim-lsp
" asyncrun.vim          - https://github.com/derbroti/asyncrun.vim
" NERDTree              - https://github.com/derbroti/NERDtree

""" required tools:
"
" universal-ctags - brew install universal-ctags
" compiledb       - brew install compiledb
" clang-format    - brew install clang-format
" lua             - brew install lua

""" terminal:
"
" iTerm2 >= 3.5

let g:SessionNameLocal = "work"
let g:SessionServerLocal = "earmu"
" IMPORTANT: first map is used to translate asynrun paths...
" let g:SessionPathMapLocal = [['\/home\/palmerm1', '/Users/palmerm1/palmerm1.earmu'],
"                          \  ['\/usr\/include', '/Users/palmerm1/palmerm1.earmu.usr_include']]

" quickfix
let g:compiler_gcc_ignore_unmatched_lines = 1

" used for anyrc
" https://stackoverflow.com/a/3384476/2350114
" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
" what is the name of the directory containing this file?
" https://stackoverflow.com/a/18734557/8205759
let g:vimrc_path = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/.vim'
" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', g:vimrc_path, &runtimepath, g:vimrc_path)


" write without executing autocmds - e.g.: write without asking to remove trailing whites
command W :noautocmd :w
" write file with sudo
command Wsudo silent exe 'w !sudo /usr/bin/tee % >/dev/null' | e!
command Ws :Wsudo


""" DISABLED
""" """"""
""" " VimCompletesMe
"""
""" autocmd FileType c,cpp let b:vcm_tab_complete = "omni"


" load order is important, unfortunately
"
source ~/.vim/vimrc.d/settings.vim
source ~/.vim/vimrc.d/helper.vim
source ~/.vim/vimrc.d/session.vim
source ~/.vim/vimrc.d/highlights.vim
source ~/.vim/vimrc.d/airline.vim
source ~/.vim/vimrc.d/asyncrun.vim
source ~/.vim/vimrc.d/ctrlsf.vim
source ~/.vim/vimrc.d/diff.vim
source ~/.vim/vimrc.d/ft-settings.vim
source ~/.vim/vimrc.d/fzf.vim
source ~/.vim/vimrc.d/lsp.vim
source ~/.vim/vimrc.d/tagbar.vim
source ~/.vim/vimrc.d/undotree.vim
source ~/.vim/vimrc.d/netrw.vim
source ~/.vim/vimrc.d/nerdtree.vim
source ~/.vim/vimrc.d/system_keymaps.vim
source ~/.vim/vimrc.d/term.vim
source ~/.vim/vimrc.d/yank.vim
