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

if !exists('g:Tagger_pattern')
    let g:Tagger_pattern = '\(\u\|-\)\+'
endif

if !exists('g:Tagger_exprs')
    let g:Tagger_exprs = {}
endif
" }}}

command! -nargs=* TaggerAll :call <SID>replace_tags(<f-args>)
command! -nargs=* Tagger :call <SID>replace_tag(<f-args>)

" Implementation {{{
function! s:wrap_tag(tag)
    return g:Tagger_delim . a:tag . g:Tagger_delim
endfunction

function! s:search(tag, ...)
    let flags = a:0 ? a:1 : 'Wc'
    return search(s:wrap_tag(a:tag), flags)
endfunction

function! s:replace_tags(...)
    if a:0
        call s:replace_all_one_tag(a:1, a:0 > 1 ? a:2 : '')
    else
        call s:replace_all_tags()
    endif
endfunction

" get_tag() requires the cursor to be positioned on the first delimiter of a
" tag
function! s:get_tag()
    let line = getline(line('.'))
    let pattern = g:Tagger_delim . '\zs'
                    \ . g:Tagger_pattern . '\ze' . g:Tagger_delim
    return matchstr(line, pattern, col('.') - 1)
endfunction

function! s:replace_all_tags(...)
    let windowview = winsaveview()
    call cursor(1,1)
    let pattern = a:0 ? a:1 : g:Tagger_pattern
    if a:0 > 1
        while s:search(pattern) > 0
            call s:replace_text_unsafe(pattern, a:2)
        endwhile
    else
        while s:search(pattern) > 0
            let tag = s:get_tag()
            if has_key(g:Tagger_exprs, tag)
                call s:replace_expr_unsafe(tag, g:Tagger_exprs[tag])
            else
                call cursor(line('.'), col('.') + 1)
            endif
        endwhile
    endif
    call winrestview(windowview)
endfunction

function! s:replace_tag(...)
    let pattern = a:0 ? a:1 : g:Tagger_pattern
    if ! s:search(pattern, 'wc')
        return
    endif
    let tag = s:get_tag()
    if a:0 > 1
        call s:replace_text_unsafe(tag, a:2)
    elseif has_key(g:Tagger_exprs, tag)
        call s:replace_expr_unsafe(tag, g:Tagger_exprs[tag])
    else
        execute 'normal! vf' . g:Tagger_delim . "\<C-G>"
    endif
endfunction

function! s:replace_expr_unsafe(pat, expr)
    call s:replace_text_unsafe(a:pat, eval(a:expr))
endfunction

function! s:replace_text_unsafe(pat, text)
    let pattern = escape(s:wrap_tag(a:pat), '/')
    let replace = escape(a:text, '/')
    execute 's/\%#' . pattern . '/' . replace . '/'
endfunction
" }}}
