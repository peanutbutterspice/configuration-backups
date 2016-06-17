" pathogen stuff 
set nocompatible
" set fileencoding=utf8
" set ff=dos
execute pathogen#infect()
syntax on
filetype plugin indent on

" colorscheme stuff 
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" useful line numbers
set relativenumber

" purty font
" set guifont=Fira_Mono_for_Powerline:h10:cANSI

" re-open vim in the same position with the same screen size
if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
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
set linebreak

" for CTRL+P
set runtimepath^=~/.vim/bundle/ctrlp.vim

" for airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" to show pretty airline symbols
set encoding=utf-8

" use a different bash, because screw CMD
" set shell=C:/Program\ Files/Git/bin/bash
" set shellcmdflag=--login\ -c
" set shellxquote=\"

" for .md markdown syntax
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" hide things I never use, like menu & toolbars
" set guioptions-=m "remove menu bar
" set guioptions-=T "remove toolbar
" set guioptions-=r "remove right-hand scroll bar
" set guioptions-=L "remove left-hand scroll bar

" Synstastic  Stuff 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "active_filetypes": ["cs"],
    \ "passive_filetypes": ["puppet"] }

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cs_checkers = ["mcs"]
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:syntastic_enable_signs = 1

" Signify 
let g:signify_vcs_list = [ 'svn', 'git' ]
let g:signify_difftool = 'diff'

" Easy Motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere with minimal effort
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)

" Case insensitive
let g:EasyMotion_smartcase = 1

" For j/k line movement
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" For opening files quickly in their default editor (useful for web pages)
nnoremap <F5> :!explorer %:p<CR>

" For quickly building the current project without typing commands
nnoremap <C-B> :!msbuild<CR>

map ESCAPE to the key sequence: jj
inoremap jj <ESC>

" OmniSharp
" let g:OmniSharp_timeout = 1
" set noshowmatch
let g:Omnisharp_start_server = 0
let g:Omnisharp_stop_server = 0 
" YCM Setup
" let g:loaded_youcompleteme = 1
let g:ycm_auto_start_csharp_server = 1
let g:ycm_auto_stop_csharp_server = 1

" nerdtree
map <C-n> :NERDTreeToggle<CR>
