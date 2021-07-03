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
    nnoremap <silent> n n:lua require("hlnext").HLNext()<CR>
endif
if maparg('N', 'n') == ""
    nnoremap <silent> N N:lua require("hlnext").HLNext()<CR>
endif
if maparg('*', 'n') == ""
    nnoremap <silent> * *:lua require("hlnext").HLNext()<CR>
endif
if maparg('#', 'n') == ""
    nnoremap <silent> # #:lua require("hlnext").HLNext()<CR>
endif

highlight default link HLNext IncSearch

augroup plugin-HLNext
    autocmd! CmdlineLeave [/?] :lua vim.schedule(require('hlnext').HLNext)
augroup END
