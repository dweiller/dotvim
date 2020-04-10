" Vim plugin for highlighting matches under cursor
" Last change:  Thu Mar 12 2020 22:39:13 PDT
" Maintainer:   Dominic Weiller
" License:      This file is paced in the public domain
"
" This is an adaptation of Damian Conway's HLNext plugin
" (see github.com/thoughtstream/Damian-Conway-s-Vim-Setup/plugin/hlnext.vim)

if exists('g:loaded_hlnext')
    finish
endif
let g:loaded_hlnext = 1

if maparg('n', 'n') == ""
    nnoremap <silent> n n:call <SID>HLNext()<CR>
endif
if maparg('N', 'n') == ""
    nnoremap <silent> N N:call <SID>HLNext()<CR>
endif
if maparg('*', 'n') == ""
    nnoremap <silent> * *:call <SID>HLNext()<CR>
endif
if maparg('#', 'n') == ""
    nnoremap <silent> # #:call <SID>HLNext()<CR>
endif
command HLNext :call <SID>HLNext()
command HLNextOff :call <SID>HLNextOff()

highlight default link HLNext IncSearch

function! s:HLNext()
    call s:HLNextOff()
    let target_pat = '\c\%#\('.@/.'\)'
    let w:HLNext_matchnum = matchadd('HLNext', target_pat, 101)
    augroup HLNext
        autocmd! CursorMoved * :call s:HLNextOff()
                                \ | autocmd! HLNext CursorMoved
    augroup END
endfunction

function! s:HLNextOff()
    if (exists('w:HLNext_matchnum') && w:HLNext_matchnum > 0)
        call matchdelete(w:HLNext_matchnum)
        unlet w:HLNext_matchnum
    endif
endfunction
