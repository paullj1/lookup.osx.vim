" lookup.vim - :Lookup the word in Dictionary.app (OS X)
" Author: Paul Jordan <paullj1@gmail.com>
" Version: 0.1

if &cp || (exists("g:loaded_lookup") && g:loaded_lookup)
    finish
endif
let g:loaded_lookup = 1

function! s:DefPython()

python << PYTHONEOF

import vim
import sys
from DictionaryServices import *

def safequotes(string):
    return string.replace('"', "'")

def lookup(word):
    wordrange = (0, len(word))
    output = DCSCopyTextDefinition(None, word, wordrange)
    if not output:
        output = "'%s' not found in Dictionary." % (word)

    vim.command('silent let g:lookup_meaning = "%s"' % safequotes(output))

PYTHONEOF
endfunction

call s:DefPython()

function! Lookup()

    let word = expand("<cword>")
    execute "python lookup('" . word . "')"
    echohl WarningMsg
    echo g:lookup_meaning
    echohl None

endfunction

command Lookup call Lookup()

