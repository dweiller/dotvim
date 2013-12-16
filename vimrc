execute pathogen#infect()
syntax on

if has('autocmd')
  filetype plugin indent on
endif

"searching options
set incsearch
set ignorecase
set smartcase

set showmatch
set backspace=indent,eol,start
set showcmd
set ruler
set wildmenu
set autoread
set list
set autoindent

"molokai colour scheme
:colorscheme molokai
let g:rehash256 = 1
set background=dark

"map 'kj' to <Esc> for exiting insert mode
:inoremap kj <Esc>

"nicer 'set list' formatting
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
  endif
endif
