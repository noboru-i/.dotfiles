set noswapfile
set confirm
set cmdheight=2
set showcmd
set scrolloff=5
set ruler

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

syntax on
syntax enable
set number

" make me go to next line
set whichwrap=b,s,h,l,<,>,[,]

set nocompatible
if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'


