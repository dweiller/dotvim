" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    autocmd! BufRead,BufNewFile *.cls setfiletype tex

    autocmd! BufNewFile,BufRead *.csv setfiletype csv
    autocmd! BufNewFile,BufRead *.fen setfiletype fen
    autocmd! BufNewFile,BufRead Tupfile,Tuprules.tup setfiletype tup
augroup END
