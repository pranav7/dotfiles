set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
 
" My Plugins
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-rake'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'bling/vim-airline'
Plugin 'daylerees/colour-schemes', { 'rtp': 'vim/' }
Plugin 'mustache/vim-mustache-handlebars' 
Plugin 'kchmck/vim-coffee-script'

set cursorline
set modelines=0
set clipboard=unnamed
set synmaxcol=128
set ttyscroll=10
set encoding=utf-8
set nowrap
set number
set expandtab
set nowritebackup
set noswapfile
set nobackup
set ignorecase
set smartcase
set nohlsearch
set relativenumber
 
colorscheme github 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab
 
" Be smart when using tabs ;)
set smarttab
 
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
 
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']
 
" Syntastic
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_ruby_exec = '~/.rvm/rubies/ruby-2.0.0-p0/bin/ruby'
 
" CtrlP
nnoremap <silent> t :CtrlP<cr>
let g:ctrlp_working_path_mode = 2
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 600
let g:ctrlp_max_depth = 5

" Open new buffers
nmap <leader>s<left>   :leftabove  vnew<cr>
nmap <leader>s<right>  :rightbelow vnew<cr>
nmap <leader>s<up>     :leftabove  new<cr>
nmap <leader>s<down>   :rightbelow new<cr>

" Tab between buffers
noremap <tab> <c-w><c-w>


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
"

