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
let s:mids = {}

function! ColorWord(word)
  if !(s:hasBuiltColors)
    call s:buildColors()
  endif

  let n = index(s:interestingWords, 0)
  if (n == -1)
    echom "InterestingWords: max number of highlight groups reached"
    return
  endif

  let mid = 595129 + n
  let s:interestingWords[n] = a:word
  let s:mids[a:word] = mid

  let pat = '\V\<' . escape(a:word, '\') . '\>'
  call matchadd("InterestingWord" . (n + 1), pat, 1, mid)

endfunction

function! UncolorWord(word)
  let index = index(s:interestingWords, a:word)

  if (index > -1)
    let mid = s:mids[a:word]

    silent! call matchdelete(mid)
    let s:interestingWords[index] = 0
    unlet s:mids[a:word]
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
  let currentWord = expand('<cword>') . ''
  if !(len(currentWord))
    return
  endif
  if (index(s:interestingWords, currentWord) == -1)
    call ColorWord(currentWord)
  else
    call UncolorWord(currentWord)
  endif
endfunction

function! UncolorAllWords()
  for mid in values(s:mids)
    call matchdelete(mid)
  endfor
  let s:mids = {}
  let s:interestingWords = []
endfunction

" initialise colors from list of GUIColors
" initialise length of s:interestingWord list
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
    call add(s:interestingWords, 0)
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
