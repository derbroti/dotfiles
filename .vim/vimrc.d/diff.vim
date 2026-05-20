"""""""
"
" diff/merge config
"

" TODO: maybe an inverted-T layout could be nice?
"       needs a lot of care to not be chaotic
"       (window borders are currently intentionally non-intrusive)

if 0 " &diff
    fun s:diff_sel_middle_win()
        let l:id = get(win_findbuf(2), 0)
        if l:id == 0 | echoerr "Could not find MERGE diff window." | return 0 | endif
        :call win_gotoid(l:id)
        return 1
    endfun

    fun s:diff_update()
        if ! s:diff_sel_middle_win() | return | endif
        let s:diff_b_curr = bufnr()
        let s:diff_l_old  = line('.')
        let s:diff_l_curr = line('.')

        " find start of hunk
        while s:diff_l_curr -1 > 0 && synIDattr(diff_hlID(s:diff_l_curr - 1, 1), "name") =~ 'Diff'
            let s:diff_l_curr -= 1
        endwhile
        call cursor(s:diff_l_curr, 0)
    endfun

    fun s:diff_it(dir=-1)
        let s:diff_hi_now = synIDattr(diff_hlID(s:diff_l_curr, 1), "name")

        if sign_getplaced(s:diff_b_curr,
                        \ {'id': s:diff_l_curr, 'group': 'diff_group'})[0]['signs'] == [] &&
         \ s:diff_hi_now =~ "Diff"

            " compare the line we are interested in (it might have changed, i.e.: lines get added)
            let l:mid = getline(s:diff_l_curr)
            let l:l_mid_dist = abs(s:diff_l_curr - line('.'))
            exe ':noautocmd wincmd h'
            " since the windows are linked, we want the current line that matches the 'same' line in
            " the other window, unless we started 'on'(below...) a filler, then we have to compare to
            " the line on the left that is the distance we moved in our window upwards
            let l:hi = synIDattr(diff_hlID(line('.'), 1), "name")
            let l:l = line('.') - (l:hi !~ 'Diff' ? l:l_mid_dist : 0)
            let l:line = getline(l:l)
            exe ':noautocmd wincmd l'

            :call sign_place(s:diff_l_curr, 'diff_group',
                           \ (l:line == l:mid) ? 'mySignLeft' : 'mySignRight',  s:diff_b_curr,
                           \ {'lnum': s:diff_l_curr, 'priority': 1000 })
        else
            if s:diff_hi_now !~ 'Diff'
                call sign_unplace('diff_group', {'buffer': s:diff_b_curr, 'id': line('.')})
            else
                if a:dir > -1
                    if a:dir == 0     " left
                        let l:dir = 'mySignLeft'
                    elseif a:dir == 1 " right
                        let l:dir = 'mySignRight'
                    endif
                    call sign_place(s:diff_l_curr, 'diff_group', l:dir, s:diff_b_curr)
                endif
                call cursor(s:diff_l_old, 0)
            endif
        endif
    endfun

    fun s:diffview()
        " always start on line 1
        exec 'norm gg'

        " make filler lines (removed lines) less intrusive
        set fillchars+=diff:╱,
        " make folds less intrusive
        hi FoldColumn     ctermbg=none ctermfg=61
        hi Folded         ctermbg=none ctermfg=61
        " make diff more intrusive ;)
        hi DiffAdd    cterm=none ctermfg=15  ctermbg=2
        hi DiffChange cterm=none ctermfg=15  ctermbg=4
        hi DiffDelete cterm=none ctermfg=236 ctermbg=none
        " 9
        hi DiffText   cterm=none ctermfg=0  ctermbg=3
        hi DiffSign   cterm=bold ctermfg=1  ctermbg=4

        call sign_define("mySignRight",     { "text" : "->", "texthl" : "DiffSign", "linehl" : ""} )
        call sign_define("mySignLeft",      { "text" : "<-", "texthl" : "DiffSign", "linehl" : ""} )
        " call sign_define("mySignLeftRight", { "text" : "<>", "texthl" : "DiffSign", "linehl" : ""} )
        " call sign_define("mySignRightLeft", { "text" : "><", "texthl" : "DiffSign", "linehl" : ""} )

        " next diff
        nnoremap <silent> <tab> ]c<bar>:call <SID>diff_update()<cr><bar>:call <SID>diff_it()<cr>
        " prev diff
        nnoremap <silent> <S-tab> [c<bar>:call <SID>diff_update()<cr><bar>:call <SID>diff_it()<cr>
        " merge by using mine
        nnoremap <silent><nowait> [ :call <SID>diff_update()<cr><bar>:diffget LOCAL<bar>call <SID>diff_it(0)<cr>
        " merge by using theirs
        nnoremap <silent><nowait> ] :call <SID>diff_update()<cr><bar>:diffget REMOTE<bar>call <SID>diff_it(1)<cr>

        "nnoremap <silent><nowait> { :call <SID>diff_add_mine()<cr>
        "nnoremap <silent><nowait> } :call <SID>diff_add_theirs()<cr>
        "nnoremap <silent><nowait> + :call <SID>diff_neither()<cr>

        " ignore white space diffs
        set diffopt+=iwhite
        " show 2 lines around the diff
        set diffopt+=context:2
        " follow the wrabbit
        set diffopt+=followwrap
        " more human compatible diff
        set diffopt+=algorithm:patience
        " remove fold sign column
        windo setlocal foldcolumn=0
        " select middle win = the 'to be merged' one
        call <SID>diff_sel_middle_win()
        " merge signs and line numbers
        set signcolumn=number

        " TODO maybe disable coli.vim (at least for other windows)
    endfun

    autocmd VimEnter * :call <SID>diffview()
endif

