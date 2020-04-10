" Templ - simple template loading
" Maintainer:   Dominic Weiller
" Version:      0.1
" License:      This file is placed in the public domain.

if exists('g:loaded_templ')
    finish
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
        let skeletons = Templ_templates(extension)
        if !empty(skeletons)
            execute "0read " . skeletons[0]
        endif
    endif
endfunction

function! s:install()
    augroup Templ
        autocmd!
        for ext in g:Templ_extensions
            execute 'autocmd BufNewFile *.' . ext . ' TemplLoad ' . ext . ''
        endfor
    augroup END
endfunction

function! s:uninstall()
    autocmd! Templ
endfunction

function! Templ_templates(...)
    if a:0
        return globpath(&rtp, 'templates/*.' . a:1, 1, 1)
    else
        return globpath(&rtp, 'templates/*', 1, 1)
    endif
endfunction

command -nargs=? TemplLoad :call <SID>load(<f-args>)
command TemplInstall :call <SID>install()
command TemplUninstall :call <SID>uninstall()

if !exists('g:Templ_disable_on_startup') || !g:Temple_disable_on_startup
    call s:install()
endif
