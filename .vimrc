:syntax on
:set number

" make me go to next line
set whichwrap=b,s,h,l,<,>,[,]

filetype off
call pathogen#runtime_append_all_bundles()
filetype on

autocmd BufNewFile,BufRead *.coffee set filetype=coffee


set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

