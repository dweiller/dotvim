" Templ - simple template loading
" Maintainer:   Dominic Weiller
" Version:      0.1
" License:      This file is placed in the public domain.

if exists('g:loaded_templ')
    exit
endif
let g:loaded_templ = 1

if !exists('g:Templ_extensions')
    let g:Templ_extensions = [ 'vim', 'sh' ]
endif

function! s:load(...)
    if a:0
        let extension = a:1
    else
        let extension = expand('%:e')
    endif

    if !empty(extension)
        let skeletons = globpath(&rtp, 'templates/*.' . extension, 0, 1)
        if !empty(skeletons)
            execute "0read " . skeletons[0]
        endif
    endif
endfunction

function! s:install()
    augroup Templ
        autocmd!
        for ext in g:Templ_extensions
            execute 'autocmd BufNewFile *.' . ext . ' TemplLoad "' . ext . '"'
        endfor
    augroup END
endfunction

command -nargs=? TemplLoad :call <SID>load(<args>)
command TemplInstall :call <SID>install()

call s:install()
