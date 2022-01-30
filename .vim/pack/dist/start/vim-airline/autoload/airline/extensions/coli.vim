" vim: et ts=2 sts=2 sw=2
" MIT License. Copyright (c) 2022 Mirko Palmer

scriptencoding utf-8

if get(g:, 'loaded_coli', 0)
  finish
endif

fun! airline#extensions#coli#Cccheck()
  if get(w:, 'force_abs_line', 0) || line(".") == 1
    setlocal norelativenumber
  else
    setlocal relativenumber
  endif
  call airline#extensions#coli#setAbsRelHi()
endfun

fun! airline#extensions#coli#toggleAbsRel()
  let w:force_abs_line = !get(w:, 'force_abs_line', 0)
  call airline#extensions#coli#Cccheck()
endfun

fun! airline#extensions#coli#setAbsRelHi()
  if v:hlsearch && &hlsearch && ! get(w:, 'airline_not_found', 1)
    hi CursorLineNr ctermbg=13 ctermfg=232
  else
    " in case of <not found> we would otherwise not get rid of the print
    redrawtabline
    if get(w:, 'force_abs_line', 0)
      hi CursorLineNr ctermbg=190 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=234 ctermfg=11 cterm=None
    endif
  endif
endfun

fun! airline#extensions#coli#CheckWinEnterForLine()
  setlocal cursorline
  call airline#extensions#coli#CheckWinForLine()
endfun

fun! airline#extensions#coli#CheckWinLeaveForLine()
  setlocal nocursorline
  call airline#extensions#coli#CheckWinForLine()
endfun

fun! airline#extensions#coli#CheckWinForLine()
    let m = mode()
    if  get(w:, 'force_abs_line', 0)
        setlocal norelativenumber
        if m != 'i'
            hi CursorLineNr ctermbg=190 ctermfg=234 cterm=bold
        endif
    else
        if m != 'i'
            hi CursorLineNr ctermbg=234 ctermfg=11 cterm=None
            if line(".") != 1
              setlocal relativenumber
            else
              setlocal norelativenumber
            endif
        else
            setlocal norelativenumber
        endif
    endif
endfun

let g:debugme = ""

fun! airline#extensions#coli#MakeFirstLineAbs()
    let l = line(".")
    let ll = get(w:, 'my_last_line', 1)
    if (l == 1 && ll != 1) || (l != 1 && ll == 1)
        if l == 1
            setlocal norelativenumber
        else
            if get(w:, 'force_abs_line', 0) != 1
                setlocal relativenumber
            endif
        endif
        let w:my_last_line = l
    endif
endfun

function! airline#extensions#coli#init(ext) abort
   call a:ext.add_statusline_func('airline#extensions#coli#apply')

    augroup numbertoggle
        autocmd!
        autocmd InsertLeave * if line(".") != 1 && get(w:, 'force_abs_line', 0) != 1 | setlocal relativenumber | endif
        autocmd InsertEnter * setlocal norelativenumber
        autocmd CursorMoved * :call airline#extensions#coli#MakeFirstLineAbs()
        autocmd WinEnter    * :call airline#extensions#coli#CheckWinEnterForLine()
        " not needed
        "autocmd BufWinEnter * setlocal   cursorline | :call airline#extensions#coli#CheckWinEnterForLine()
        autocmd WinLeave    * :call airline#extensions#coli#CheckWinLeaveForLine()
     augroup END
endfunction

function! airline#extensions#coli#apply(...) abort
    call airline#extensions#append_to_section('a',
          \ '%{airline#extensions#coli#refresh()}')
endfun

function airline#extensions#coli#refresh() abort
  " keep only base mode - ignore '_modified' etc.
  let m = get(w:, 'airline_lastmode', '')[0:5]

  if get(w:, 'coli_mode_changed', 0) == 1
    :redrawstatus
    let w:coli_mode_changed = 0
  endif

  if get(w:, 'coli_last_mode', '') ==# m
    return ''
  else
    let w:coli_mode_changed = 1
    let w:coli_last_mode = m
  endif

  let &colorcolumn = get(g:, 'airline#extensions#coli#columns', 0)

  if m ==# 'normal'
    call airline#extensions#coli#setAbsRelHi()
    set colorcolumn=0
    :redrawstatus
    if line(".") != 1 && ! get(w:, 'force_abs_line', 0)
      setlocal relativenumber
    endif
  elseif m ==# 'insert'
    if g:airline_detect_paste && &paste
      hi CursorLineNr ctermbg=172 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=45 ctermfg=17 cterm=bold
    endif
  elseif m ==# 'replac'
    hi CursorLineNr ctermbg=124 ctermfg=255 cterm=bold
  elseif m ==# 'visual'
    hi CursorLineNr ctermbg=214 ctermfg=16 cterm=bold
    :redrawstatus
  elseif m ==# 'comman'
    let w:coli_search_line = line(".")
    set colorcolumn=0
    hi CursorLineNr ctermbg=40 ctermfg=17 cterm=bold
    :redrawstatus
    let w:coli_mode_changed = 0
  endif

  if ! ( m ==# 'comman' )
    let w:coli_search_line = -1
    " if we cancel an incsearch and end up on line 1 again, we have to switch
    if line(".") == 1
      setlocal norelativenumber
    endif
  endif

  return ''
endfunction

