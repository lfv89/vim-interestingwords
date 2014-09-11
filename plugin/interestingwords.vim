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
let s:recentlyUsed = []

function! ColorWord(word)
  if !(s:hasBuiltColors)
    call s:buildColors()
  endif

  " gets the lowest unused index
  let n = index(s:interestingWords, 0)
  if (n == -1)
    if !(exists('g:interestingWordsCycleColors') && g:interestingWordsCycleColors)
      echom "InterestingWords: max number of highlight groups reached " . len(s:interestingWords)
      return
    else
      let n = s:recentlyUsed[0]
      call UncolorWord(s:interestingWords[n])
    endif
  endif

  let mid = 595129 + n
  let s:interestingWords[n] = a:word
  let s:mids[a:word] = mid

  let case = s:checkIgnoreCase(a:word) ? '\c' : '\C'
  let pat = case . '\V\<' . escape(a:word, '\') . '\>'

  call matchadd("InterestingWord" . (n + 1), pat, 1, mid)

  call s:markRecentlyUsed(n)

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

  if (s:checkIgnoreCase(currentWord))
    let currentWord = tolower(currentWord)
  endif

  if (index(s:interestingWords, currentWord) > -1)
    let case = s:checkIgnoreCase(currentWord) ? '\c' : '\C'
    let pat = case . '\V\<' . escape(currentWord, '\') . '\>'
    let searchFlag = ''
    if !(a:direction)
      let searchFlag = 'b'
    endif
    call search(pat, searchFlag)
  else
    if (a:direction)
      silent! normal! n
    else
      silent! normal! N
    endif
  endif
endfunction

function! InterestingWords()
  let currentWord = expand('<cword>') . ''
  if !(len(currentWord))
    return
  endif
  if (s:checkIgnoreCase(currentWord))
    let currentWord = tolower(currentWord)
  endif
  if (index(s:interestingWords, currentWord) == -1)
    call ColorWord(currentWord)
  else
    call UncolorWord(currentWord)
  endif
endfunction

function! UncolorAllWords()
  for word in s:interestingWords
    " check that word is actually a String since '0' is falsy
    if (type(word) == 1)
      call UncolorWord(word)
    endif
  endfor
endfunction

" returns true if the ignorecase flag needs to be used
function! s:checkIgnoreCase(word)
  " return false if case sensitive is used
  if (exists('g:interestingWordsCaseSensitive'))
    return !g:interestingWordsCaseSensitive
  endif
  " checks ignorecase
  " and then if smartcase is on, check if the word contains an uppercase char
  return &ignorecase && (!&smartcase || (match(a:word, '\u') == -1))
endfunction

" moves the index to the back of the s:recentlyUsed list
function! s:markRecentlyUsed(n)
  let index = index(s:recentlyUsed, a:n)
  call remove(s:recentlyUsed, index)
  call add(s:recentlyUsed, a:n)
endfunction

" initialise highlight colors from list of GUIColors
" initialise length of s:interestingWord list
" initialise s:recentlyUsed list
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
    call add(s:recentlyUsed, currentIndex-1)
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

nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>
