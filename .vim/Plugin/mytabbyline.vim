" vim: et ts=2 sts=2 sw=2

fun s:generateTabBufList()
  let buffers = []
  let ignoreList = get(g:, 'tablineIgnoreFt', [])
  for tabPage in range(tabpagenr('$'))
    call extend(buffers, [[]])
    for currBuf in tabpagebuflist(tabPage + 1)
      let ft = getbufvar(currBuf, "&ft")
      if getbufvar(currBuf, "&modifiable") && index(ignoreList, ft) == -1
        let      bufName = bufname(currBuf)
        let shortBufName = fnamemodify(bufName, ':t')
        call extend(buffers[-1], [[currBuf, '', shortBufName]])
        for b in buffers[:-2]
          for buf in b
            if buf[2] == shortBufName
              let buffers[-1][-1][1] = fnamemodify(bufName, ':p:h:t') " 1 == path
              if empty(buf[1])
                let buf[1] = fnamemodify(bufname(buf[2]), ':p:h:t')
              else
                break
              endif
            endif
          endfor
        endfor
      endif
    endfor
  endfor
  return buffers
endfun


fun! MyTabbyLine()
  let s = '%#TabLineSession#'
  let l:sess = get(v:, "this_session", '')
  let s .= (empty(l:sess) ? '  ' : l:sess) . '%#TabLineSessionSep#'

  let currTabPageNr = tabpagenr()
  let tabIdx = 0
  for tab in s:generateTabBufList()
    let bufCnt = len(tab)
    let tabIdx += 1

    let l:multiBufTab = (bufCnt > 1)
    let l:sel         = (tabIdx == currTabPageNr)
    let l:currBuf     = winbufnr(0)

    let s .= '%' . tabIdx . 'T' " for mouse clicks
    let s .= '%#TabLine' . (l:sel ? 'Sel' : '')
    if bufCnt >= 1
      let s .= (getbufvar(tab[0][0], "&modified") ? 'Mod' : '')
    endif
    let s .= 'Sep#'
    let s .= '%#TabLine' . (l:sel ? 'Sel' : '') . '#'


    let sTab = ''
    for bufIdx in range(bufCnt)
      let [bufNr, path, name] = tab[bufIdx]

      ""     if &diff && l:b =~ 'LOCAL'
      ""       let l:bn = 'MINE(local)'
      ""     elseif &diff && l:b =~ 'REMOTE'
      ""       let l:bn = 'THEIRS(remote)'
      ""     endif

      let l:bufSel = (l:sel && bufNr == l:currBuf)
      let sTab .= '%#TabLine'
      let sTab .= l:bufSel ? 'Sel' : ''
      let sTab .= getbufvar(bufNr, "&modified") ? 'Mod' : ''
      let sTab .= '# ' . (empty(name) ? g:unnamed_buffer_name : ((empty(path) ? '' : path . '/') . name)) . ' '
      let sTab .= '%#TabLine#' . (bufIdx < bufCnt -1 ? '' : '')
    endfor

    let s .= sTab . '%#TabLine' . (l:sel ? 'Sel' : '')
    if bufCnt >= 1
      let s .= (getbufvar(tab[(bufCnt > 1) ? -1 : 0][0], "&modified") ? 'Mod' : '')
    endif
    let s .= 'Sep#'
  endfor

  let s .= '%#TabLineFill#%T%='
  let s .= (v:hlsearch ? '%#SearchBar#%{ airline#extensions#searchcount#status() } %*' : '')

  return s
  "return string(s:generateTabBufList())
endfun
