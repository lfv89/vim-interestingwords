# vim-interestingwords #

## What is it? ##

InterestingWords is a vim plugin that **highlights** all the occurrences of the word under your cursor. It can be used to highlight different words at the same time. To highlight a word you hit ``K``.

It also lets you **navigate** these highlighted words using ``n`` and ``N``, just like you would navigate through the results of a search.

## What's the point? ##

This plugin is useful when you are trying to understand a particular piece of code. In that scenario, highlighting different words at the same time on the code can really help you not to get lost on the execution flow.

The idea to build this plugin came from the **@stevelosh** video's where he shows some pretty cool configurations from his .vimrc. He named it interesting words, and I chosse to use the same name for this plugin. The video is on youtube: https://www.youtube.com/watch?v=xZuy4gBghho

## Installation ##

Using vundle, add this to your .vimrc:

```vimscript
Plugin 'vasconcelloslf/vim-interestingwords'
```

Than run:

```vimscript
:PluginInstall
```

## Usage ##

### Highlighting Words###

By default you can **highlight** a word with the ``K`` key. This key will act as a **toggle**, so you can use it to highlight and to remove the highlight from a specific word. Note that you can highlight different words a the same time (8 to be exact).

![Screenshot](https://s3-us-west-2.amazonaws.com/vim-interestingwords/interesting-words-1.gif)

### Navigating Through the Highlighted Words###

Once you have a highlighted word under your cursor, you can **navigate** through the occurrences of this word with ``n`` and ``N``, just as you would if you were using a traditional search.

![Screenshot](https://s3-us-west-2.amazonaws.com/vim-interestingwords/interesting-words-2.gif)

### Clearing all the Highlights ###

Finally, if you don't want to toggle every single highlighted word and want to clear all of them, just hit ``<Leader>k``

![Screenshot](https://s3-us-west-2.amazonaws.com/vim-interestingwords/interesting-words-3.gif)

## Configuration ##

The plugin comes with those default mapping, but you can change it as you like:

```vimscript
nnoremap <silent> K         :call InterestingWords()<cr>
nnoremap <silent> <leader>k :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>
```

## About

blog:    [http://luisvasconcellos.sexy](http://www.luisvasconcellos.com)

twitter: [@vasconcelloslf](http://twitter.com/vasconcelloslf)
