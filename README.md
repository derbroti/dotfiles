This repository contains my dotfiles.

Besides the usual configs this includes:
- modifications to [vim-airline](https://github.com/vim-airline/vim-airline) to show vim's "sub-modes"
e.g. NORMAL->INSERT->(INSERT)->VISUAL will now be marked as "I-VISUAL"

- a marginally altered airline dark.vim colorscheme

- "coli.vim" my own airline extension to vim-airline that colors the current line indicator depending on the mode (compatible with focus events!)

-- plus switchable rel/abs line numbers (works with vim windows!)

-- automatically switches to abs lines if on line 1 (otherwise line one and two would both be shown as 1)

- "searchcount.vim" an airline extension hacked to put the search result (incsearch) print into vim's tabline

- a modified tabline that visually highlights modified files

- iTerm configs/profile/colors

(both extensions avoid any unnecessary cycles - they will only execute if absolutely necessary)

