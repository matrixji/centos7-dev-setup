#!/bin/sh

set -e

cat > /etc/yum.repos.d/vim8.repo <<EOF
[mcepl-vim8]
name=Copr repo for vim8 owned by mcepl
baseurl=https://copr-be.cloud.fedoraproject.org/results/mcepl/vim8/epel-7-\$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/mcepl/vim8/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1

EOF

yum -y update vim-minimal vim
yum -y install vim


if [ -d ~/.vim/bundle/Vundle.vim ] ; then
    cd ~/.vim/bundle/Vundle.vim && git pull
    cd -
else
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

mkdir -p ~/.vim/colors
wget https://github.com/altercation/solarized/raw/master/vim-colors-solarized/colors/solarized.vim -O ~/.vim/colors/solarized.vim
## wget https://github.com/tomasr/molokai/raw/master/colors/molokai.vim -O ~/.vim/colors/molokai.vim

cat > ~/.vimrc <<EOF

" Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'L9'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'Valloric/MatchTagAlways'
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'docunext/closetag.vim'
Plugin 'godlygeek/tabular'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/a.vim'
Plugin 'vim-scripts/txt.vim'
Plugin 'will133/vim-dirdiff'
Plugin 'haya14busa/incsearch.vim'
Plugin 'mhinz/vim-startify'

Plugin 'uguu-org/vim-matrix-screensaver'

call vundle#end()
filetype plugin indent on

runtime macros/matchit.vim

" colorscheme
set background=dark

" let g:solarized_termcolors=256
colorscheme solarized


" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("\$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <F3> :NERDTreeToggle<CR>
imap <F3> <ESC><F3>

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDAltDelims_java = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1"


" YCM
let g:ycm_confirm_extra_conf = 0
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
let g:ycm_seed_identifiers_with_syntax = 1 
let g:ycm_complete_in_comments = 1 
let g:ycm_complete_in_strings = 1 
"let g:ycm_cache_omnifunc = 0 
"let mapleader = ","
map <c-F12> :YcmCompleter GoToDeclaration<CR>
imap <c-F12> <esc><c-F12>

map <F12> :YcmCompleter GoToDefinition<CR>
imap <F12> <esc><F12>

map <leader>o :YcmCompleter GoToInclude<CR>

map <c-b> :YcmDiags<CR>
imap <c-b> <esc><c-b>

" ctags
set tags+=/usr/include/tags
" set tags+=~/.vim/systags
" set tags+=~/.vim/x86_64-linux-gnu-systags
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_semantic_triggers = {} 
let g:ycm_semantic_triggers.c = ['->', '.', ' ', '(', '[', '&',']']

" a.vim: .h -> .cpp or .cpp -> .h
nnoremap <silent> <F2> :A<CR>


" tagbar
let g:tagbar_ctags_bin = '/usr/bin/ctags'
let g:tagbar_width = 30
map <F4> :TagbarToggle<CR>
imap <F4> <ESC> <F4>

" cpp_class_scope_highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
let c_no_curly_error = 1


" airline
let g:airline_theme="solarized"
let g:airline_powerline_fonts = 1
"let g:airline_section_b = '%{strftime("%c")}'
"let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>



" ctrlp
let g:ctrlp_map = '<c-f>'
let g:ctrlp_cmd = ':CtrlP'
let g:ctrlp_working_path_mode = '0'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip


" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


"
set expandtab
set autoindent
set smartindent
set cindent
set cinoptions=g0,:0,N-s,(0)
set tabstop=4
set softtabstop=4
set shiftwidth=4
set number
set nobackup
set hlsearch
set incsearch
set iskeyword+=.

set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

filetype on
filetype plugin on
filetype indent on

EOF


vim +BundleInstall +qall
yum -y install python-devel cmake
cd .vim/bundle/YouCompleteMe/ && ./install.py --clang-completer
cd -
vim +BundleInstall +qall

echo done

