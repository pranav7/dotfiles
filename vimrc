set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Plugin 'VundleVim/Vundle.vim'

" My Plugins
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rake'
Plugin 'scrooloose/nerdtree'
Plugin 'Raimondi/delimitMate'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-endwise'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-abolish'
Plugin 'Yggdroot/indentLine'
Plugin 'gorodinskiy/vim-coloresque'
Plugin 'digitaltoad/vim-pug'
Plugin 'slim-template/vim-slim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'scrooloose/nerdcommenter'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'thoughtbot/vim-rspec'
Plugin 'ivalkeen/vim-ctrlp-tjump'
Plugin 'isRuslan/vim-es6'
Plugin 'itchyny/lightline.vim'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax on
colorscheme onedark

set linespace=3
set cursorline
set modelines=0
set clipboard=unnamed
set ttyscroll=10
set nowrap
set number
set expandtab
set nowritebackup
set noswapfile
set nobackup
set ignorecase
set smartcase
set hlsearch
set incsearch
set relativenumber
set foldenable
set wildmenu
set lazyredraw
set showmatch
set smarttab
set guifont=Menlo\ Regular:h12
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set encoding=utf-8
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set lines=999 columns=9999

" Use Silver Searcher instead of grep
set grepprg=ag

map <Leader>sn :e ~/.vim/snippets/ruby.snippets<CR>
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
nmap <Leader>pi :source ~/.vimrc<cr>:PluginInstall<cr>
nmap <leader>s<left>   :leftabove  vnew<cr>
nmap <leader>s<right>  :rightbelow vnew<cr>
nmap <leader>s<up>     :leftabove  new<cr>
nmap <leader>s<down>   :rightbelow new<cr>
map <leader>pdb oimport pdb; pdb.set_trace()<esc>:w<cr>
map <Leader>pry obinding.pry<esc>:w<cr>
noremap <tab> <c-w><c-w>
map <Leader>nhash :call UpdateHashSyntax()<CR>

map <C-h> :nohl<cr>
imap <C-l> :<Space>
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <C-x> <C-w>

" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg', '\.pyc$', '\~$']
" NERCCommenter
let g:NERDSpaceDelims = 2

nnoremap <C-S> :update<cr>
inoremap <C-S> <Esc>:update<cr>gi
nnoremap zz :update<cr>
noremap <c-c> yy<cr>

set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
" space open/closes folds
nnoremap <space> za

" CtrlP
nnoremap <silent> t :CtrlP<cr>
nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 20000
let g:ctrlp_match_window = 'bottom, order:btt, min:1, max:40, results:40'
set wildignore+=*/db/migrate/**
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**
set wildignore+=*/deps/**
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
set wildignore+=*/_build/**
set wildignore+=*/public/**
set wildignore+=*/venv/**

let g:rspec_runner = "os_x_iterm2"

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#212d33   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#29353a   ctermbg=4

if has("gui_macvim")
  " Press Ctrl-Tab to switch between open tabs (like browser tabs) to
  " the right side. Ctrl-Shift-Tab goes the other way.
  noremap <C-Tab> :tabnext<CR>
  noremap <C-S-Tab> :tabprev<CR>

  " Switch to specific tab numbers with Command-number
  noremap <D-1> :tabn 1<CR>
  noremap <D-2> :tabn 2<CR>
  noremap <D-3> :tabn 3<CR>
  noremap <D-4> :tabn 4<CR>
  noremap <D-5> :tabn 5<CR>
  noremap <D-6> :tabn 6<CR>
  noremap <D-7> :tabn 7<CR>
  noremap <D-8> :tabn 8<CR>
  noremap <D-9> :tabn 9<CR>
  " Command-0 goes to the last tab
  noremap <D-0> :tablast<CR>
endif

function UpdateHashSyntax()
  %s/:\([^ ]*\)\(\s*\)=>/\1:/g
endfunction
