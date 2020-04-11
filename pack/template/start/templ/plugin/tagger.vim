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
    let g:Tagger_tag_pattern = '\u\+'
endif

if !exists('g:Tagger_tag_exprs')
    let g:Tagger_tag_exprs = {}
endif

if !exists('g:Tagger_stopline')
    let g:Tagger_stopline = 0
endif

if !exists('g:Tagger_timeout')
    let g:Tagger_timeout = 0
endif
" }}}

command! -nargs=* TaggerAll :call <SID>replace_tags(<f-args>)
command! -nargs=* Tagger :call <SID>replace_tag(<f-args>)

" Implementation {{{

function! s:wrap_tag(tag)
    return g:Tagger_delim . a:tag . g:Tagger_delim
endfunction

function! s:search(tag, ...)
    let flags = a:0 ? a:1 : 'wc'
    return search(s:wrap_tag(a:tag),
                    \ flags, g:Tagger_stopline, g:Tagger_timeout)
endfunction

function! s:replace_tags(...)
    let windowview = winsaveview()
    if a:0
        call s:replace_all_one_tag(a:1, a:0 > 1 ? a:2 : '')
    else
        call s:replace_all_tags()
    endif
    call winrestview(windowview)
endfunction

function! s:replace_all_one_tag(tag, replacement)
    if !empty(a:replacement)
        while s:search(a:tag) > 0
            call s:replace_text_unsafe(a:tag, a:replacement)
        endwhile
    elseif has_key(g:Tagger_tag_exprs, a:tag)
        while s:search(a:tag) > 0
            call s:replace_expr_unsafe(a:tag, g:Tagger_tag_exprs[a:tag])
        endwhile
    endif
endfunction

function! s:replace_all_tags()
    call cursor(1,1)
    while s:search(g:Tagger_tag_pattern, 'W')
        let line = getline(line('.'))
        let pattern = g:Tagger_delim . '\zs'
                \ . g:Tagger_tag_pattern . '\ze' . g:Tagger_delim
        let tag = matchstr(line, pattern, col('.') - 1)
        if has_key(g:Tagger_tag_exprs, tag)
            call s:replace_expr_unsafe(tag, g:Tagger_tag_exprs[tag])
        else
            call cursor(line('.'), col('.') + 1)
        endif
    endwhile
endfunction


function! s:replace_tag(...)
    let tag = a:0 ? a:1 : g:Tagger_tag_pattern
    if ! s:search(tag)
        return
    endif
    if a:0 > 1
        call s:replace_text_unsafe(tag, a:2)
    elseif has_key(g:Tagger_tag_exprs, tag)
        call s:replace_expr_unsafe(tag, g:Tagger_tag_exprs[tag])
    else
        execute 'normal! vf' . g:Tagger_delim . "\<C-G>"
    endif
endfunction

function! s:replace_expr_unsafe(tag, expr)
    call s:replace_text_unsafe(a:tag, eval(a:expr))
endfunction

function! s:replace_text_unsafe(tag, text)
    let pattern = escape(s:wrap_tag(a:tag), '/')
    let replace = escape(a:text, '/')
    execute 's/' . pattern . '/' . replace . '/'
endfunction
" }}}
