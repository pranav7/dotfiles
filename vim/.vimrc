call plug#begin('~/.local/share/nvim/plugged')

" Ruby on Rails/Ruby Plug 'vim-ruby/vim-ruby'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'

" Tmux Integration
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'

" Javascript
Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'joukevandermaas/vim-ember-hbs'

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-endwise'
Plug 'Yggdroot/indentLine'
Plug 'Raimondi/delimitMate'
Plug 'slim-template/vim-slim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'othree/html5.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'

Plug 'thoughtbot/vim-rspec'
Plug 'jgdavey/tslime.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'rainglow/vim'

call plug#end()

syntax on
color dracula

hi Normal guibg=NONE ctermbg=NONE

let mapleader=" "

set nofoldenable

set relativenumber
set sw=2
set ts=2
set sts=2
set expandtab
set autoread
set wrap
set mouse=a
set conceallevel=0
set t_Co=256
set nu rnu

set nofoldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
" space open/closes folds
nnoremap <C-f> za

" Suspend the session
nnoremap bg :sus<CR>

" Escaping
inoremap jj <ESC>

" Tabs
noremap <C-t> :tabnew<cr>
noremap <C-]> gt
noremap <C-[> gT
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" Buffers
nnoremap bn :bnext<cr>
nnoremap bp :bprevious<cr>

" Copying
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" Splits
set splitbelow
set splitright
nmap <leader>s\ :leftabove vnew<cr>
nmap <leader>s- :rightbelow new<cr>

nmap <leader>s<left>   :leftabove  vnew<cr>
nmap <leader>s<right>  :rightbelow vnew<cr>
nmap <leader>s<up>     :leftabove  new<cr>
nmap <leader>s<down>   :rightbelow new<cr>

" Navigate Splits
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

" Source vimrc
noremap <leader>vr :source ~/.vimrc<CR>

" Tmux Runners
nnoremap <leader>v- :VtrOpenRunner { "orientation": "v" }<cr>
nnoremap <leader>v\ :VtrOpenRunner { "orientation": "h" }<cr>
nnoremap <leader>vk :VtrKillRunner<cr>
nnoremap <leader>va :VtrAttachToPane<cr>
nnoremap <leader>vf :VtrFocusRunner<cr>
nnoremap <leader>vsc :VtrSendCommandToRunner<space>
nnoremap <leader>vsl :VtrSendLinesToRunner<cr>
nnoremap <leader>sd :VtrSendCtrlD<cr>

" RSpec.vim mappings
let g:rspec_command = "call VtrSendCommand('bundle exec rspec {spec}')"
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" ctrl+c to toggle highlight.
let hlstate=0
nnoremap <c-c> :if (hlstate%2 == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<cr>

map <Leader>pdb oimport pdb; pdb.set_trace()<esc>:w<cr>
map <Leader>pry obinding.pry<esc>:w<cr>
map <Leader>log oconsole.log('');<left><left><left>

" fzf.vim
nnoremap <silent> t :FZF<cr>
nnoremap <silent> f :Ag<cr>

" NERDTree
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>f :NERDTreeFind<CR>
" let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg', '\.pyc$', '\~$']
" NERCCommenter
let g:NERDSpaceDelims = 2

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

autocmd FileType scss setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType html.handlebars setlocal ts=2 sw=2 sts=2 expandtab

" Ale Config
" Ref: https://www.notion.so/intercomrades/Editor-Setup-a77ca090fe48495c9bf82714963252c8
let g:ale_linters = { 'javascript': ['eslint'] }
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}

" Format on Save
let g:ale_fix_on_save = 1
" Respect local Prettier config files
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '=>'
