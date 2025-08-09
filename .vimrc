let s:plugdir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(s:plugdir . '/autoload/plug.vim'))
	silent execute '!curl -fLo ' . s:plugdir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set encoding=UTF-8
set fileencodings=UTF-8,latin1

call plug#begin()
	Plug 'bfrg/vim-c-cpp-modern'
	Plug 'jasonccox/vim-wayland-clipboard'
	Plug 'airblade/vim-gitgutter'
call plug#end()

filetype plugin indent on
syntax on
set termguicolors
color root-loops

let &t_EI = "\e[2 q" " Block cursor
let &t_SR = "\e[4 q" " Underline cursor
let &t_SI = "\e[6 q" " Beam cursor

set hidden " Better buffer management?

set showcmd
set showmatch
set matchtime=5

set virtualedit=all
set foldmethod=marker

set scrolloff=4
set sidescrolloff=4

set splitbelow
set splitright

set cursorlineopt=screenline,number
set cursorline

set numberwidth=2
set relativenumber
set number
set signcolumn=yes

set wildmenu
set wildmode=list:longest,full
set completeopt=menuone,noinsert,noselect,preview " Don't know what this one does

set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set cinoptions=g0,(s,us,U1,ks,m1
set noexpandtab
set shiftround

set incsearch
set hlsearch
set ignorecase
set smartcase
set gdefault

set listchars=tab:│\ \ ,trail:·
set list
set wrap
set linebreak
set breakindent
set showbreak=↯\ 

set updatetime=500
set timeoutlen=500 " Time to wait before breaking mapped key sequence
set ttimeoutlen=50
set lazyredraw

set backup
set swapfile
set undofile
set viminfo='1000,f1,<500,h,%,:100 " Increase viminfo for more history and saved items

let s:vimdir = has('nvim') ? stdpath('data') : expand('~/.vim')

let &backupdir = s:vimdir . '/backup//'
let &directory = s:vimdir . '/swap//'
let &undodir = s:vimdir . '/undodir//'

for dir in [&backupdir, &directory, &undodir]
	if !isdirectory(dir)
		call mkdir(dir, 'p', 0o700)
	endif
endfor

let mapleader = "\<space>"

nnoremap <leader>l :source $MYVIMRC<cr>
nnoremap <leader>v :tabnew $MYVIMRC<cr>

nnoremap <leader>w :w!<cr>
nnoremap <leader>Q :q!<cr>
nnoremap <leader>x :x!<cr>
nnoremap <leader>q :bd<cr>

nnoremap <c-j> <c-w>j
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-k> <c-w>k
nnoremap <c-w>v :vsplit<cr>
nnoremap <c-w>s :split<cr>

nnoremap H :tabprev<cr>
nnoremap L :tabnext<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tc :tabclose<cr>

nnoremap <leader>s :set spell!<cr>
nnoremap <leader><leader> :nohlsearch<cr>
nnoremap <leader>tr :silent! %s/\s\+$//<cr> :nohlsearch<cr>

nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap 0 g0

" Deletion candy
tnoremap <esc> <c-\><c-n>

nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Nasty stuff
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>a ggVG
nnoremap <leader>d :t.<cr>

if has("autocmd")
	augroup autovimrc
		autocmd!
		" Return to last edit position when opening files
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	augroup END
endif

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '↾'
let g:gitgutter_sign_removed_above_and_below = '⇌'
let g:gitgutter_sign_modified_removed = '±'
