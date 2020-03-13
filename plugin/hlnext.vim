" Vim plugin for highlighting matches under cursor
" Last change:  Thu Mar 12 2020 22:39:13 PDT
" Maintainer:   Dominic Weiller
" License:      This file is paced in the public domain
"
" This is an adaptation of Damian Conway's HLNext plugin
" (see github.com/thoughtstream/Damian-Conway-s-Vim-Setup/plugin/hlnext.vim)
" Changes that have been made:
"   - a call to HLNext(), moving the cursor calls HLNextOff()
"   - * and # have been made
"   - the functions have been defined with <SID> with commands HLNext and
"     HLNextOff defined to replace them
"   - HLNextOff() is called when unsetting hlsearch

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

augroup HLNext
    autocmd!
    autocmd ColorScheme * highlight HLNext guibg=red guifg=black
augroup END

function! s:HLNext()
    call s:HLNextOff()
    let target_pat = '\c\%#\('.@/.'\)'
    let w:HLNext_matchnum = matchadd('HLNext', target_pat, 101)
    call s:HLNextSetTrigger()
endfunction

function! s:HLNextOff()
    if (exists('w:HLNext_matchnum') && w:HLNext_matchnum > 0)
        call matchdelete(w:HLNext_matchnum)
        unlet w:HLNext_matchnum
    endif
endfunction

function! s:HLNextSetTrigger()
    augroup HLNextTrigger
        autocmd!
        autocmd CursorMoved * :call s:HLNextMovedTrigger()
    augroup END
endfunction

function! s:HLNextMovedTrigger()
    augroup HLNextTrigger
        autocmd!
    augroup END
    call s:HLNextOff()
endfunction
