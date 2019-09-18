" pathogen stuff 
set nocompatible
set encoding=utf8
" set ff=dos
set ff=unix
" execute pathogen#infect()
syntax on
filetype plugin indent on

" useful line numbers
" set relativenumber
set number

if has("gui_running")
    set guifont=IBM\ 3270\ Semi-Narrow\ Medium\ 12
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
endif

" gimmie a normal backspace
set backspace=indent,eol,start

" convert tabs to spaces
set expandtab

" set tab stop and indent width
set tabstop=4
set shiftwidth=4

" fix indenting
set breakindent
set breakindentopt=shift:4
" set linebreak

" for .md markdown syntax
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" disable audible error sounds, etc
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" setup the statusline
" set laststatus=2
" set statusline=%F
" set statusline+=%=
" set statusline+=Ln:\ %l/%L\ %m\ %y

set splitbelow

" Color stuff
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
"set t_Co=256
set t_ut=""
"set term=screen-256color
"set term=xterm-256color
"let g:solarized_termcolors=256

set background=light "dark
" colorscheme PaperColor " PaperColor solarized industry seoul256-light
colorscheme PaperColor

" airline
" let g:airline_theme = 'papercolor'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = ''
let g:airline_symbols.whitespace = ''


" nerdtree stuff
map <C-n> :NERDTreeToggle<CR>

set hidden

let g:ctrlp_custom_ignore = {
    \ 'file': '\v\.(exe|dll|class)$',
    \ 'dir': '\v[\/](git|target|bin)$',
    \ }

let g:ctrlp_by_filename = 1

function! GetAllSourceDirectories()
    let l:sourceDirs = split(globpath('/home/devynmapes/Work', '**/src'), '\n')
    let g:vimjdb_jdb_command='jdb -sourcepath '
    let l:run = 0

    for item in l:sourceDirs
        if (!l:run)
            let g:vimjdb_jdb_command.=item
            let run = 1
        else
            let g:vimjdb_jdb_command.=':'.item
        endif
    endfor
endfunction

function! JunitSingleFile()
    call UnSetJavaToolOptions()
    " save cursor position
    execute "normal! magg"

    "/public\ class\<cr>3e\"ayiw"
    " execute \"normal! gg"

    " get the current test name 
    call search('public\ class')
    execute "normal! 3e"
    let testName = expand('<cword>')

    " return the cursor to the previous position
    execute "normal! `a"

    " run tests
    execute "term mvn -P skip_static -DfailIfNoTests=false -Dtest=".testName." test"
    call SetJavaToolOptions()
endfunction

function! JunitAllTests()
    execute "term mvn test"
endfunction

call GetAllSourceDirectories()

" YouCompleteMe {
nnoremap <leader>f :YcmCompleter FixIt<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gi :YcmCompleter GetDoc<CR>
let g:ycm_always_populate_location_list = 1
" YouCompleteMe }

" Java Debugging {
autocmd FileType java nnoremap <F3> :JDBBreakpointOnLine<CR>
autocmd FileType java nnoremap <F4> :JDBClearBreakpointOnLine<CR>
autocmd FileType java nnoremap <F5> :JDBContinue<CR>
autocmd FileType java nnoremap <F6> :JDBStepIn<CR>
autocmd FileType java nnoremap <F7> :JDBStepUp<CR>
autocmd FileType java nnoremap <F8> :JDBStepOver<CR>
" Java Debugging }

" Java Tool Options {
function! SetJavaToolOptions() 
    let $JAVA_TOOL_OPTIONS = '-javaagent:'.$HOME.'/Work/lombok.jar -Xbootclasspath/p:'.$HOME.'/Work/lombok.jar'
endfunction

function! UnSetJavaToolOptions()
    let $JAVA_TOOL_OPTIONS = '' 
endfunction

autocmd VimEnter * call SetJavaToolOptions()
autocmd VimLeave * call UnSetJavaToolOptions()
" Java Tool Options }

" Database Setup {
autocmd FileType sql nnoremap <buffer> <leader>q :call sqltools#callquery('SOLGM')<cr>

let g:dbext_default_user = 'V500'
let g:dbext_default_password = 'V500'

" let g:dbext_default_profile_ORA = 'type=ORA:srvname=solgm'
let g:dbext_default_profile_SOLGM = 'type=ORA:srvname=ipsoldb3.ip.devcerner.net\:1521/ssolgm.world:user=v500:passwd=v500'
let g:dbext_default_profile_PROVIDE = 'type=ORA:srvname=ipprovidedb.ip.devcerner.net\:1521/prov1.world:user=v500:passwd=v500'
let g:dbext_default_profile_INTGM = 'type=ORA:srvname=ipintdb1.ip.devcerner.net\:1521/intgm.world:user=v500:passwd=v500'
let g:dbext_default_profile_64DEV = 'type=ORA:srvname=ip64devdb01.ip.devcerner.net\:1521/dev64.world:user=v500:passwd=v500'
let g:dbext_default_profile_VDM = 'type=ORA:srvname=10.171.145.201\:1521/sol.world:user=v500:passwd=v500'
" Database Setup }

autocmd bufread,bufnewfile *.story set ft=jbehave
