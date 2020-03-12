execute pathogen#infect()

if has('autocmd')
  filetype plugin indent on   "load ftplugins and indent files
endif

syntax on   "turn on syntax highlighting

"searching options
set incsearch   "show next match while typing
set hlsearch    "highlight matches
set ignorecase  "ignore case
set smartcase   "be clever about cases
nohlsearch      "turn off highlight incase we're resourcing

"general stuff
set showmatch                   "highlight matching braces
set backspace=indent,eol,start  "backspace over everything
set showmode                    "show current mode
set showcmd                     "show incomplete commands
set ruler
set wildmenu                    "tab completion of ex commands
set autoread
set smarttab
set autoindent
set hidden                      "hide buffers instead of closing them
set colorcolumn=+1              "mark ideal max text width
set cursorline
set formatoptions-=o            "don't continue comments when hitting o/O
set splitright                  "open splits to the right
set splitbelow                  "open splits below

let g:tex_flavor = "latex"

"show tabs, trailing spaces etc.
set list
"nicer 'set list' formatting
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
let &showbreak = "  > "
if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
  let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
  let &showbreak = "  ↳ "
endif

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set expandtab
set shiftwidth=4
set softtabstop=4

"set up colour scheme
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

"molokai colour scheme
"set background=dark
"let g:rehash256 = 1
"colorscheme molokai

"solarized colour scheme
set background=dark
let g:solarized_termcolors=256
"let g:solarized_termtrans=1
colorscheme solarized

let mapleader = " "

"map 'kj' to <Esc> for exiting insert mode
inoremap kj <Esc>
if has('nvim')
  tnoremap kj <C-\><C-n>
endif

"map <F2><F2> to toggle between relative and absolute lin numbering
"and <F2> to toggle line numbering on and off
nnoremap <silent> <F2><F2> :set invrelativenumber<CR>
nnoremap <silent> <F2> :set invnumber<CR>:set invrelativenumber<CR>

"map <F3> to write and run make
nnoremap <F3> :w<CR>\|:!make<CR>

"easy editing and sourcing of vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"uppercase current WORD and continue inserting
inoremap <c-j> <esc>gUiWEa

"statusline setup
"set statusline=%#identifier#
set statusline=%f           "40 character filename
set statusline+=%*

set statusline+=\ %#warningmsg#
"warning if fileformat isn't unix
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
"warning if file encoding isn't utf-8
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h              "help file flag
set statusline+=%y              "filetype

"set statusline+=%#identifier#
set statusline+=%r              "readonly flag
set statusline+=%m              "modified flag
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set statusline+=%=              "left/right separator
set statusline+=%c,             "cursor column
set statusline+=%l/%L           "cursor line/total lines
set statusline+=\ %P            "percent through file
set laststatus=1

"tagbar stuff
nnoremap <silent> <F9> :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_autoclose = 1

"ocaml editiing
let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
if v:shell_error
    unlet g:opamshare
else
    execute "set rtp^=" . g:opamshare . "/ocp-indent/vim"
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif
