" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.cls setfiletype tex
  au! BufRead,BufNewFile *.md setfiletype markdown
augroup END
