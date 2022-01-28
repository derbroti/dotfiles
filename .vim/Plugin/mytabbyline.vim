" based on: https://stackoverflow.com/a/33765365/2350114
function! MyTabbyLine()
  let s = ''
  " loop through each tab page
  for i in range(tabpagenr('$'))
    let sel = i + 1 == tabpagenr()
    if sel
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    if sel
      let s .= '%#TabLineSel#' " WildMenu
    else
      let s .= '%#TabLine#'
    endif
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T '
    " set page number string
    let s .= i + 1
    " get buffer names and statuses
    let n = ''  " temp str for buf names
    "" let m = 0   " &modified counter
    let buflist = tabpagebuflist(i + 1)
    " loop through each buffer in a tab
    for b in buflist
      if getbufvar(b, "&buftype") == 'help'
        " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
      elseif getbufvar(b, "&buftype") == 'quickfix'
        " let n .= '[Q]'
      elseif getbufvar(b, "&modifiable")
        if getbufvar(b, "&modified")
          let n .= '%#TabLineSelMod#'
        endif
        " add buffer names
        let bn = bufname(b)
        if bn == ''
          let bn = '[No Name]'
        endif
        let n .= ' '.fnamemodify(bn, ':t').' '
        if i + 1 == tabpagenr()
          let n .= '%#TabLineSel#'
        else
          let n .= '%#TabLine#'
        endif

        let n .= '|' " pathshorten(bufname(b))
      endif
    endfor
    "??? "let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, '|$', '', '')

    let s.= ')'

    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    let s .= n
  endfor
  let s .= '%T'
  let s .= '%#TabLineFill#'
  " right-aligned close button
  " if tabpagenr('$') > 1
  "   let s .= '%=%#TabLineFill#%999Xclose'
  " endif
  let s .= '%='
  if v:hlsearch
    let s .= '%#SearchBar#'
    let s .= '%{ airline#extensions#searchcount#status(1) }'
  endif
  let s .= '%*'
  return s
endfunction

