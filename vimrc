call pathogen#infect()
call pathogen#helptags()
set iskeyword=@,48-57,_,192-255,#
set tabstop=2
set autoindent
au Bufenter *.krypto set filetype=krypto
map <F2> :w <CR> :make <CR><CR>
map <F3> :prev <CR>
map <F4> :n <CR>
map <F5> :!evince %<.pdf & <CR>
map <F6> :w<CR> :!krypto % <CR>
map <F7> :!evince %<.svg &<CR>
map <F8> :call Transpose()<CR>
map <F9> :call Hae()<CR>
map <F12> :call HaeTama()<CR>
set modeline

source ~/.vim/errormarker.vim
filetype plugin on
au Bufenter *.hs compiler ghc
set updatetime=1000
let g:vimchant_spellcheck_lang = 'fi'

set langmap=KS,LN,NH,HK,SJ,JT,TL,ln,nk,ks,sl,jt,tj
set title
