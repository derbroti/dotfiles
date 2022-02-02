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
  " here we set the indicator to show that we have an active search
  if v:hlsearch && &hlsearch && ! get(w:, 'airline_not_found', 1)
    let w:coli_color = 7
    hi CursorLineNr ctermbg=13 ctermfg=232 cterm=bold
  else
    " in case of <not found> we would otherwise not get rid of the print
    redrawtabline
    if get(w:, 'force_abs_line', 0)
      " normal abs
      let w:coli_color = 1
      hi CursorLineNr ctermbg=190 ctermfg=17 cterm=bold
    else
      " normal
      let w:coli_color = 0
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
          " normal abs
          let w:coli_color = 1
          hi CursorLineNr ctermbg=190 ctermfg=17 cterm=bold
        endif
    else
        if m != 'i'
          " normal
          let w:coli_color = 0
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

fun airline#extensions#coli#ColorCursorLineNr(inactive)
  let l:a = get(w:, 'coli_color', 0)
  if l:a == 0     " normal
    hi CursorLineNr ctermbg=234 ctermfg=11 cterm=None
  elseif l:a == 1 " abs
     if a:inactive
      hi CursorLineNr ctermbg=248 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=190 ctermfg=17 cterm=bold
    endif
  elseif l:a == 2 " ins paste
    if a:inactive
      hi CursorLineNr ctermbg=240 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=172 ctermfg=17 cterm=bold
    endif
  elseif l:a == 3 " ins
    if a:inactive
      hi CursorLineNr ctermbg=248 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=45 ctermfg=17 cterm=bold
    endif
  elseif l:a == 4 " replace
    if a:inactive
      hi CursorLineNr ctermbg=240 ctermfg=250 cterm=bold
    else
      hi CursorLineNr ctermbg=124 ctermfg=255 cterm=bold
    endif
  elseif l:a == 5 " visual
    if a:inactive
      hi CursorLineNr ctermbg=246 ctermfg=16 cterm=bold
    else
      hi CursorLineNr ctermbg=214 ctermfg=16 cterm=bold
    endif
  elseif l:a == 6 " command
    """
    " Note: will not happen as we do not get a focus lost when in command mode
    "
    if a:inactive
      hi CursorLineNr ctermbg=247 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=40 ctermfg=17 cterm=bold
    endif
  elseif l:a == 7 " search
    if a:inactive
      hi CursorLineNr ctermbg=250 ctermfg=17 cterm=bold
    else
      hi CursorLineNr ctermbg=13 ctermfg=232 cterm=bold
    endif
  endif
endfun

fun airline#extensions#coli#ColorTabline()
  call airline#extensions#coli#ColorCursorLineNr(0)
  hi TabLineFill   ctermfg=DarkBlue
  hi TabLine       ctermfg=Black ctermbg=DarkBlue
  hi TabLineSel    ctermfg=Blue  ctermbg=Black
  hi TabLineSelMod ctermfg=129   ctermbg=Black    cterm=None
  hi TabLineMod    ctermfg=201   ctermbg=DarkBlue cterm=Bold
endfun

fun airline#extensions#coli#UnColorTabline()
  call airline#extensions#coli#ColorCursorLineNr(1)
  hi TabLineFill   ctermfg=238
  hi TabLine       ctermfg=Black ctermbg=238
  hi TabLineSel    ctermfg=Gray  ctermbg=234
  hi TabLineSelMod ctermfg=55    ctermbg=234 cterm=None
  hi TabLineMod    ctermfg=97    ctermbg=238 cterm=Bold
endfun

function! airline#extensions#coli#init(ext) abort
  " normal
  hi CursorLineNr ctermbg=234 ctermfg=11 cterm=None
  call a:ext.add_statusline_func('airline#extensions#coli#apply')

    augroup numbertoggle
        autocmd!
        autocmd InsertLeave * if line(".") != 1 && get(w:, 'force_abs_line', 0) != 1 | setlocal relativenumber | endif
        autocmd InsertEnter * setlocal norelativenumber
        autocmd CursorMoved * :call airline#extensions#coli#MakeFirstLineAbs()
        autocmd WinEnter    * :call airline#extensions#coli#CheckWinEnterForLine()
        autocmd WinLeave    * :call airline#extensions#coli#CheckWinLeaveForLine()
        " do not trigger anything if user decides to disable it
        if g:airline_focuslost_inactive
          autocmd FocusGained * :call airline#extensions#coli#ColorTabline()
          autocmd FocusLost   * :call airline#extensions#coli#UnColorTabline()
        endif
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

  " we typically start in normal mode, so do not trigger a premature change
  " prevents that the vim intro screen vanishes
  if get(w:, 'coli_last_mode', 'normal') ==# m
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
      let w:coli_color = 2
      hi CursorLineNr ctermbg=172 ctermfg=17 cterm=bold
    else
      let w:coli_color = 3
      hi CursorLineNr ctermbg=45 ctermfg=17 cterm=bold
    endif
  elseif m ==# 'replac'
    let w:coli_color =4
    hi CursorLineNr ctermbg=124 ctermfg=255 cterm=bold
  elseif m ==# 'visual'
    let w:coli_color = 5
    hi CursorLineNr ctermbg=214 ctermfg=16 cterm=bold
    :redrawstatus
  elseif m ==# 'comman'
    let w:coli_search_line = line(".")
    set colorcolumn=0
    let w:coli_color = 6
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

