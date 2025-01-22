set nocompatible " vi互換をOFF

"" Encoding
set encoding=UTF-8 "文字コードをUTF-8にする
set fileencoding=UTF-8 "文字コードをUTF-8にする
set termencoding=UTF-8 "文字コードをUTF-8にする

"" File
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

"" Search
set incsearch "インクリメンタルサーチを行う
set hlsearch "検索結果をハイライトする
set ignorecase "検索時に文字の大小を区別しない
set smartcase "検索時に大文字を含んでいたら大小を区別する
set wrapscan "検索をファイルの先頭へループする

"" 挿入モード中に'Ctr-*'でコマンドモードでの移動・削除を可能にする
inoremap <c-d> <delete>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>

"" Display
colorscheme desert
set background=dark
syntax on
syntax enable
set number
set title
set laststatus=2
set list
set listchars=eol:$,tab:>\ ,extends:< "listで表示される文字のフォーマットを指定する

" make me go to next line
set whichwrap=b,s,h,l,<,>,[,]

if has("mouse")
    set mouse=a
endif

"" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et

"" YankRing.vim
" , y でヤンク履歴
nmap ,y :YRShow<CR>
