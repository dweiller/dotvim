" Tagger - replace :PLACEHOLDERS: in files
" Maintainer:   Dominic Weiller
" Version:      0.1
" License:      This file is placed in the public domain.

" Initialisation {{{
if exists('g:loaded_tagger')
    finish
endif
let g:loaded_tagger = 1

if !exists('g:Tagger_delim')
    let g:Tagger_delim = ':'
endif

if !exists('g:Tagger_tag_pattern')
    let g:Tagger_tag_pattern = g:Tagger_delim . '\u\+' . g:Tagger_delim
endif

if !exists('g:Tagger_tag_exprs')
    let g:Tagger_tag_exprs = {}
endif
" }}}

command! TaggerAll :call <SID>replace_tags()
command! -nargs=* Tagger :call <SID>replace(<args>)
command! -nargs=+ TaggerTagExpr :call <SID>replace_expr(<f-args>)
command! -nargs=+ TaggerTagText :call <SID>replace_text(<f-args>)
command! TaggerSelNext :call <SID>select_tag()
command! -nargs=* TaggerSel :call <SID>select_tag(<f-args>)

" Implementation {{{
function! s:select_tag(...)
    if a:0 > 0
        let tag = g:Tagger_delim . a:1 . g:Tagger_delim
    else
        let tag = g:Tagger_tag_pattern
    endif
    let flags = get(a:000, 2, '')
    let stop = get(a:000, 3, 0)
    let timeout = get(a:000, 4, 0)
    call search(tag, flags, stop, timeout)
    execute 'normal! vf' . g:Tagger_delim
endfunction

function! s:replace_tags()
    for tag in
        call s:replace_tag(tag)
    endfor
endfunction

function! s:replace(...)
    for tag in a:000
        call replace_tag(tag)
    endfor
endfunction

function! s:replace_tag(tag)
    call s:replace_expr_unsafe(a:tag, get(g:Tagger_tag_exprs, a:tag, a:tag))
endfunction

function! s:replace_expr(...)
    if a:0 != 2
        echoerr 'tagger: replace_expr expects 2 arguments'
        return
    endif
    call s:replace_expr_unsafe(a:1, a:2)
endfunction

function! s:replace_expr_unsafe(tag, expr)
    call s:replace_text_unsafe(a:tag, execute(a:expr))
endfunction

function! s:replace_text(...)
    if a:0 != 2
        echoerr 'tagger: replace_text expects 2 arguments'
        return
    endif
    call s:replace_text_unsafe(a:1, a:2)
endfunction

function! s:replace_text_unsafe(tag, text)
    let pat = g:Tagger_delim . a:tag . g:Tagger_delim
    execute '%s/' . pat . '/' . a:text . '/g'
endfunction
" }}}
