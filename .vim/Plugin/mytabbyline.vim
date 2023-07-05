" vim: et ts=2 sts=2 sw=2

" based on: https://stackoverflow.com/a/33765365/2350114
function! MyTabbyLine()
  let s = ''
  let l:sess = get(v:, "this_session", '')
  if ! empty(l:sess)
    let l:sess = substitute(l:sess, '^.*/', '', '')
    let s .= '%#TabLineSess# «' . l:sess . '» '
  endif
  " loop through each tab page
  for i in range(tabpagenr('$'))
    let l:sel = i + 1 == tabpagenr()
    let s .= l:sel ? '%#TabLineSel#' : '%#TabLine#'
    " if sel
    "   let s .= '%#TabLineSel#' " WildMenu #???
    " else
    "   let s .= '%#TabLine#'
    " endif
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'
    " set page number string
    let s .= sel ? '[ ' : '  '
    let s .= i + 1
    "<nr>: <name>
    let s .= ':'
    " get buffer names and statuses
    let n = ''  " temp str for buf names
    "" let m = 0   " &modified counter

    let buflist = tabpagebuflist(i + 1)
    " loop through each buffer in a tab
    let l:buf_nr = 1
    let l:act_buf = winnr()
    for b in buflist
      if getbufvar(b, "&buftype") == 'help'
        " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
      elseif getbufvar(b, "&buftype") == 'quickfix'
        " let n .= '[Q]'
      elseif getbufvar(b, "&modifiable")
        let n .= ' %#TabLine'
        if getbufvar(b, "&modified")
          let n .= l:sel ? 'SelMod' : 'Mod'
        else
          let n .= l:sel ? 'Sel' : ''
        endif
        " add buffer names
        let l:b = bufname(b)
        let bn = l:b == '' ? g:Unnamed_buffer_name : l:b

        if &diff && l:b =~ 'LOCAL'
          let bn = 'MINE(local)'
        elseif &diff && l:b =~ 'REMOTE'
          let bn = 'THEIRS(remote)'
        endif
        let bn = fnamemodify(bn, ':t')
        if l:sel && l:buf_nr == l:act_buf
          let n .= 'Buf#' . bn
        else
          let n .= '#' . bn
        endif
        let n .= l:sel ? '%#TabLineSel# |' : '%#TabLine# |'
      endif
      let l:buf_nr += 1
    endfor
    "??? "let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, ' |$', ' ', '')
    if i + 1 == tabpagenr()
      let n .= ']'
    else
      let n .= ' '
    endif
    " if i + 1 == tabpagenr()
    "   let s .= '%#TabLineSel#'
    " else
    "   let s .= '%#TabLine#'
    " endif

    let s .= n
  endfor
  let s .= '%T'
  let s .= '%#TabLineFill#'
  let s .= '%='
  if v:hlsearch
    let s .= '%#SearchBar#'
    let s .= '%{ airline#extensions#searchcount#status(1) }'
  endif
  let s .= '%*'
  return s
endfunction

