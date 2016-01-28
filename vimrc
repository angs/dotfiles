call pathogen#infect()
call pathogen#helptags()

set tabstop=2
set autoindent
set modeline
set updatetime=1000
set langmap=KS,LN,NH,HK,SJ,JT,TL,ln,nk,ks,sl,jt,tj
set title

au Bufenter *.hs compiler ghc
au Bufenter *.hs set expandtab
au Bufenter *.lhs set expandtab
au Bufenter *.krypto set filetype=krypto
au Bufenter *.krypto noremap <Nul> <C-x><C-u>
au Bufenter *.krypto nmap <Nul> R<C-x><C-u>
au Bufenter *.krypto execute 'setlocal makeprg=krypto %'
syntax on
filetype plugin on
let g:haddock_browser = "google-chrome"

nmap <F2> :w <CR> :make <CR><CR>
nmap <F3> :prev <CR>
nmap <F4> :n <CR>
nmap <F5> :!evince %<.pdf & <CR>
nmap <F6> :w<CR> :!krypto % <CR>
nmap <F7> :!evince %<.svg &<CR>
imap <F8> :call Transpose()
nmap <F8> :call Transpose()<CR>
nmap <F9> :call Hae()<CR>

set laststatus=2
set statusline=\ %f%m%r%h%w\ %=%({%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y}%)\ %([%l,%v][%p%%]\ %)

source ~/.vim/errormarker.vim
let g:vimchant_spellcheck_lang = 'fi'


