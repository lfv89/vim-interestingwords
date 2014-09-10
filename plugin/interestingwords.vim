" --------------------------------------------------------------------
" This plugin was inspired and based on Steve Losh's interesting words
" .vimrc config https://www.youtube.com/watch?v=xZuy4gBghho
" --------------------------------------------------------------------


let s:interestingWordsGUIColors = ['#aeee00', '#ff0000', '#0000ff', '#b88823', '#ffa724', '#ff2c4b']
let s:interestingWordsTermColors = ['154', '121', '211', '137', '214', '222']

let g:interestingWordsGUIColors = exists('g:interestingWordsGUIColors') ? g:interestingWordsGUIColors : s:interestingWordsGUIColors
let g:interestingWordsTermColors = exists('g:interestingWordsTermColors') ? g:interestingWordsTermColors : s:interestingWordsTermColors

let s:hasBuiltColors = 0

let s:interestingWords = []
let s:mids = []

function! ColorWord(n)
  if !(s:hasBuiltColors)
    call s:buildColors()
  endif

  if (a:n > len(g:interestingWordsGUIColors))
    echom "InterestingWords: max number of highlight groups reached: " a:n-1
    return
  endif

  let currentWord = expand('<cword>') . ''
  if (currentWord =~# '^\k\+$')
    if (index(s:interestingWords, currentWord) == -1)

      let mid = 595129 + a:n

      call add(s:interestingWords, currentWord)
      call add(s:mids, mid)

      let pat = '\V\<' . escape(currentWord, '\') . '\>'

      call matchadd("InterestingWord" . a:n, pat, 1, mid)

    else
      call UncolorWord()
    endif
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

" initialise colors from list of GUIColors
function! s:buildColors()
  if (s:hasBuiltColors)
    return
  endif
  if has('gui_running')
    let ui = 'gui'
    let wordColors = g:interestingWordsGUIColors
  else
    let ui = 'cterm'
    let wordColors = g:interestingWordsTermColors
  endif
  if (exists('g:interestingWordsRandomiseColors') && g:interestingWordsRandomiseColors)
    " fisher-yates shuffle
    let i = len(wordColors)-1
    while i > 0
      let j = s:Random(i)
      let temp = wordColors[i]
      let wordColors[i] = wordColors[j]
      let wordColors[j] = temp
      let i -= 1
    endwhile
  endif
  " select ui type
  " highlight group indexed from 1
  let currentIndex = 1
  for wordColor in wordColors
    execute 'hi! def InterestingWord' . currentIndex . ' ' . ui . 'bg=' . wordColor . ' ' . ui . 'fg=Black'
    let currentIndex += 1
  endfor
  let s:hasBuiltColors = 1
endfunc

" helper function to get random number between 0 and n-1 inclusive
function! s:Random(n)
  let timestamp = reltimestr(reltime())[-2:]
  return float2nr(floor(a:n * timestamp/100))
endfunction

nnoremap <silent> <leader>k :call InterestingWords()<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>
