" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    autocmd!
    autocmd BufRead,BufNewFile *.cls setfiletype tex
augroup END
