execute pathogen#infect()

" set nocompatible
syntax enable               " enable syntax processing

set bg=dark
colorscheme hybrid_reverse  " Set colorscheme

set ttyfast                 " faster redraw

set backspace=indent,eol,start
set whichwrap+=<,>,h,l

set lazyredraw              " Don't redraw while executing macros (good performance config)

"""""""""""""""""""""""
" => Spaces and Tabs
"""""""""""""""""""""""
set tabstop=4               " number of visual spaces per TAB
set expandtab               " tabs are spaces
set smarttab
set softtabstop=4           " number of spaces in tab when editing
set shiftwidth=4

set modelines=1

filetype indent on          " load filetype-specific indent files
filetype plugin on

set autoindent
set number                  " show line numbers
set showcmd                 " show command in bottom bar
set nocursorline            " highlight current line
set wildmenu                " deals with autocomplete on the command line. See ':help wildmenu'
set showmatch               " higlight matching parenthesis
set ignorecase              " ignore case when searching
set incsearch               " search as characters are entered
set hlsearch                " highlight all matches
set foldmethod=indent       " fold based on indent level
set foldnestmax=10          " max 10 depth
set foldenable
set foldlevelstart=10       " open most folds by default
set list                    " show whitespace

""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set encoding=utf8           " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac        " Use Unix as the standard file type

""""""""""""""""""""""""""""""
" => Key Bindings
""""""""""""""""""""""""""""""
inoremap jk <esc>

let mapleader=","
let g:mapleader = ","

nnoremap <leader>nn :NERDTree<CR>
nmap <leader>w :w!<cr>      " fast saving

""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart way to move between windows
map <space>j <C-W>j
map <space>k <C-W>k
map <space>h <C-W>h
map <space>l <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

map <Tab> :bnext<cr>
map <S-Tab> :bprevious<cr>

" Specify the behavior when switching between buffers 
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/tmp/undodir
    set undofile
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md,*.rb :call <SID>StripTrailingWhitespaces()
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper Functions
""""""""""""""""""""""""""""""""""""""""""""""""
" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

function! <SID>CleanFile()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %!git stripspace
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

try
    source ~/.vim/vimrcs/plugins_config.vim
catch
endtry

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete!".l:currentBufNum)
    endif
endfunction
