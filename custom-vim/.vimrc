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

" set background=light
" colorscheme solarized
colorscheme desert
set background=dark

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
nmap <silent> ,tt :tabedit<CR>

" Navigate page
nmap <silent> ,j <C-F>
nmap <silent> ,k <C-B>

" Force sudo write!
cmap w!! w !sudo tee % >/dev/null

" Files that should be treated as HTML
au BufNewFile,BufRead *.partial set ft=html
au BufNewFile,BufRead *.less set filetype=less

" Set font
:set guifont=Monaco:h12
