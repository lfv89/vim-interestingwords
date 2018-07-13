# vim-interestingwords

![Screenshot](https://i.imgbox.com/5k3OJWIk.png)

## What is it?

A plugin that **highlights** the occurrences of the word under your cursor. It can be used to highlight **different** words at the same time. It also lets you **navigate** through the highlighted words just like you would navigate through the results of a search.

## Installation

The recommended installation is through `vim-plug`:

```vimscript
Plug 'lfv89/vim-interestingwords'
```

## Usage

- Highlight with ``<Leader>k``
- Navigate with ``n`` and ``N``
- Clear highlights with ``<Leader>K``

### Highlight

This key will act as a **toggle**, so you can use it to highlight and remove the highlight from a given word. Note that you can highlight different words at the same time.

### Navigation

With a highlighted word **under your cursor**, you can **navigate** through the occurrences of this word with ``n`` and ``N``, just as you would if you were using a traditional search.

### Clearing Highlights

Finally, if you don't want to toggle every single highlighted word and want to clear all of them, just hit ``<Leader>K``

## Configuration

The plugin comes with those default mapping, but you can change it as you like:

```vimscript
let g:interestingWordsDefaultMappings = 0

nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
vnoremap <silent> <leader>k :call InterestingWords('v')<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>
```

Thanks to **@gelguy** it is now possible to randomise and configure your own colors

To configure the colors for a GUI, add this to your .vimrc:

```vimscript
let g:interestingWordsGUIColors = ['#8CCBEA', '#A4E57E', '#FFDB72', '#FF7272', '#FFB3FF', '#9999FF']
```

And for a terminal:

```vimscript
let g:interestingWordsTermColors = ['154', '121', '211', '137', '214', '222']
```

Also, if you want to randomise the colors (applied to each new buffer), add this to your .vimrc:

```vimscript
let g:interestingWordsRandomiseColors = 1
```

## Credits

The idea to build this plugin came from the **@stevelosh** video's where he shows some pretty cool configurations from his .vimrc. He named this configuration interesting words, and I choose to keep the name for this plugin. The video is on youtube: https://www.youtube.com/watch?v=xZuy4gBghho

## Me

[luisvasconcellos.com](http://www.luisvasconcellos.com)

Feel free to talk to me about anything related to this project.
