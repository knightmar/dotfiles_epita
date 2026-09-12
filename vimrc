" ~/.vimrc

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" https://github.com/tpope/vim-sensible
Plugin 'tpope/vim-sensible'
Plugin 'sheerun/vim-polyglot'
Plugin 'joshdick/onedark.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'preservim/nerdtree'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on


syntax on
colorscheme onedark

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

let NERDTreeQuitOnOpen=1


nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
nnoremap <C-j> gT
nnoremap <C-k> gt
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
nnoremap <C-p> :below term ++rows=15<CR>
nnoremap <C-f> :w <bar> :!clang-format -i ./%<CR><CR>

autocmd VimEnter * :wincmd T


set mouse=a
set nu 
set cc=80
set ruler
set ts=4 
set smartindent

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"


runtime! plugin/sensible.vim

set encoding=utf-8 fileencodings=
syntax on

autocmd Filetype make setlocal noexpandtab

set list listchars=tab:»·,trail:·


" per .git vim configs
" just `git config vim.settings "expandtab sw=4 sts=4"` in a git repository
" change syntax settings for this repository
let git_settings = system("git config --get vim.settings")
if strlen(git_settings)
	exe "set" git_settings
endif



:command Main put!='#include <stdio.h>' | put='int main(void) {' | put='    printf(\"%ld\n\", factorial(5)); ' | put='}'
