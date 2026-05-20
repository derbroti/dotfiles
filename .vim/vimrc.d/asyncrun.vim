""""""""""""""""""
"  asyncrun.vim
"

"if g:SessionServer != "" && g:SessionPathMap != []
if v:true
    " let &errorformat='%*[^"]"%f"%*\D%l: %m,"%f"%*\D%l: %m,%-Gg%\?make[%*\d]: *** [%f:%l:%m,%-Gg%\?make: *** [%f:%l:%m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,"%f"\, line %l%*\D%c%*[^ ]%m,%D%*\a[%*\d]: Entering directory %*[`' . "']%f',%X%*\\a[%*\\d]: Leaving directory %*[`']%f',%D%*\\a: Entering directory %*[`']%f',%X%*\\a: Leaving directory %*[`']%f',%DMaking %*\\a in %f,%f|%l| %m"

    " %*[^"]"%f"%*\D%l:%c: %m,%*[^"]"%f"%*\D%l: %m,"%f"%*\D%l:%c: %m,"%f"%*\D%l: %m,%-G%f:%l: %trror: (Each undeclared identifier is reported only once,%-G%f:%l: %trror: for each function it appears in.),%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %m,%f:%l: %trror: %m,%f:%l: %tarning: %m,%f:%l: %m,%f:\(%*[^\)]\): %m,"%f"\, line %l%*\D%c%*[^ ] %m,%D%*\a[%*\d]: Entering directory %*[`']%f',%X%*\a[%*\d]: Leaving directory %*[`']%f',%D%*\a: Entering directory %*[`']%f',%X%*\a: Leaving directory %*[`']%f',%DMaking %*\a in %f

    :compiler! gcc

    let g:asyncrun_map_paths = g:SessionPathMap
    let g:make_runner_make_inst = ""
    " "ssh " . g:SessionServer . " \"cd " . substitute(g:SessionPath, g:SessionPathMap[0][1], g:SessionPathMap[0][0], '') . " && CONFIG=debug make -j8 mcx\""

    " send SIGINT when stopping the job
    " Note: currently we send SIGKILL because we are in a multiplexed ssh connection
    let g:asyncrun_stop = 'int'
    " scroll always, unless we call as: AsyncRun!
    let g:asyncrun_last = 2
    " do not rename the buffer, so our hack to name it like the -name param works
    let g:asyncrun_term_rename = -1

    fun s:makeRunner(inst)
        if &ft != 'cpp'
            let &errorformat .= ",%-GCompiling %.%#,%-GLinking %.%#,%-GINFO:%.%#"
            let &errorformat .= ",%Dmake: Entering directory '%f'"
            let &errorformat .= ",%Xmake: Leaving directory '%f'"
        endif
        :exec ":AsyncRun! -mode=async -auto=make -scroll=0 -silent -pos=bottom -strip -focus=0 " . a:inst
    endfun

    nmap <silent> <leader>m :call <SID>makeRunner(g:make_runner_make_inst)<cr>
    " kill multiplexed ssh
    nnoremap <silent> <leader>M :AsyncStop!<cr>
    " <option>+m is µ
    nnoremap <silent> <leader>µ :call asyncrun#quickfix_toggle(8)<cr>

    let s:async_run_status_canceled = 0
    let s:async_run_status_start_time = 0
    let s:async_run_status_timer = ""
    let s:async_run_status_update_idx = 0

    " let s:spinner = {0: '-', 1: '\', 2: '|', 3: '/'}
    " let s:spinner = {0: '⢎⡰', 1: '⢎⡡', 2: '⢎⡑', 3: '⢎⠱', 4: '⠎⡱', 5: '⢊⡱', 6: '⢌⡱', 7: '⢆⡱' }
    " let s:spinner_full = '⢎⡱'
    let s:spinner = {0: '⠋', 1: '⠙', 2: '⠸', 3: '⠴', 4: '⠦', 5: '⠇'}
    let s:spinner_full = '⠿'

    fun s:async_run_status_updated()
        let s:async_run_status_update_idx = (s:async_run_status_update_idx + 1) % len(s:spinner)
    endfun
    fun s:async_run_status_start_timer()
        let s:async_run_status_start_time = localtime()
        let s:async_run_status_canceled = 0
    endfun
    fun s:async_run_status_timer()
        let s:async_run_status_timer = localtime() - s:async_run_status_start_time
        call airline#update_statusline()
    endfun
    fun s:async_run_interrupt()
        let s:async_run_status_canceled = 1
        call airline#update_statusline()
    endfun

    au User AsyncRunStop call airline#update_statusline()
    au User AsyncRunPre call <SID>async_run_status_start_timer()
    au User AsyncRunInterrupt call <SID>async_run_interrupt()
    au User async_run_job_timer call <SID>async_run_status_timer()
    au User async_run_job_printed call <SID>async_run_status_updated()
endif

if g:SessionServer != ""
    fun On_async_run_status(state)
        if a:state == g:asyncrun_status
            if a:state == "success"
                return "\ua0".'✔'
            elseif a:state == "failure"
                if s:async_run_status_canceled == 1
                    return "\ua0" . s:spinner_full
                else
                    return "\ua0" . '✘'
                endif
            elseif a:state == "running"
                return "\ua0" . get(s:spinner, s:async_run_status_update_idx, s:spinner_full) . " " . strftime("%M:%S", s:async_run_status_timer)
            endif
        endif
        return ''
    endfun
    call airline#parts#define_raw('async_run_success', '%{On_async_run_status("success")}')
    call airline#parts#define_raw('async_run_failure', '%{On_async_run_status("failure")}')
    call airline#parts#define_raw('async_run_running', '%{On_async_run_status("running")}')
endif

""""
