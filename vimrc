" General settings {{{
" ---------------------------------------------------------------------
"searching
set hlsearch                    "highlight matches
set ignorecase                  "ignore case
set incsearch                   "show next match while typing
set smartcase                   "be clever about cases
nohlsearch                      "turn off highlight incase we're resourcing

"automagic options
set autoread
set autoindent
set backspace=indent,eol,start  "backspace over everything
set formatoptions-=o            "don't continue comments when hitting o/O

"display options
set colorcolumn=+1              "mark ideal max text width
set cursorline
set ruler
set showcmd                     "show incomplete commands
set showmatch                   "highlight matching braces
set showmode                    "show current mode

"window options
set splitbelow                  "open splits below
set splitright                  "open splits to the right

"tab behaviour
set expandtab
set shiftwidth=4
set smarttab
set softtabstop=-1

"other
set hidden                      "hide buffers instead of closing them
set wildmenu                    "tab completion of ex commands
" }}}
" Filetype settings {{{
" --------------------------------------------------------------------
if has('autocmd')
    filetype plugin indent on   "load ftplugins and indent files
endif
syntax enable                   "turn on syntax highlighting

let g:tex_flavor = "latex"
" }}}
" List mode {{{
" ---------------------------------------------------------------------
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
let &showbreak = "  > "
if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    let &listchars = "tab:⇥ ,trail:␣,extends:⇉,precedes:⇇,nbsp:·"
    let &showbreak = "  ↳ "
endif
" }}}
" Folding settings {{{
" ---------------------------------------------------------------------
set foldmethod=indent           "fold based on indent
set foldnestmax=3               "deepest fold is 3 levels
set nofoldenable                "don't fold by default
if has('autocmd')
    augroup filetype_vim
        autocmd!
        autocmd Filetype vim setlocal foldmethod=marker
    augroup END
endif
" }}}
" Colour schemes {{{
" ---------------------------------------------------------------------
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
elseif $COLORTERM == 'truecolor' || $COLORTERM == '24bit'
    set termguicolors
endif

set background=dark

"solarized colour scheme
let g:solarized_termcolors=256

"nord colour scheme
let g:nord_cursor_line_number_background = 1
let g:nord_italic = 1
let g:nord_underline = 1
augroup nord-theme-overrides
    autocmd!
    autocmd ColorScheme nord highlight Comment guifg=#6d7a96
    autocmd ColorScheme nord highlight NonText guifg=#6d7a96
    autocmd ColorScheme nord highlight LineNr guifg=#6d7a96
augroup END
colorscheme nord
" }}}
" Mappings {{{
" --------------------------------------------------------------------
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

"tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>
" }}}
" Status line {{{
" --------------------------------------------------------------------
"set statusline=%#identifier#
set statusline=%f               "40 character filename
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
" }}}
" Tagbar {{{
" --------------------------------------------------------------------
let g:tagbar_left = 1
let g:tagbar_autoclose = 1
" }}}
" OCaml {{{
" --------------------------------------------------------------------
let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
if v:shell_error
    unlet g:opamshare
else
    execute "set rtp^=" . g:opamshare . "/ocp-indent/vim"
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif
" }}}

