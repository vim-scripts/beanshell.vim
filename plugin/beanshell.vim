" $Id: beanshell.vim,v 1.2 2002/09/06 03:10:31 henry Exp $
"
" Name:             BeanShell plugin
" Description:      Runs the current buffer using BeanShell
" Author:           Henry So, Jr. <henryso at panix dot com>
" Version:          1.0
" Modified:         5 August 2002
" License:          Released into the public domain.
"
" Usage:            Copy this file into the plugins directory if you want it
"                   to be automatically sourced.  Otherwise, :source it when
"                   you need it.
"
"                   By default, <Leader>br will invoke BeanShell.
"
" Configuration:    Use :let to set these variables to customize the behavior
"                   of the BeanShell plugin.
"
"                   BeanShell_Key   (Default: "<Leader>br")
"                       Defines the key mapping to use to invoke BeanShell.
"
"                   BeanShell_Cmd   (Default: "java bsh.Interpreter")
"                       Defines the command to use to run BeanShell.
"
" Acknowledgments:  This script owes its roots and style to Jamis Buck's
"                   sqlplus.vim, Yegappan Lakshmanan's taglist.vim, and
"                   Anthony Kruize / Michael Geddes's ShowMarks.

if exists('loaded_beanshell') || &cp
    finish
endif
let loaded_beanshell=1

if !exists('BeanShell_Key')
    let BeanShell_Key = "<Leader>br"
endif

if !exists('BeanShell_Cmd')
    let BeanShell_Cmd = "java bsh.Interpreter"
endif

" Function:     BeanShell_Run
" Description:  Runs BeanShell on the current buffer, opening a new window
"               with the output.
function! s:BeanShell_Run() "{{{1
  let l:old_cpoptions = &cpoptions
  set cpoptions-=F
  let l:tmpfile = tempname()
  let l:old_modified = &modified
  exe "silent write " . l:tmpfile
  let &modified = l:old_modified
  new
  let l:cmd = g:BeanShell_Cmd . " " . l:tmpfile
  exe "1,$!" . l:cmd
  call s:BeanShell_ConfigureOutputWindow()
  call delete( l:tmpfile )
  let &cpoptions = l:old_cpoptions
endfunction "}}}

" Function:     BeanShell_ConfigureOutputWindow
" Description:  Configures the output window for BeanShell.
function! s:BeanShell_ConfigureOutputWindow() "{{{1
  set ts=8 buftype=nofile
  normal $G
  while getline(".") == ""
    normal dd
  endwhile
  normal 1G
endfunction "}}}

exe 'nnoremap <unique> <silent> ' . BeanShell_Key . 
            \ " :call <SID>BeanShell_Run()<CR>"
