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
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'
    " set page number string
    let s .= sel ? '[ ' : '  '
    let s .= i + 1
    let s .= ':'

    let buflist = tabpagebuflist(i + 1)
    let l:multi_buf = len(buflist) > 1
    let l:act_buf = winnr()

    let l:buf_nr = 1
    " loop through each buffer in a tab
    let n = ''  " temp str for buf names
    for b in buflist
      "" TODO
      "" if getbufvar(b, "&buftype") == 'quickfix'
      ""  " let n .= '[Q]'
      let n .= ' %#TabLine'
      let n .= l:sel ? 'Sel' : ''

      if getbufvar(b, "&modifiable")
        let n   .= getbufvar(b, "&modified") ? 'Mod' : ''
        let l:b  = bufname(b)
        let bn   = l:b == '' ? g:Unnamed_buffer_name : l:b

        if &diff && l:b =~ 'LOCAL'
          let bn = 'MINE(local)'
        elseif &diff && l:b =~ 'REMOTE'
          let bn = 'THEIRS(remote)'
        endif

        let bn = fnamemodify(bn, ':t')

      elseif getbufvar(b, "&buftype") == 'help'
        let bn = '󰘥 ' . fnamemodify(bufname(b), ':t:s/.txt$//')
      endif

      if l:sel && l:multi_buf && l:buf_nr == l:act_buf
        let n .= 'Buf#' . bn
      else
        let n .= '#' . bn
      endif
      let n .= l:sel ? '%#TabLineSel# |' : '%#TabLine# |'

      let l:buf_nr += 1
    endfor
    "??? "let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, ' |$', ' ', '')
    if i + 1 == tabpagenr()
      let n .= ']'
    else
      let n .= ' '
    endif

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

