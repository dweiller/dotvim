" OverPair - skip over matched brackets when typing!
" Maintainer:   Dominic Weiller
" Version:      0.1
" License:      This file is placed in the public domain.

" Plugin initialisation {{{
if exists('g:loaded_overpair')
    finish
endif
let g:loaded_overpair = 1

if !exists('g:OverPair_timeout')
    let g:OverPair_timeout = 60
endif
" }}}
" Commands {{{
command! OverPairEnable :call <SID>enable()
command! OverPairDisable :call <SID>disable()
" }}}
" Implementation {{{
function! s:enable()
    augroup OverPair
        autocmd!
        autocmd InsertCharPre * :call <SID>input()
    augroup END
endfunction

function! s:disable()
    augroup OverPair
        autocmd!
    augroup END
    augroup! OverPair
endfunction

function! s:input()
    let plist = split(&matchpairs, '.\zs[:,]')
    let i = index(plist, v:char)
    " bail out if we didn't enter a character in matchpairs
    " or we entered a opening character
    if i % 2 == 0
    endif
    if i < 0 || i % 2 == 0
        return
    endif

    let char = plist[i-1]

    if s:unbalanced(char, v:char)
        return
    endif

    let [m_lnum, m_col] =
        \ searchpairpos(char, '', v:char, 'nW', '', line('w$'), g:OverPair_timeout)
    if m_lnum > 0
        call cursor(m_lnum, m_col + 1)
        let v:char = ''
    endif
endfunction

function! s:unbalanced(c1, c2)
    let r_val = 0
    let save_cursor = getcurpos()
    if searchpair(a:c1, '', a:c2, 'brW', '', line('w0'), g:OverPair_timeout) <= 0
        let r_val = 1
    endif
    if searchpair(a:c1, '', a:c2, 'W', '', line('w$'), g:OverPair_timeout) <= 0
        let r_val = 1
    endif
    call setpos('.', save_cursor)
    return r_val
endfunction

"  Enable by default
if !exists('g:OverPair_disable') || !g:OverPair_disable
    OverPairEnable
endif
" }}}
" Modeline {{{
" vim: foldenable
