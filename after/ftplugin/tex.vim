let g:EvinceSyncTexScript = expand("<sfile>:p:h") . '/evince_dbus.py'

function! s:SyncForward(pdffile, linenumber, sourcefile)
    exec 'silent ! python3 ' . shellescape(g:EvinceSyncTexScript) . ' ' .
        \ shellescape(a:pdffile) . ' ' .
        \ a:linenumber . ' ' .
        \ shellescape(bufname("%"))
endfunction

function! SyncTexForwardSearch()
    let filename = bufname("%")
    let lineno = line(".")
    for syncfile in split(system('rg -lz ' . shellescape(filename) . ' -g *.synctex.gz'), "\n")
        let pdffile = substitute(fnameescape(syncfile), ".synctex.gz$", ".pdf", "")
        call s:SyncForward(pdffile, lineno, filename)
    endfor
endfunction

map <buffer> <LocalLeader>e :call SyncTexForwardSearch()<CR>

setlocal makeprg=pdflatex\ --synctex=13\ -file-line-error\ -interaction=nonstopmode\ %\ \|\ grep\ -P\ ':\\d{1,5}:\ '
setlocal errorformat=%f:%l:\ %m
