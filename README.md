# vim-interestingwords

## What is it?

TL;DR Scroll down for the gifs.

vim-interstingwords is a vim plugin that **highlights** all the occurrences of the word under your cursor. It can be used to highlight **different** words at the same time. To highlight a word you hit ``<Leader>k``.

It also lets you **navigate** these highlighted words using ``n`` and ``N``, just like you would navigate through the results of a search.

## What's the point?

This plugin is useful when you are working with a codebase that you are not yet familiar with. In that scenario, highlighting and navigating through different words at the same time can really help you not to get lost on the execution flow.

The idea to build this plugin came from the **@stevelosh** video's where he shows some pretty cool configurations from his .vimrc. He named this configuration interesting words, and I choose to keep the name for this plugin. The video is on youtube: https://www.youtube.com/watch?v=xZuy4gBghho

## Installation

Using vundle, add this to your .vimrc:

```vimscript
Plugin 'vasconcelloslf/vim-interestingwords'
```

Then run:

```vimscript
:PluginInstall
```

## Usage

### Highlighting Words

Highlight with ``<Leader>k``

This key will act as a **toggle**, so you can use it to highlight and remove the highlight from a given word. Note that you can highlight different words at the same time.

![Screenshot](https://s3-us-west-2.amazonaws.com/vim-interestingwords/interesting-words-1.gif)

### Navigating Through the Highlighted Words

Navigate with ``n`` and ``N``

Once you have a highlighted word under your cursor, you can **navigate** through the occurrences of this word with ``n`` and ``N``, just as you would if you were using a traditional search.

![Screenshot](https://s3-us-west-2.amazonaws.com/vim-interestingwords/interesting-words-2.gif)

### Clearing all the Highlights

Clear with ``<Leader>K``

Finally, if you don't want to toggle every single highlighted word and want to clear all of them, just hit ``<Leader>K``

![Screenshot](https://s3-us-west-2.amazonaws.com/vim-interestingwords/interesting-words-3.gif)

## Configuration

The plugin comes with those default mapping, but you can change it as you like:

```vimscript
nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>
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

## Author

[twitter.com/lfv89](http://twitter.com/lfv89)

[luisvasconcellos.com](http://www.luisvasconcellos.com)

Feel free to talk to me about anything related to this project.
