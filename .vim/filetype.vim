if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au BufNewFile,BufRead *.html setlocal noexpandtab indentexpr=
augroup END

