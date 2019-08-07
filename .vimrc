let mapleader='\'

noremap <Leader>ev :vsplit $MYVIMRC<CR>
noremap <Leader>sv :source $MYVIMRC<CR>
inoremap jk <ESC>

" {{{ plugin

" filetype off

call plug#begin("~/.vim/plugged")

Plug 'mhinz/vim-startify' " welcome :)
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp'] }

Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle']  }
Plug 'scrooloose/nerdcommenter'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'

Plug 'mileszs/ack.vim', { 'on': ['Ack'] }

" Plug 'altercation/vim-colors-solarized'
" Plug 'Lokaltog/vim-powerline'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'jiangmiao/auto-pairs'
" Plug 'tpope/vim-surround'

Plug 'Valloric/YouCompleteMe'
" Plug 'w0rp/ale'

Plug 'majutsushi/tagbar'
Plug 'rhysd/vim-clang-format', { 'on': ['ClangFormat'], 'for': ['cpp', 'c'] }

Plug 'airblade/vim-gitgutter', { 'on': ['GitGutterToggle'] }
Plug 'derekwyatt/vim-fswitch', {'for': ['cpp', 'c']}

call plug#end()

" filetype plugin indent on
" " }}}


" {{{ basic

set nocompatible

" search
set incsearch
set hlsearch
set ignorecase

" indent and tab
set showmode
set tw=80

set smartcase
set smarttab

set smartindent
set autoindent

set softtabstop=4
set shiftwidth=4
set expandtab

set mouse=n

set history=1000
set number
" }}}


"  {{{ appearance

if has('gui_running')
    set background=dark
    colorscheme solarized
    set cursorline
    set lines=35
    set columns=118

    if has('gui_win32')
        set guifont=Consolas:h12
    else 
        set guifont=Consolas\ 12
    endif

endif

set gcr=v-c-n:block-blinkon0

" disable scroll bar
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" disable menu and tool-bar
set guioptions-=m
set guioptions-=T

set laststatus=2
set ruler

set nowrap

let g:NERDSpaceDelims=1
" let g:Powerline_colorscheme='solarized256'

syntax enable
syntax on

set foldmethod=indent
set nofoldenable

" close bell
set noeb vb t_vb=
au GUIEnter * set vb t_vb=

set wildmenu
set wildmode=longest:full,full

set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  
"  }}}

" {{{ ctags and tagbar
set tags=tags;

let g:tagbar_left = 1
noremap <leader>tb :TagbarToggle<CR>

" }}}


" {{{ complete (ycm)
set completeopt=longest,menuone
set pumheight=10

let g:ycm_global_ycm_extra_conf = '~/vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_complete_in_strings = 1

let g:ycm_key_invoke_completion = '<C-x><C-o>'

nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <F4> :YcmDiags<CR>


" }}} 

" {{{ ctrlp

let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch'}

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]((\.(git|hg|svn))|CMakeFiles)$',
  \ 'file': '\v\.(exe|so|dll|o|d)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" }}}

" {{{ Ack.vim 
if executable('ag')
  let g:ackprg = 'ag'
endif
" }}} 

" {{{ other

" buffer jump
nnoremap <leader>[ :bprevious<CR>
nnoremap <leader>] :bnext<CR>

noremap <Leader><Space> :NERDTreeToggle<CR>
noremap <F11> :call ToggleFullscreen()<CR>

noremap <Leader>w :w<CR>
inoremap <Leader>w <C-O>:w<CR>
noremap <Leader>tg :!ctags -R && echo "create tags OK"<CR> 

inoremap <C-e> <C-h>
inoremap <C-d> <C-O>dd
inoremap <Leader>z  <C-O>zz

inoremap <C-h> <Home>
inoremap <C-j> <End><CR>
inoremap <C-k> <ESC><S-o>
inoremap <C-l> <End>

" over 80
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

"  }}}

" my autocmd group
augroup MyAuc 
    autocmd!
    autocmd VimEnter * call VimInit()

    autocmd BufNewFile *.sh 
                \ call append(0, ['#!/bin/bash'])
    autocmd BufNewFile *.py
                \ call append(0, ['#!/bin/python'])
    autocmd BufNewFile *.{h,hpp,hxx} 
                \ call <SID>insertHeader()
augroup END

func! VimInit() 
    call ToggleFullscreen()
endf

func! ToggleFullscreen()
    if has('gui_running')
        if has('gui_win32')
            call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
        else
            call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")
        endif
    endif
endf

func! s:insertHeader()
    let name = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
    execute "normal! i#ifndef " . name
    execute "normal! o#define " . name . " "
    execute "normal! Go#endif /* "  . name . " */"
    normal! O
endf

" format
let g:clang_format#code_style="google"
nnoremap <F5> :ClangFormat<CR>

" git
let g:gitgutter_enabled = 0
nnoremap <F6> :GitGutterToggle<CR>

" *.h <--> *.cpp FSwitch
com! A :call FSwitch('%', '')
com! AA :call FSwitch('%', 'let curspr=&spr | set nospr | vsplit | if curspr | set spr | endif') 
cabbrev a A

" let g:ale_linters = { }

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_error_symbol = '>>'
let g:syntastic_warning_symbol = "^^"
let g:syntastic_enable_highlighting = 0

let g:airline#extensions#tagbar#enabled = 1
