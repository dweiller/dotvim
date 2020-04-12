" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    autocmd!
    autocmd BufRead,BufNewFile *.cls setfiletype tex

    " vim help files not in $RUNTIMEPATH
    autocmd BufRead,BufNewFile */pack/*/start/*/doc/*.txt setfiletype help
    autocmd BufRead,BufNewFile */pack/*/opt/*/doc/*.txt setfiletype help
    autocmd BufRead,BufNewFile ~/.config/nvim/*/doc/*.txt setfiletype help
    autocmd BufRead,BufNewFile ~/.vim/*doc/*.txt setfiletype help
augroup END
