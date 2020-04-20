" General settings {{{
" ---------------------------------------------------------------------
"  search options
set hlsearch                    "highlight matches
set ignorecase                  "ignore case
set incsearch                   "show next match while typing
set smartcase                   "be clever about cases
nohlsearch                      "turn off highlight incase we're resourcing

"  automagic options
set autoread
set autoindent
set copyindent                  "copy indent struct when indenting a new line
set backspace=indent,eol,start  "backspace over everything
set formatoptions-=o            "don't continue comments when hitting o/O


"  display options
set colorcolumn=+1              "mark ideal max text width
set cursorline
set ruler
set showcmd                     "show incomplete commands
set showmatch                   "highlight matching braces
set showmode                    "show current mode

"  window options
set splitbelow                  "open splits below
set splitright                  "open splits to the right

"  tab options
set expandtab
set shiftwidth=4
set smarttab
set softtabstop=-1

"  other options
set hidden                      "hide buffers instead of closing them
set wildmenu                    "tab completion of ex commands
set formatoptions+=j            "remove comment leader when joining lines
set nojoinspaces                "don't insert two spaces after [.?!] on join
set shiftround                  "on '<' and '>' round indent to shiftwidth

"use ripgrep if available
if executable("rg")
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif
" }}}
" Commands {{{
"----------------------------------------------------------------------
command! DiffOrig vert new | set bt=nofile | 0r ++edit #
            \ | diffthis | wincmd p | diffthis
" }}}
" Modeline {{{
" ---------------------------------------------------------------------
"  We're trusting the modelineexpr feature to keep us safe...
if exists('+modelineexpr')
    set modeline
    set nomodelineexpr
else
    set nomodeline
end
" }}}
" Filetype settings {{{
" --------------------------------------------------------------------
filetype plugin indent on       "load ftplugins and indent files
syntax enable                   "turn on syntax highlighting

let g:tex_flavor = "latex"
" }}}
" List mode and showbreak {{{
" ---------------------------------------------------------------------
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
let &showbreak = "  > "
if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    let &listchars = "tab:⇥ ,trail:␣,extends:⇉,precedes:⇇,nbsp:·"
    let &showbreak = "↳ "
endif
set breakindent
set breakindentopt=shift:4
" }}}
" Folding settings {{{
" ---------------------------------------------------------------------
if (&foldmethod == 'manual')    "prevent messing up foldmethod when resourcing
    set foldmethod=indent       "fold based on indent
endif
set foldnestmax=3               "deepest fold is 3 levels
set nofoldenable                "don't fold by default
augroup filetype_vim
    autocmd!
    autocmd Filetype vim setlocal foldmethod=marker
augroup END
set fillchars=fold:\ 
set fillchars+=vert:┃
" }}}
" Colour schemes {{{
" ---------------------------------------------------------------------
if has('nvim') || (has('termguicolors') &&
            \ ($COLORTERM == 'truecolor' || $COLORTERM == '24bit'))
    set termguicolors
endif

"  nord colour scheme
let g:nord_cursor_line_number_background = 1
let g:nord_italic = 1
let g:nord_underline = 1
let g:nord_uniform_diff_background = 1

" Nord Colours {{{
" ---------------------------------------------------------------------
let g:nord_colour = [
    \ "#2E3440",
    \ "#3B4252",
    \ "#434C5E",
    \ "#4C566A",
    \ "#D8DEE9",
    \ "#E5E9F0",
    \ "#ECEFF4",
    \ "#8FBCBB",
    \ "#88C0D0",
    \ "#81A1C1",
    \ "#5E81AC",
    \ "#BF616A",
    \ "#D08770",
    \ "#EBCB8B",
    \ "#A3BE8C",
    \ "#B48EAD",
\ ]

let g:nord3_brightened = [
    \ g:nord_colour[3],
    \ "#4e586d",
    \ "#505b70",
    \ "#525d73",
    \ "#556076",
    \ "#576279",
    \ "#59647c",
    \ "#5b677f",
    \ "#5d6982",
    \ "#5f6c85",
    \ "#616e88",
    \ "#63718b",
    \ "#66738e",
    \ "#687591",
    \ "#6a7894",
    \ "#6d7a96",
    \ "#6f7d98",
    \ "#72809a",
    \ "#75829c",
    \ "#78859e",
    \ "#7b88a1",
\ ]
" }}}

augroup nord-theme-overrides
    autocmd!
    execute 'autocmd ColorScheme nord highlight Comment guifg=' . g:nord3_brightened[15]
    execute 'autocmd ColorScheme nord highlight NonText guifg=' . g:nord3_brightened[5]
    execute 'autocmd ColorScheme nord highlight LineNr guifg=' . g:nord3_brightened[15]
    execute 'autocmd ColorScheme nord highlight Folded guifg=' . g:nord3_brightened[15]
    execute 'autocmd ColorScheme nord highlight EndOfBuffer guifg=' . g:nord3_brightened[15]
    execute 'autocmd ColorScheme nord highlight IncSearch guibg=' . g:nord_colour[15] . ' guifg=' . g:nord_colour[0]
augroup END
colorscheme nord
" }}}
" Mappings {{{
" --------------------------------------------------------------------
let mapleader = " "

"  map 'kj' to <Esc> for exiting insert mode
inoremap kj <Esc>
if has('nvim')
  tnoremap kj <C-\><C-n>
endif

"  map <F2><F2> to toggle between relative and absolute lin numbering
"  and <F2> to toggle line numbering on and off
nnoremap <silent> <F2><F2> :set invrelativenumber<CR>
nnoremap <silent> <F2> :set invnumber<CR>:set invrelativenumber<CR>

"  map <F3> to write and run make
nnoremap <F3> :if &modified \|:w \|:endif \|:make<CR>

"  easy editing and sourcing of vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"  uppercase current WORD and continue inserting
inoremap <c-j> <esc>gUiWEa

"  tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>
" }}}
" Status line {{{
" --------------------------------------------------------------------
"  set statusline=%#identifier#
set statusline=%f               "40 character filename
set statusline+=%*

set statusline+=\ %#warningmsg#
"  warning if fileformat isn't unix
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
"  warning if file encoding isn't utf-8
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h              "help file flag
set statusline+=%y              "filetype

"  set statusline+=%#identifier#
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
set laststatus=2
" }}}
" Tagbar {{{
" --------------------------------------------------------------------
let g:tagbar_left = 1
let g:tagbar_autoclose = 1
if executable('universal-ctags')
    let g:tagbar_ctags_bin = 'universal-ctags'
endif
" }}}
" Templ & Tagger {{{
" --------------------------------------------------------------------
let g:Tagger_exprs = {
            \ 'DATE' : 'strftime("%d %b %Y")',
            \ }
" }}}
" OCaml {{{
" --------------------------------------------------------------------
if executable('opam')
    " this will not work if opam config is changed while vim is running...
    let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
    execute "set rtp^=" . g:opamshare . "/ocp-indent/vim"
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif
" }}}
