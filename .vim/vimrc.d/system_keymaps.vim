" (un-)indent with (<shift>)+<tab>
nnoremap <silent> <tab> >>
nnoremap <silent> <S-tab> <<
vnoremap <silent> <tab> >gv
vnoremap <silent> <S-tab> <gv

" can't map tab and <c-i> at the same time, so we remap <c-i> in iterm...
nnoremap [99;50~ <C-i>

" TODO maybe some day...
"" alt+j
"nnoremap º gj
"vnoremap º gj
"" alt+k
"nnoremap ∆ gk
"vnoremap ∆ gk
"" alt+4
"nnoremap ¢ g$
"vnoremap ¢ g$

" map alt+up/down to not jump over wrapped lines
nnoremap <M-Up> gk
vnoremap <M-Up> gk
inoremap <M-Up> <C-o>gk
nnoremap <M-Down> gj
vnoremap <M-Down> gj
inoremap <M-Down> <C-o>gj

" C-y is our tmux prefix, so do not scroll when we press it in vim
" scroll-wheel scrolling still works
nnoremap <C-y> <nop>
" disable C-e as well to be consistent
nnoremap <C-e> <nop>

" enable ctrl+z (suspend to background) while in insert mode
" in all other modes it works automagically
inoremap <silent> <C-z> <C-o>:stop<cr>

" move cursor multiple lines (compare tmux settings)
nnoremap <S-Up> 5k
nnoremap <S-Down> 5j
inoremap <silent> <S-Up> <C-o>5k
inoremap <silent> <S-Down> <C-o>5j
vnoremap <S-Up> 5k
vnoremap <S-Down> 5j
" super fast S-F9  code: ^[[20;2~ mapped to: <shift>+<alt>+<up>
"            S-F10 code: ^[[21;2~ mapped to: <shift>+<alt>+<down>
nnoremap <S-F9> 10k
nnoremap <S-F10> 10j
inoremap <silent> <S-F9> <C-o>10k
inoremap <silent> <S-F10>  <C-o>10j
vnoremap <S-F9> 10k
vnoremap <S-F10> 10j

" scroll to top/bottom
nnoremap <silent> <C-Up> :0<CR>
nnoremap <silent> <C-Down> :$<CR>
inoremap <silent> <C-Up> <C-o>:0<CR>
inoremap <silent> <C-Down> <C-o>:$<CR>
vnoremap <silent> <C-Up> gg<CR>
vnoremap <silent> <C-Down> <S-g>

" make consistent to zsh and macos
" <alt>+<left/right> jumps words
nnoremap <M-Left> b
nnoremap <M-Right> e
" inoremap <silent><nowait> <M-Left> <c-o>b
" inoremap <silent><nowait> <M-Right> <c-o>e
vnoremap <M-Left> b
vnoremap <M-Right> e
cnoremap <M-Left> <S-Left>
cnoremap <M-Right> <S-Right>
" <ctrl>+<left/right> jumps to start/end of line
nnoremap <C-Left> 0
nnoremap <C-Right> $
" inoremap <silent><nowait> <C-Left> <c-o>0
" inoremap <silent><nowait> <C-Right> <c-o>$
vnoremap <C-Left> 0
vnoremap <C-Right> $
cnoremap <C-Left> <C-b>
cnoremap <C-Right> <C-e>

" shift+mouseclick scrolls down?!
" TODO this does not fix it...
" nnoremap <S-leftmouse> <nop>
" inoremap <S-leftmouse> <nop>
" vnoremap <S-leftmouse> <nop>

" <fn>+<enter>
" toggle paste mode
nnoremap <silent> <ins> :set paste!<cr>

" M-tab
" toggle replacing tabs with spaces
nnoremap <silent> [99;20~ :set expandtab!<cr>

" deactivate space - in case we press leader and nothing else, we would otherwise move the cursor
nnoremap <space> <nop>

" new buffer
" DISABLE - no longer needed?
" nnoremap <silent> <leader>n :call <SID>CheckIfNetrwOnlyOpen()<cr>
" new tab
nnoremap <silent> <leader>c :tabnew<CR>

" move to prev / next tab
" [99;12~ mapped to <fn>+<cmd>+<alt>+<left>
" [99;14~ mapped to <fn>+<cmd>+<alt>+<right>
nnoremap <silent> [99;m2sr~ gt<bar>:redraw<cr>
nnoremap <silent> [99;m2sl~ gT<bar>:redraw<cr>

" move between windows (with buffers in them)
" [99;11~ [99;13~ [99;15~ [99;16~ mapped to <fn>+<cmd>+{<left> <right> <up> <down>}
nnoremap <silent> [99;11~ <C-w><Left>
" inoremap <silent> [99;1~ <C-w><Left>
nnoremap <silent> [99;13~ <C-w><Right>
nnoremap <silent> [99;15~ <C-w><Up>
nnoremap <silent> [99;16~ <C-w><Down>

" keep split views equal in size - was automatic, is now manual
" autocmd VimResized * wincmd =
nnoremap <silent> <leader>= :wincmd =<cr>

inoremap <S-F11> <nop>
vnoremap <S-F11> <nop>

nnoremap <silent> <leader>6 :set spell! spelllang=en_us<CR>
" based on: https://stackoverflow.com/q/25777205/2350114
"           https://stackoverflow.com/a/25777332/2350114
nnoremap <expr> <leader>s &spell ? "a<C-x><C-s>" : ""
" TODO breaks normal ctrl-p... drops us out of insert mode
"inoremap <expr> <CR> pumvisible() ? "<C-y><Esc>" : "<CR>"


