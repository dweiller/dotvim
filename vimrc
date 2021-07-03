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
set number                      "show line numbers
set relativenumber              "show relative line numbers

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
command! BClose if bufname('#') != '' | b # | bd # | endif
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
" Spelling {{{
" --------------------------------------------------------------------
set spelllang=en_au,en_gb
let g:spellfile_basic = 'general'
if has('nvim')
    let g:custom_spellfile_path = stdpath('config') . '/spell/'
else
    let g:custom_spellfile_path = '~/.vim/spell/'
endif

function! CustomSpell_File(name, ...)
    let path = fnamemodify(a:0 ? a:1 : g:custom_spellfile_path, ':p')
    return g:custom_spellfile_path . a:name . '.' . &encoding . '.add'
endfunction

function! CustomSpell_Files(...)
    let path = fnamemodify(a:0 ? a:1 : g:custom_spellfile_path, ':p')
    return globpath(path, '*.add*', '', 1)
endfunction

function! CustomSpell_Complete(arglead, cmdline, cpos)
    let files = CustomSpell_Files()
    call map(files, 'fnamemodify(v:val , ":p:t:r:r")')
    return files
endfunction

function! CustomSpell_RemoveFiles(...)
    if ! a:0
        return
    endif
    for name in a:000
        execute 'set spellfile-=' . CustomSpell_File(name)
    endif
endfunction

execute 'set spellfile=' . CustomSpell_File(g:spellfile_basic)

command! -nargs=? -complete=customlist,CustomSpell_Complete UseSpellFile execute 'set spellfile-=' . CustomSpell_File(<f-args>) . '| set spellfile^=' . CustomSpell_File(<f-args>)
command! -nargs=+ -complete=customlist,CustomSpell_Complete RemoveSpellFile execute 'set spellfile-=' . CustomSpell_File(<f-args>)
" }}}
" Filetype settings {{{
" --------------------------------------------------------------------
filetype plugin indent on       "load ftplugins and indent files
syntax enable                   "turn on syntax highlighting

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
    execute 'autocmd ColorScheme nord highlight StatusLine guibg=' . g:nord_colour[2] . ' guifg=' . g:nord_colour[4]
    execute 'autocmd ColorScheme nord highlight StatusLineNC guibg=' . g:nord_colour[2] . ' guifg=' . g:nord3_brightened[15]
    execute 'autocmd ColorScheme nord highlight User1 guibg=' . g:nord_colour[2] . ' guifg=' . g:nord_colour[7] . ' gui=bold'
    execute 'autocmd ColorScheme nord highlight User2 guibg=' . g:nord_colour[2] . ' guifg=' . g:nord_colour[12] . ' gui=bold'
    execute 'autocmd ColorScheme nord highlight User3 guibg=' . g:nord_colour[2] . ' guifg=' . g:nord_colour[7]
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

"  nohlsearch on <CR> if currently highlighting search
if has('nvim')
    nnoremap <expr> <silent> <CR> {-> v:hlsearch ? ":nohlsearch<CR>:lua require('hlnext').HLNextOff()<CR>" : "<CR>"}()
else
    nnoremap <expr> <silent> <CR> {-> v:hlsearch ? ":nohlsearch<CR>" : "<CR>"}()
endif

nnoremap <leader>h :lnext<CR>
nnoremap <leader>l :lprevious<CR>
nnoremap <leader>j :cnext<CR>
nnoremap <leader>k :cprevious<CR>
" }}}
" Status line {{{
" --------------------------------------------------------------------

highlight default link User1 StatusLine
highlight default link User2 StatusLine
highlight default link User3 StatusLine

function! StatusColour(active, num, item)
    if a:active
        return '%' . a:num . '*' . a:item . '%*'
    else
        return a:item
    endif
endfunction

function! StatusGitInfo()
    " adapted from __git_ps1
    let repo_info = systemlist('git rev-parse --git-dir --is-inside-work-tree --short HEAD 2>/dev/null')
    if ! len(repo_info)
        return ''
    endif

    let gitdir = repo_info[0]
    let inside_worktree = repo_info[1] ==# 'true' ? 1 : 0
    let short_sha = get(repo_info, 2)

    let head_file = gitdir . '/HEAD'

    if ! filereadable(head_file)
        return ''
    endif

    let branch = trim(system('git symbolic-ref HEAD 2>/dev/null'))
    " if not a symbolic ref 'ref: ...'
    if v:shell_error
        let branch = trim(system('git describe --tags --exact-match HEAD 2>/dev/null'))
        " if detached
        if v:shell_error
            let branch = '(' . short_sha . '...)'
        endif
    endif

    " strip off the refs/heads/ prefix if it's there
    let branch = matchstr(branch, 'refs/heads/\zs.*\|.*')
    return '(' . branch . ')'
endfunction

function! LinterStatus(bufnr)
    let l:counts = ale#statusline#Count(a:bufnr)

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf('%dW %dE', all_non_errors, all_errors)
endfunction

function! StatusLine(winnr)
    let status = ''
    let active = winnr() == a:winnr
    let bufnr = winbufnr(a:winnr)

    " show column number aligned with numbercolumn
    let numberwidth = getwinvar(a:winnr, '&numberwidth')
    let status .= '%' . (numberwidth - 1) . 'v'

    " file name surrounded by » «
    let status .= StatusColour(active, 1, ' »')
    let status .= ' %<'
    let status .= '%f'
    let status .= StatusColour(active, 1, ' «')

    " show '-' if not modifiable, '!' if readonly and '+' if modified (with
    " that precedence)
    let status .= StatusColour(active, 2,
      \ "%{&modifiable ? (&readonly ? ' !' : (&modified ? ' +' : '')) : ' -'}")

    " in vim show if paste is set on active buffer's statusline
    if !has('nvim') && active && &paste
        let status .= ' %2*P%*'
    endif

    let status .= "%{(&fenc != 'utf-8' && &fenc != '') ? '[' . &fenc . ']' : '' }"

    let status .= '%='
    let status .= '%#WarningMsg#%{LinterStatus(' . bufnr . ')}%*'

    let status .= '%='

    let status .= StatusColour(active, 3, '%{StatusGitInfo()} ')
    let status .= "%<%{fnamemodify(getcwd(), ':~')}"

    return status
endfunction

function! RefreshStatus()
    for nr in range(1, winnr('$'))
        call setwinvar(nr, '&statusline', '%!StatusLine(' . nr . ')')
    endfor
endfunction

augroup status
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call RefreshStatus()
augroup END

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
" vim-snipmate {{{
let g:snipMate = {}
let g:snipMate.snippet_version = 1
" }}}
" vim-sandwich {{{
" --------------------------------------------------------------------
"  use vim-surround style keymap instead of the default
runtime START macros/sandwich/keymap/surround.vim
" }}}
