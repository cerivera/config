set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'git://git.wincent.com/command-t.git'
call vundle#end()            " required

" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

" Use pathogen to easily modify the runtime path plugins under the ~/.vim/bundle directory
execute pathogen#infect()
syntax on
filetype plugin indent on

" change the mapleader from \ to ,
let mapleader=","

" quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" hide unsaved buffers
set hidden

:set cursorline
set nowrap " don't wrap lines
set tabstop=4 " a tab is four spaces
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent " always set autoindenting on
set copyindent " copy the previous indentation on autoindenting 
set number " always show line numbers
set shiftwidth=4 " number of spaces to use for autoindenting
set shiftround " use multiple of shiftwidth when indenting with "<" and ">"
set showmatch " set show matching parenthesis
set ignorecase "ignore case when searching
set smartcase "ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch " highlight search terms
set incsearch " show search matches as you type

set history=1000 " remember more ommands and search history
set undolevels=1000 " use many levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title " change the terminal's title
set visualbell " don't beep
set noerrorbells "don't beep

set nobackup
set noswapfile

filetype plugin indent on
autocmd filetype python set expandtab
autocmd filetype javascript set expandtab
autocmd filetype html set expandtab

set background=light
colorscheme summerfruit256
" set background=dark

" Save some keystrokes by eliminating the shift key
nnoremap ; :

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

nnoremap j gj
nnoremap k gk

" easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Clear search with ,/
nmap <silent> ,/ :nohlsearch<CR>

" Quick tab open
nmap <silent> ,nt :tabedit<CR>

" Navigate page
nmap <silent> ,j <C-F>
nmap <silent> ,k <C-B>

" Force sudo write!
cmap w!! w !sudo tee % >/dev/null

" Files that should be treated as HTML
au BufNewFile,BufRead *.partial set ft=html
au BufNewFile,BufRead *.less set filetype=less

" Set font
:set guifont=Monaco:h11

" Command T exclusions
set wildignore+=*.png,*.o,*.jpg,*.pdf,dist/**,build/**,*.pyc,*.jpg,*.gif,*.jar,*.class,*.bak,*.swp

" Set dictionary
set dictionary=/usr/share/dict/words

" Enable spell checker
" set spell

" hotkeys for cycling grep results
nmap <silent> <C-N> :cn<CR>zv
nmap <silent> <C-P> :cp<CR>zv

" JSON support
autocmd BufNewFile,BufRead *.json set ft=javascript

" RAML support
autocmd BufNewFile,BufRead *.raml set ft=yaml

" Set statusline
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

" Turn on FTPlugin
filetype plugin indent on

