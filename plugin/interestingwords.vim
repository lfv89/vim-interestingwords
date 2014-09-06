" --------------------------------------------------------------------
" This plugin was inspired and based on Steve Losh's interesting words
" .vimrc config https://www.youtube.com/watch?v=xZuy4gBghho
" --------------------------------------------------------------------

let s:interestingWords = []
let s:mids = []

function! ColorWord(n)
  let currentWord = expand('<cword>') . ''

  if (index(s:interestingWords, currentWord) == -1)
    let mid = 86750 + a:n

    call add(s:interestingWords, currentWord)
    call add(s:mids, mid)

    normal! mz
    normal! "zyiw

    let pat = '\V\<' . escape(@z, '\') . '\>'

    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    normal! `z
  else
    call UncolorWord()
  endif
endfunction

function! UncolorWord()
  let currentWord = expand('<cword>') . ''
  let currentWordPosition = index(s:interestingWords, currentWord)

  if (currentWordPosition > -1)
    let mid = s:mids[currentWordPosition]

    silent! call matchdelete(mid)

    call remove(s:interestingWords, currentWordPosition)
    call remove(s:mids, currentWordPosition)
  endif
endfunction

function! WordNavigation(direction)
  let currentWord = expand('<cword>') . ''

  if (index(s:interestingWords, currentWord) > -1)
    if (a:direction == 'forward')
      normal! *
    endif

    if (a:direction == 'backward')
      normal! #
    endif
  else
    if (a:direction == 'forward')
      silent! normal! n
    endif

    if (a:direction == 'backward')
      silent! normal! N
    endif
  endif
endfunction

function! InterestingWords()
  call ColorWord(len(s:interestingWords) + 1)
endfunction

function! UncolorAllWords()
  if (len(s:mids) > 0)
    for mid in s:mids
      call matchdelete(mid)
    endfor

    call remove(s:mids, 0, -1)
    call remove(s:interestingWords, 0, -1)
  endif
endfunction

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#ff0000 ctermbg=121
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#0000ff ctermbg=211
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88823 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=222

nnoremap <silent> K         :call InterestingWords()<cr>
nnoremap <silent> <leader>k :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>
