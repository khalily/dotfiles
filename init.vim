""" Pluginns
"""" Dein-begin

if &runtimepath !~# '/dein.vim'
  let s:dein_dir = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  if !isdirectory(s:dein_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_dir))
  endif

  execute 'set runtimepath^=' . s:dein_dir
endif

call dein#begin(expand('~/.cache/dein'))

"""" Plugin manager
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')


"""" Look & feel
call dein#add('drewtempelmeyer/palenight.vim')  " Color theme
call dein#add('ayu-theme/ayu-vim')              " Color theme
call dein#add('fneu/breezy')                    " Color theme
call dein#add('iCyMind/NeoSolarized')           " Color theme
call dein#add('mhartington/oceanic-next')       " Color theme
call dein#add('morhetz/gruvbox')                " Color theme
call dein#add('joshdick/onedark.vim')           " Color theme
call dein#add('w0ng/vim-hybrid')                " Color theme
call dein#add('vim-airline/vim-airline')        " Bottom Line
call dein#add('vim-airline/vim-airline-themes') " Bottom Line theme
call dein#add('edkolev/tmuxline.vim')           " Tmuxline
call dein#add('mhinz/vim-startify')             " start window
call dein#add('Yggdroot/indentLine')            " indent Line

"call dein#add('gcavallanti/vim-noscrollbar')    " Scrollbar for statusline
"call dein#add('cskeeters/vim-smooth-scroll')    " Smooth scroll
"call dein#add('moll/vim-bbye')                  " Keep window when closing a buffer
"call dein#add('romainl/vim-qf')                 " Quickfix / Loclist improvements

"""" Format code
call dein#add('tpope/vim-sleuth')                                     " Automatically detect tabs vs spaces
call dein#add('sbdchd/neoformat')                                     " Automatically format code
"call dein#add('dhruvasagar/vim-table-mode')                           " Format tables

"""" Manipulate code
call dein#add('tpope/vim-repeat')                                     " Repeat for plugin
call dein#add('vim-scripts/visualrepeat')                             " Repeat for plugins in visual mode
call dein#add('tpope/vim-surround')                                   " Surround
call dein#add('tpope/vim-abolish')                                    " Substitute with Smart Case (:S//)
call dein#add('Raimondi/delimitMate')                                 " Insert closing brackets automatically
call dein#add('vim-scripts/VisIncr')                                  " Generate increasing number column
call dein#add('tomtom/tcomment_vim')                                  " Comment lines
call dein#add('junegunn/vim-easy-align')                              " Easy align around equals
call dein#add('tpope/vim-endwise')                                    " Automatically put 'end' in some langs
call dein#add('alvan/vim-closetag')                                   " Automatically put closing tag in XML
call dein#add('matze/vim-move')                                       " Move blocks of code
call dein#add('scrooloose/nerdcommenter')                             " Fast comment
call dein#add('bronson/vim-trailing-whitespace')                      " Trailing whitspace

"""" Targets and text objects
call dein#add('wellle/targets.vim')                                   " Add more targets to operate on
call dein#add('kana/vim-textobj-user')                                " Add user-defined text objects
call dein#add('jceb/vim-textobj-uri',
      \ {'depends': 'vim-textobj-user'})                              " Text object: URI (u)
call dein#add('thinca/vim-textobj-between',
      \ {'depends': 'vim-textobj-user'})                              " Text object: between characters (f<char>)
call dein#add('glts/vim-textobj-comment',
      \ {'depends': 'vim-textobj-user'})                              " Text object: comments (c)
call dein#add('saaguero/vim-textobj-pastedtext',
      \ {'depends': 'vim-textobj-user'})                              " Text object: pasted text (gb)
call dein#add('Julian/vim-textobj-variable-segment',
      \ {'depends': 'vim-textobj-user'})                              " Text object: segments of variable_names (v)

"""" Snippets
call dein#add('SirVer/ultisnips')                                     " Snippet engine
call dein#add('honza/vim-snippets')                                   " List of snippets

"""" Navigate code
call dein#add('mbbill/undotree')                                      " undo tree
call dein#add('rizzatti/dash.vim')                                    " dash search doc
"call dein#add('haya14busa/incsearch.vim')                             " Incremental search
"call dein#add('haya14busa/incsearch-fuzzy.vim')                       " Fuzzy incremental search
call dein#add('osyo-manga/vim-anzu')                                  " Show search count
call dein#add('haya14busa/vim-asterisk')                              " Star * improvements
call dein#add('justinmk/vim-sneak')                                   " Improved F and T
call dein#add('t9md/vim-smalls')                                      " Quick jump anywhere
call dein#add('farmergreg/vim-lastplace')                             " Restore cursor position
call dein#add('kien/ctrlp.vim')                                       " Fuzzy file, buffer, mru, tag, etc finder.
call dein#add('tacahiroy/ctrlp-funky')                                " Function navigate
call dein#add('majutsushi/tagbar')                                    " Function navigate
call dein#add('scrooloose/nerdtree')                                  " File navigate
"call dein#add('ludovicchabant/vim-gutentags')                         " Automatically generate tags
call dein#add('mileszs/ack.vim')                                      " Ack search code

"""" Navigate files, buffers and panes
call dein#add('airblade/vim-rooter')                                  " Change working directory to the project root
call dein#add('junegunn/fzf', {'build': './install --bin'})           " Fuzzy search - binary
call dein#add('junegunn/fzf.vim')                                     " Fuzzy search - vim plugin
call dein#add('benizi/vim-automkdir')                                 " Automatically create missing folders on save
"call dein#add('christoomey/vim-tmux-navigator')                       " Easy navigation between vim and tmux panes
"call dein#add('nixprime/cpsm', {'build': './install.sh'})                                 " ctrlp matcher

"""" Autocomplete

"call dein#add('Valloric/YouCompleteMe', {'build': './install.py --go-completer'}) " Autocomplete engine
call dein#add('Shougo/deoplete.nvim')                                             " Autocomplete engine
call dein#add('Shougo/neco-vim')                                                  " Vim
call dein#add('Shougo/neco-syntax')                                               " Syntax
call dein#add('eagletmt/neco-ghc')                                                " Haskell
call dein#add('zchee/deoplete-jedi')                                              " Python
call dein#add('Shougo/echodoc.vim')

call dein#add('carlitux/deoplete-ternjs')                                         " Javascript
call dein#add('fishbullet/deoplete-ruby')                                         " Ruby
"call dein#add('wellle/tmux-complete.vim')                                         " Tmux panes
call dein#add('ervandew/supertab')                                                " tab completion
call dein#add('zchee/deoplete-go', {'build': 'make'})                             " Go
"call dein#add('zchee/deoplete-clang')                                             " C/C++/Object-C
call dein#add('Rip-Rip/clang_complete', {'build': 'make install'})                " C/C++/Object-C
call dein#add('zchee/deoplete-zsh')                                               " ZSH
"call dein#add('tenfyzhong/CompleteParameter.vim')                                  " complete parameter

"""" Git
call dein#add('tpope/vim-fugitive')                                   " Git integration
call dein#add('airblade/vim-gitgutter')                               " Git gutter

"""" Render code
call dein#add('sheerun/vim-polyglot')                                 " Many many syntaxes
call dein#add('ap/vim-css-color')                                     " Colors in CSS
call dein#add('euclio/vim-markdown-composer',
      \ {'build': 'cargo build --release'})                           " Instantly preview markdown

"""" Lint code
call dein#add('w0rp/ale')

"""" Language-specific
""""" Haskell
call dein#add('neovimhaskell/haskell-vim')                            " Better syntax highlight and indentation
call dein#add('eagletmt/ghcmod-vim')                                  " Ghc Mod
call dein#add('enomsg/vim-haskellConcealPlus')                        " Use unicode symbols for haskell keywords
call dein#add('Twinside/vim-hoogle')                                  " Query hoogle
call dein#add('mpickering/hlint-refactor-vim')                        " Fix lint issues

""""" Go
call dein#add('fatih/vim-go')                                         " Go development
""""" Python
call dein#add('davidhalter/jedi-vim')                                 " Python development
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#squelch_py_warning = 1
let g:jedi#goto_assignments_command = "<Leader>g"
let g:jedi#goto_command = "<C-]>"
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0
let g:jedi#usages_command = "<leader>r"
let g:jedi#rename_command = ""
set noshowmode

"""" Dein-end
call dein#end()

if dein#check_install()
  call dein#install()
endif

""" Environment
"""" General
filetype plugin indent on
syntax on
let &fillchars="vert:|,fold: ,diff: "
set cursorline                                                     " Spot the cursor easier
set diffopt+=iwhite                                                " Ignore whitespace changes
set expandtab                                                      " Use spaces by default, not tabs
set formatoptions+=l                                               " Don't wrap long lines when editing them
set formatoptions+=n                                               " Recognize numbered lists
"set formatoptions+=o                                               " Continue comment when pressing o or O
"set formatoptions+=r                                               " Continue comment when pressing Enter
set formatoptions-=c                                               " Don't wrap long comments
set formatoptions-=t                                               " Don't wrap long lines when typing them
set hidden                                                         " Keep buffer around even if it is not displayed right now
set ignorecase                                                     " Ignore search case
set langmap+=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ " Cyrillic layout in normal mode
set langmap+=фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz " Cyrillic layout in normal mode
set langmap+=ЖжЭэХхЪъ;\:\;\"\'{[}]                                 " Cyrillic layout in normal mode
set lazyredraw                                                     " Don't redraw when there is no need for it
set linebreak                                                      " Wrap lines intelligently, e.g. by end of words
set list                                                           " Display unusual whitespace characters
set listchars=tab:»·,trail:·,nbsp:·                                " Which whitespace characters to display and how
set mouse-=a                                                        " Enable mouse support
set noshowmode                                                     " Don't show current mode in echo
set nostartofline                                                  " Don't move cursor on the line when moving around
set noswapfile                                                     " Don't use swap files, use git
set nrformats=                                                     " Use only decimal numbers base when incrementing numbers
set number                                                         " Show line numbers
set report=0                                                       " Always report how many lines substitute changed
set scrolloff=3                                                    " Number of lines to keep above and below cursor
set shiftround                                                     " Round indent to a multiple of shiftwidth
set shiftwidth=2                                                   " Tab shifts by this number of spaces
set shortmess+=I                                                   " Don't show intro msg when starting vim
set shortmess+=c                                                   " Don't echo while autocompletion in insert mode
set showcmd
set showtabline=2
set sidescrolloff=3                                                " Number of columns to keep on the left/right of the cursor
set smartcase
set spelllang=en,da,ru
set splitbelow
set splitright
set tabstop=2
set title                                                          " Change terminal title based on the file name
set updatetime=100
"set virtualedit=all
set wildmode=longest,list,full
set wildignore=*.o,*~,*.pyc,*.class
set completeopt=menu,longest

"""" Theme
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif
set background=dark
"let ayucolor="dark"
"let ayucolor="mirage"
"let ayucolor="light"
"let python_highlight_all=1
"colorscheme ayu
"colorscheme palenight
colorscheme hybrid
"let g:gruvbox_italic=1
"let g:gruvbox_invert_selection=0
"colorscheme gruvbox
"hi Normal ctermbg=NONE guibg=NONE

"""" System
if !empty($PYENV_ROOT)
let g:python3_host_prog=$PYENV_ROOT."/versions/py3neovim/bin/python"
let g:python2_host_prog=$PYENV_ROOT."/versions/py2neovim/bin/python"
let g:python3_host_skip_check = 1
let g:python2_host_skip_check = 1
endif

""" Keyboard shortcuts
"""" Leader
let mapleader=","
nmap <Space> <Leader>
vmap <Space> <Leader>

"""" Write buffer
nnoremap <Leader>w :w<CR>

"""" Better redo
nnoremap U <C-R>

"""" Remove annoyance
nnoremap <Del> <nop>
vnoremap <Del> <nop>
nnoremap <Backspace> <nop>
vnoremap <Backspace> <nop>
nnoremap Q <nop>

"""" Yank line without spaces
nnoremap <expr> Y 'my^"'.v:register.v:count1.'yg_`y'

"""" Repeat last substitute with flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

"""" Select most recent paste
nmap gV vgb

"""" Copy to system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y

"""" Paste from system clipboard
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

"""" Delete, not cut
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d

"""" Paste in visual mode multiple times
xnoremap p pgvy

"""" Navigate through autocompletion
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

""""" Navigate through location list
"nmap <C-n> <Plug>qf_loc_next
"nmap <C-p> <Plug>qf_loc_previous

"""" Scroll command history
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

"""" Increment
nmap <C-Up> <C-a>
nmap <C-Down> <C-x>

"""" Close buffer and window
"nnoremap <silent> <Leader>cc :Bd<CR>
"nnoremap <silent> <Leader>CC :Bd!<CR>
nnoremap <Leader>cw :close<CR>

"""" Write with sudo
cnoremap W w !sudo tee > /dev/null %

"""" Edit .vimrc
nnoremap <silent> <Leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <Leader>sv :so $MYVIMRC<CR>

"""" Navigate through visual lines
"nnoremap <expr> j v:count ? 'j' : 'gj'
"nnoremap <expr> k v:count ? 'k' : 'gk'

"""" Indent / unindent
"nnoremap <S-Tab> <<
"nnoremap <Tab> >>
"xnoremap <Tab> >gv
"xnoremap <S-Tab> <gv

"""" Select all
nnoremap <Leader>v ggVG
xnoremap <Leader>v <C-C>ggVG

"""" Scroll by half of the screen
nmap <PageDown> <C-d>
nmap <PageUp> <C-u>
nmap <C-e> <C-u>

"""" Jump to previous / next cursor position
nnoremap <A-Left> <C-o>
nnoremap <A-Right> <C-i>

"""" Buffer navigation
nnoremap <silent> <C-PageUp> :bp<CR>
nnoremap <silent> <C-PageDown> :bn<CR>

"""" Fix 'gx' to support '?' in URLs
nmap gx mxviugx<Esc>`x

"""" Change tab size
nnoremap <silent><Leader>cst :setlocal ts=4 sts=4 noet <bar> retab! <bar> setlocal ts=2 sts=2 et <bar> retab<CR>

"""" Base shortcut
nnoremap ; :
nnoremap U <C-r>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

map <Leader>q :q!<CR>
map <Leader>qq :qa!<CR>
au FileType vimrc BufWritePost :source $MYVIMRC<CR>
nmap <Leader>h :exec "h" expand('<cword>')<CR>
nnoremap <Leader>y :echo expand('%:p')<CR>

inoremap <C-f> <Right>
inoremap <C-b> <Left>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Split
noremap <Leader>- :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>


function! HideNumber()
      if(&number)
            set number!
      else
            set number
      endif
endfunc
nnoremap <F2> :call HideNumber()<CR>

" auto close preview when leave insert
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
"  " For no inserting <CR> key.
"  return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction

" 定义函数AutoSetFileHead，自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif
    "如果文件类型为python
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif
    normal G
    normal o
    normal o
endfunc

" set some keyword to highlight
if has("autocmd")
    " Highlight TODO, FIXME, NOTE, etc.
    if v:version > 701
        autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
        autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
    endif
endif

""" Plugins configuration
"""" Air Line
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#enabled = 1

let g:ale_pattern_options = {'\.txt$': {'ale_enabled': 0}}
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme='onedark'
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-statusline-colors.conf"

"""" ALE
let g:ale_open_list = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_keep_list_window_open = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_loclist_msg_format='%linter%: %code: %%s'
let g:ale_linters = {
      \ 'go': ['golint', 'go vet', 'go build'],
      \ 'python': ['flake8'],
      \ 'c': ['clang'],
      \ }
let g:ale_python_flake8_use_global = 1
let g:ale_python_flake8_options = '--ignore=E501,E226'
let g:ale_echo_cursor = 1
let g:ale_set_quickfix = 1
let g:ale_set_loclist = 0
nmap <leader>a <Plug>(ale_go_to_definition)zz
nmap <leader>r <Plug>(ale_find_references)
nmap <Leader>s :ALEToggle<CR>
nnoremap <leader>ep :ALEPreviousWrap<CR>
nnoremap <leader>en :ALENextWrap<CR>
let g:ale_c_clang_options = ''

function! IsWindows()
  " Check for win32 is enough since it's true on win64
  return has('win32')
endfunction

function! ProcessFilename(filename, root)
  " Handle Unix absolute path
  if matchstr(a:filename, '\C^[''"\\]\=/') != ''
    let l:filename = a:filename
  " Handle Windows absolute path
  elseif IsWindows()
       \ && matchstr(a:filename, '\C^"\=[a-zA-Z]:[/\\]') != ''
    let l:filename = a:filename
  " Convert relative path to absolute path
  else
    " If a windows file, the filename may need to be quoted.
    if IsWindows()
      let l:root = substitute(a:root, '\\', '/', 'g')
      if matchstr(a:filename, '\C^".*"\s*$') == ''
        let l:filename = substitute(a:filename, '\C^\(.\{-}\)\s*$'
                                            \ , '"' . l:root . '\1"', 'g')
      else
        " Strip first double-quote and prepend the root.
        let l:filename = substitute(a:filename, '\C^"\(.\{-}\)"\s*$'
                                            \ , '"' . l:root . '\1"', 'g')
      endif
      let l:filename = substitute(l:filename, '/', '\\', 'g')
    else
      " For Unix, assume the filename is already escaped/quoted correctly
      let l:filename = shellescape(a:root) . a:filename
    endif
  endif

  return l:filename
endfunction

function! ALEParseClangOpts()

  let l:flagInfo = {
  \   '-I': {
  \     'pattern': '-I\s*',
  \     'output': '-I'
  \   },
  \   '-F': {
  \     'pattern': '-F\s*',
  \     'output': '-F'
  \   },
  \   '-iquote': {
  \     'pattern': '-iquote\s*',
  \     'output': '-iquote'
  \   },
  \   '-include': {
  \     'pattern': '-include\s\+',
  \     'output': '-include '
  \   }
  \ }

  let l:flagPatterns = []
  for l:flag in values(l:flagInfo)
    let l:flagPatterns = add(l:flagPatterns, l:flag.pattern)
  endfor
  let l:flagPattern = '\%(' . join(l:flagPatterns, '\|') . '\)'

  let l:local_conf = findfile('.clang_complete', getcwd() . ',.;')
  if l:local_conf == '' || !filereadable(l:local_conf)
    return
  endif

  let l:sep = '/'
  if IsWindows()
    let l:sep = '\'
  endif

  let l:root = fnamemodify(l:local_conf, ':p:h') . l:sep

  let l:opts = readfile(l:local_conf)
  for l:opt in l:opts
    " Ensure passed filenames are absolute. Only performed on flags which
    " require a filename/directory as an argument, as specified in s:flagInfo
    if matchstr(l:opt, '\C^\s*' . l:flagPattern . '\s*') != ''
      let l:flag = substitute(l:opt, '\C^\s*\(' . l:flagPattern . '\).*'
                            \ , '\1', 'g')
      let l:flag = substitute(l:flag, '^\(.\{-}\)\s*$', '\1', 'g')
      let l:filename = substitute(l:opt,
                                \ '\C^\s*' . l:flagPattern . '\(.\{-}\)\s*$',
                                \ '\1', 'g')
      let l:filename = ProcessFilename(l:filename, l:root)
      let l:opt = l:flagInfo[l:flag].output . l:filename
    endif

    "let b:clang_user_options .= ' ' . l:opt
    let g:ale_c_clang_options .= ' ' . l:opt
  endfor
endfunction
call ALEParseClangOpts()
"let g:ale_c_clang_options = "-I/home/wyang/work/c/bdengine/src/core -I/home/wyang/work/c/bdengine/src/event -I/home/wyang/work/c/bdengine/src/event/modules -I/home/wyang/work/c/bdengine/src/os/unix -I/home/wyang/work/c/bdengine/objs -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -I/home/wyang/work/c/bdengine/src/http -I/home/wyang/work/c/bdengine/src/http/modules"


"""" Asterisk
map *  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
map #  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
map g* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
map g# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)

"""" DelimitMate
let delimitMate_expand_cr = 1

"""" Dein
function! CleanPlugin()
      call map(dein#check_clean(), "delete(v:val, 'rf')")
      call dein#recache_runtimepath()
endfunction
"""" Deoplete
let g:deoplete#enable_at_startup = 1

call deoplete#custom#option('auto_refresh_delay', 10)
call deoplete#custom#option('auto_complete_delay', 10)
call deoplete#custom#option('refresh_always', v:false)
call deoplete#custom#source('_', 'min_pattern_length', 1)
call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])
call deoplete#custom#source('around', 'rank', 100)
call deoplete#custom#source('ultisnips', 'rank', 1000)
call deoplete#custom#source('buffer', 'rank', 999)
"set completeopt+=noinsert

"""" Deoplete-jedi (Python completion)
let g:deoplete#sources#jedi#show_docstring = 0
let g:deoplete#sources#jedi#server_timeout = 60

"""" echodoc
let g:echodoc#enable_force_overwrite = 0
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'echo'

"""" Deoplete-clang (c/c++/object-c completion)
"let g:deoplete#sources#clang#libclang_path = '/usr/lib/x86_64-linux-gnu/libclang-3.8.so'
"let g:deoplete#sources#clang#flags = [
"\ "-Isrc/core",
"\ "-Isrc/event",
"\ "-Isrc/event/modules",
"\ "-Isrc/os/unix",
"\ "-Iobjs",
"\ "-W",
"\ "-Wall",
"\ "-Wpointer-arith",
"\ "-Wno-unused-parameter",
"\ "-Werror",
"\ "-Isrc/http",
"\ "-Isrc/http/modules",
"\ "-Wl",
"\ "-E",
"\]


"""" Deoplete-ternjs (JS completion)
"let g:tern_request_timeout = 1
"let g:tern#command = ["tern"]
"let g:tern#arguments = ["--persistent"]

"""" SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"

"""" EasyAlign
nmap <Leader>= <Plug>(EasyAlign)
xmap <Leader>= <Plug>(EasyAlign)

"""" FZF
" Make :Ag not match file names, only file contents
"command! -bang -nargs=* AgContents call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

"nnoremap <silent> <Leader>f :AgContents<CR>

"""" Ghc-mod
nnoremap <silent> <leader>ht :w<CR>:GhcModType<CR>:GhcModTypeClear<CR>
nnoremap <silent> <leader>hT :w<CR>mh0:GhcModTypeInsert<CR>`h
nnoremap <silent> <leader>hi :w<CR>:GhcModInfo<CR>
nnoremap <silent> <leader>hI :HoogleInfo<CR>

"""" GitGutter
let g:gitgutter_map_keys = 0

nmap ]c <Plug>GitGutterNextHunk<Plug>GitGutterPreviewHunk<Bar>zv
nmap [c <Plug>GitGutterPrevHunk<Plug>GitGutterPreviewHunk<Bar>zv
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
nmap <Leader>gp <Plug>GitGutterPreviewHunk

"""" Go
let g:go_fmt_autosave = 0   " This is already done by Neoformat
let g:go_auto_type_info = 0 " Show type of anything under cursor
let g:go_updatetime = 0     " Do not override updatetime

au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <K> <Plug>(go-doc)
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1

"""" C/C++
let g:clang_library_path = '/usr/lib/x86_64-linux-gnu/libclang-3.8.so'

"""" Haskell Conceal
let hscoptions="𝐒𝐓𝐄𝐌wRTBQZDC"

"""" Haskell vim
let g:haskell_indent_disable = 1

"""" Hlint refactor
let g:hlintRefactor#disableDefaultKeybindings = 1

nnoremap <silent> <leader>hr :call ApplyOneSuggestion()<CR>
nnoremap <silent> <leader>hR :call ApplyAllSuggestions()<CR>

"""" Incsearch
"let g:incsearch#auto_nohlsearch = 1

"map / <Plug>(incsearch-forward)
"map ? <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)

"map z/ <Plug>(incsearch-fuzzy-/)
"map z? <Plug>(incsearch-fuzzy-?)
"map zg/ <Plug>(incsearch-fuzzy-stay)

"map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)zMzv
"map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)zMzv

"""" Markdown composer
let g:markdown_composer_open_browser = 1
let g:markdown_composer_custom_css = ['https://cdn.rawgit.com/maximbaz/github-markdown-css/gh-pages/github-markdown.css']

"""" Neco-ghc
let g:necoghc_enable_detailed_browse = 1

"""" Smalls
let g:smalls_auto_jump = 1

nmap s <Plug>(smalls)
xmap s <Plug>(smalls)
omap s <Plug>(smalls)

"""" Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

"""" TComment
let g:tcommentTextObjectInlineComment = ''

"""" UltiSnips
let g:UltiSnipsExpandTrigger       = "<c-x>"
let g:UltiSnipsJumpForwardTrigger  = "<c-k>"
let g:UltiSnipsJumpBackwardTrigger = "<c-j>"
"let g:UltiSnipsListSnippets = "<s-tab>"
let g:UltiSnipsSnippetDirectories  = ['UltiSnips']

"""" vim-gutentags
augroup vim-gutentags
  autocmd!
  autocmd FileType vim setlocal iskeyword+=:
augroup END

"""" vim-rooter
let g:rooter_use_lcd = 1
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1

"""" vim-smooth-scroll
let g:ms_per_line=1

"""" vim-table-mode
let g:table_mode_verbose = 0
let g:table_mode_corner = '|'
let g:table_mode_auto_align = 1

"""" vim-qf
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
nmap <leader>l <Plug>(qf_qf_toggle)

"""" ctrlp
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|pyc)$'
"let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
autocmd BufEnter ControlP let b:ale_enabled = 0
"let g:ctrlp_status_func = {
  "\ 'main': 'CtrlPStatusFunc_1',
  "\ 'prog': 'CtrlPStatusFunc_2',
"  \ }
"function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
"  return lightline#statusline(0)
"endfunction
"function! CtrlPStatusFunc_2(str)
"  return lightline#statusline(0)
"endfunction

"let g:tagbar_status_func = 'TagbarStatusFunc'
"function! TagbarStatusFunc(current, sort, fname, ...) abort
"  return lightline#statusline(0)
"endfunction

"""" ctrlp-funky
nnoremap <c-r> :CtrlPFunky<Cr>
let g:ctrlp_extensions = ['funky']
let g:ctrlp_funky_syntax_highlight = 1

"""" nerdtree
nmap <leader>n :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 25
"""" tagbar
nmap <leader>t :TagbarToggle<CR>
let g:tagbar_width = 33
"""" Trailing whitespace
map <leader><space> :FixWhitespace<cr>

"""" YouCompleteMe
"au BufEnter *.py nmap <c-]> :YcmCompleter GoTo<CR>
"au BufEnter *.go nmap <c-]> :YcmCompleter GoTo<CR>
"au BufEnter *.py nmap K :YcmCompleter GetDoc<CR>
"au BufEnter *.txt nmap <C-]> :tag <C-R>=expand('<cword>')<CR><CR><Paste>
"let g:ycm_python_binary_path = 'python'
"let g:ycm_collect_identifiers_from_comments_and_strings = 1
"let g:ycm_collect_identifiers_from_tags_files = 1
"let g:ycm_server_keep_logfiles = 0
"let g:ycm_server_log_level = 'info'
"let g:ycm_filepath_completion_use_working_dir = 1
"let g:ycm_goto_buffer_command = 'same-buffer'
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_path_to_python_interpreter = ''
"""" dash vim
if has('macunix')
  nmap <leader>d :Dash<CR>
endif
"""" neoformat
let g:neoformat_enabled_python = ['autopep8']

"""" Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev LAck LAck!
function! Find()
  let pattern = input('Search for pattern: ', expand('<cword>'))
  if pattern == ''
    return
  endif
  execute 'LAck '.pattern
endfunction

noremap <Leader>f :call Find()<CR>

"""" CompleteParameter
let g:complete_parameter_use_ultisnips_mapping = 1

"""" undo tree
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif
nnoremap <F5> :UndotreeToggle<cr>
""" Functions
"""" Removes trailing whitespace
function! RemoveTrailingSpaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

nnoremap <silent> <F10> :call RemoveTrailingSpaces()<CR>

"""" Smart HOME & END
function! SmartHome(mode)
  let curcol = col(".")
  "gravitate towards beginning for wrapped lines
  if curcol > indent(".") + 2
    call cursor(0, curcol - 1)
  endif
  if curcol == 1 || curcol > indent(".") + 1
    if &wrap
      normal g^
    else
      normal ^
    endif
  else
    if &wrap
      normal g0
    else
      normal 0
    endif
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endfunction

function! SmartEnd(mode)
  let prev_virtualedit = &virtualedit
  set virtualedit=
  let curcol = col(".")
  let lastcol = a:mode == "i" ? col("$") : col("$") - 1
  "gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    let l:charlen = byteidx(getreg('1'), 1)
    call cursor(0, curcol + l:charlen)
  endif
  if curcol < lastcol
    if &wrap
      normal g$
    else
      normal $
    endif
  else
    normal g_
  endif
  "correct edit mode cursor position, put after current character
  if a:mode == "i"
    let l:charlen = byteidx(getreg('1'), 1)
    call cursor(0, col(".") + l:charlen)
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  let &virtualedit = prev_virtualedit
  return ""
endfunction

nnoremap <silent><Home> :call SmartHome("n")<CR>
nnoremap <silent><End> :call SmartEnd("n")<CR>
inoremap <silent><Home> <C-r>=SmartHome("i")<CR>
inoremap <silent><End> <C-r>=SmartEnd("i")<CR>
vnoremap <silent><Home> <Esc>:call SmartHome("v")<CR>
vnoremap <silent><End> <Esc>:call SmartEnd("v")<CR>

"""" Toggle automatic code formatting
function! ToggleAutoFormatCode()
  if !exists('#AutoFormatCode#BufWritePre')
    augroup AutoFormatCode
      autocmd!
      autocmd BufWritePre * silent! Neoformat
    augroup END
  else
    augroup AutoFormatCode
      autocmd!
    augroup END
  endif
endfunction
command! ToggleAutoFormatCode :call ToggleAutoFormatCode()
call ToggleAutoFormatCode() " Enable by default

"""" Repeat macro over visual selection
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"""" Set terminal title
function! SetTerminalTitle()
  let bufnr = bufnr('%')
  if buflisted(bufnr)
    if bufname(bufnr) == ''
      let &titlestring = 'unnamed'
    else
      let &titlestring = expand('%:~')
    endif
  endif
endfunction

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

"""" Toggle quick fix
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>ee :call ToggleList("Quickfix List", 'c')<CR>

""" AutoCmd
augroup helper-windows-close
  autocmd!
  autocmd BufWinEnter * if &buftype == 'quickfix' | nnoremap <buffer> q :cclose <bar> :lclose <CR> | endif
  autocmd BufWinEnter * if &buftype == 'help' | nnoremap <buffer> q :helpclose <CR> | endif
  autocmd InsertLeave * pclose
augroup END

augroup reload-files-changed-outside
  autocmd!
  autocmd BufEnter,FocusGained * checktime
augroup END

augroup title
  autocmd!
  autocmd BufEnter * call SetTerminalTitle()
augroup END


"" vim:foldmethod=expr:foldlevel=1
"" vim:foldexpr=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='
