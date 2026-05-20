"""""""""""""""""
""""""""" SESSION

let s:projectFolder = '.vim_project'
let s:projectFileName = '_project.1.0'

let g:SessionName = ""
let g:SessionServer = ""
" serialized - will be converted to list when loaded

let g:SessionPathMap = []
let g:SessionPath = ""
let g:SessionProjectPath = ""

" TODO FIXME !!!!!!!

"let g:SessionServer = g:SessionServerLocal
"let g:SessionPathMap = g:SessionPathMapLocal
"let g:SessionPath = getcwd()


let s:openWithFile = expand('%:p')
let s:cwd = getcwd()

let s:sessionFile = s:projectFolder . '/' . s:projectFileName

""""""""""""""""
""" LOAD SESSION

fun s:startsWith(a, b)
    let lenA = len(a:a)
    let lenB = len(a:b)
    if (lenA >= lenB)
        return a:a[0:max([0, lenB-1])] ==# a:b
    else
        return a:b[0:max([0, lenA-1])] ==# a:a
    endif
endfun

"TODO FIX...
if 0 && (filereadable(s:sessionFile) && (s:startsWith(s:openWithFile, s:cwd) || empty(s:openWithFile)))
    let &sessionoptions .= ',sesdir'
    silent exec ':source ' . s:projectFolder . '/' . s:projectFileName
    let v:this_session = g:SessionName
    exec 'let g:SessionPathMap = ' . g:SessionPathMap
    let &directory = g:SessionProjectPath . '/undo//' . ',' . &directory
    let &undodir   = g:SessionProjectPath . '/swap//' . ',' . &undodir
else
    let &sessionoptions .= ',curdir'
endif

fun MakeSession()
    let g:SessionPath = getcwd()
    let g:SessionProjectPath = g:SessionPath . '/' .s:projectFolder
    let g:SessionName = g:SessionNameLocal
    let g:SessionServer = g:SessionServerLocal
    let g:SessionPathMap = string(g:SessionPathMapLocal)
    unlet g:SessionNameLocal
    unlet g:SessionServerLocal
    unlet g:SessionPathMapLocal

    if !isdirectory(g:SessionProjectPath)
        call mkdir(g:SessionProjectPath, 'p', 0700)
        call mkdir(g:SessionProjectPath . '/undo/', 'p', 0700)
        call mkdir(g:SessionProjectPath . '/swap/', 'p', 0700)
    endif

    " TODO BROKEN: sesssionmap would be a string atferwards...
    "":exec ':mksession! ' . g:SessionProjectPath . '/' . s:projectFileName
    "" let v:this_session = g:SessionName
    "" echo "Session Saved"
endfun

command Mks call MakeSession()
