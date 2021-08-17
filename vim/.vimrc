"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible                " disable Vi compatibility
set t_Co=256                    " enable 256-color mode
set termguicolors
set background=dark
set nobackup                    " disable automatic backups
set nowritebackup               " write directly to the original file
set clipboard=unnamed           " enable copy & paster to MAC clipboard
set backspace=indent,eol,start  " enable backspacing over everything in insert mode
set history=50                  " keep 50 lines of command line history
set numberwidth=4               " set the number gutter width
set number                      " show line number
set cul                         " highlight the current line
set nohlsearch                  " don't continue to highlight searched phrases
set incsearch                   " do highlight as search is being typed
set ignorecase                  " make searches case-insensitive
set showmatch                   " highlight the matching brace
set visualbell                  " use the visual indicator instead of a sound
set ruler                       " show info along bottom
set showcmd                     " display incomplete commands
set relativenumber              " turn hybrid line numbers on
set softtabstop=4               " insert/delete x spaces on TAB/BACKSPACE
set shiftwidth=4                " << and >> moves row x columns
set tabstop=4                   " a hard TAB displays as x columns
set shiftround                  " round indent to multiple of 'shiftwidth'
set smartindent                 " automatically inserts extra level of indentation
set expandtab                   " insert spaces when hitting TABs
set autoindent                  " auto indent new lines
set nowrap                      " stop wrapping by default
set splitbelow                  " preview window to appear at bottom
set noshowmode                  " don't display mode in command line (airline already shows it)
set winbl=10                    " set floating window to be slightly transparent

" enable the mouse if available
if has('mouse')
  set mouse=a
endif

" remap heavily used keys
let mapleader="\\"
imap jj <ESC>

" Map VIM movements with split switching.
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

noremap 1 <PageUp>
noremap 2 <PageDown>
noremap 9 <Home>
noremap 0 <End>

syntax enable               " enable syntax highlighting


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Python Specific
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <buffer> <F5> :exec '!venv/bin/python' shellescape(@%, 1)<cr>
autocmd bufreadpre *.py setlocal textwidth=79
"autocmd BufWritePost *.py call Pyflakes()
"autocmd BufWritePost *.py call Pep8()

" highlight the wraparound column
if exists('+colorcolumn')
  autocmd bufreadpre *.py set colorcolumn=79
  autocmd bufreadpre *.py highlight ColorColumn ctermbg=234
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim). Also don't do it when the mark is in
" the first line, that is the default position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" set the syntax highlighting for the various extensions
au BufNewFile,BufRead *.gradle setf groovy


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Automatically install plug, if needed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'arcticicestudio/nord-vim'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'scrooloose/nerdcommenter'

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ntpeters/vim-better-whitespace'
Plug 'rstacruz/vim-closer'

"Plug 'neoclide/coc.nvim', {'branch': 'release'}
""CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css coc-angular coc-highlight coc-html coc-java coc-python
"
"Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
"
"Plug 'Shougo/echodoc.vim'
"
"Plug 'HerringtonDarkholme/yats.vim'
"
call plug#end()


" VIM-COLORSCHEMES """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme molokai
" colorscheme busybee
" colorscheme iceberg
" colorscheme impact
" colorscheme obsidian
" colorscheme sorcerer
 colorscheme twilight256
" colorscheme distinguished
" colorscheme nord

" Make background transparent for many things
hi Normal ctermbg=NONE guibg=NONE
hi NonText ctermbg=NONE guibg=NONE
hi LineNr ctermfg=NONE guibg=NONE
hi SignColumn ctermfg=NONE guibg=NONE
hi StatusLine guifg=#16252b guibg=#6699CC
hi StatusLineNC guifg=#16252b guibg=#16252b

" Try to hide vertical spit and end of buffer symbol
hi VertSplit gui=NONE guifg=#17252c guibg=#17252c
hi EndOfBuffer ctermbg=NONE ctermfg=NONE guibg=#17252c guifg=#17252c


" NERDTREE """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F3> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable='▸'
let g:NERDTreeDirArrowCollapsible='▾'
let NERDTreeShowBookmarks=1
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '__pycache__', '\.swp$', '^\.DS_Store$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
hi NERDTreeCWD guifg=#99c794

" close vim if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"" COC """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"hi link CocErrorSign WarningMsg
"hi link CocWarningSign Number
"hi link CocInfoSign Type
"
"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
  "let col = col('.') - 1
  "return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"
"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"if exists('*complete_info')
  "inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
  "inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
  "if (index(['vim','help'], &filetype) >= 0)
    "execute 'h '.expand('<cword>')
  "else
    "call CocAction('doHover')
  "endif
"endfunction
"
"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)
"nmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>qf <Plug>(coc-fix-current)
"nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
"nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>


" VIM-BETTER-WHITESPACE """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>y :StripWhitespace<CR>

" DEVICONS """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:webdevicons_enable_nerdtree=1
let g:webdevicons_enabl=1
let g:WebDevIconsNerdTreeAfterGlyphPadding=' '

" NERDCOMMENTER """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDSpaceDelims=1
let g:NERDCompactSexyComs=1

" VIM-GITGUTTER """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=1

" AIRLINE """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Do not draw separators for empty sections (only for the active window).
let g:airline_skip_empty_sections = 1

" Make unique buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Customize vim airline per filetype
" 'nerdtree'  - Hide nerdtree status line
" 'list'      - Only show file type plus current line number out of total
let g:airline_filetype_overrides = {
  \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', ''), '' ],
  \ 'list': [ '%y', '%l/%L'],
  \ }

" Enable powerline fonts
let g:airline_powerline_fonts=1
let g:airline_theme="powerlineish"

" EASY-MOTION """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>w <Plug>(easymotion-bd-w)

