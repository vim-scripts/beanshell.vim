" $Id: beanshell.vim,v 1.4 2006/05/21 14:08:43 henry Exp $
"
" Name:             BeanShell plugin
" Description:      Runs the current buffer using BeanShell
" Author:           Henry So, Jr. <henryso at panix dot com>
" Version:          1.2
" Modified:         21 May 2006
" License:          Released into the public domain.
"
" Usage:            Copy this file into the plugins directory if you want it
"                   to be automatically sourced.  Otherwise, :source it when
"                   you need it.
"
"                   To invoke BeanShell, either issue the command :BeanShell
"                   or enter the appropriate key command (by default, this is
"                   <Leader>br).
"
"                   The :BeanShell command takes a range of lines upon which
"                   to act.  If no range is given, the entire file will be
"                   executed.  The key command works from within a visual
"                   block to execute the selected lines.  If not within a
"                   visual block, the entire file will be executed.
"
" Configuration:    The default command for running BeanShell is
"                   "java bsh.Interpreter".  To change this command, use :let
"                   to set the BeanShell_Cmd variable to the command you want
"                   to use.  For example:
"
"                       :let BeanShell_Cmd = "/path/to/java bsh.Interpreter"
"
"                   The default key command to invoke BeanShell is <Leader>br.
"                   To change this keymapping, use :map to assign the
"                   key you want to <Plug>BeanShell.  For example:
"
"                       :map <S-F3> <Plug>BeanShell
"
" Acknowledgments:  This script owes its roots and style to Jamis Buck's
"                   sqlplus.vim, Yegappan Lakshmanan's taglist.vim, and
"                   Anthony Kruize / Michael Geddes's ShowMarks.  Ronald
"                   contributed the idea of executing selected lines from a
"                   visual block.

if exists('loaded_beanshell')
  finish
endif
let loaded_beanshell = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

" set-up defaults if necessary
if !exists('BeanShell_Cmd')
  let BeanShell_Cmd = "java bsh.Interpreter"
endif

if !hasmapto("<Plug>BeanShell")
  map <unique> <Leader>br <Plug>BeanShell
endif

" Function:     BeanShell_Run
" Description:  Runs BeanShell on the current buffer, opening a new window
"               with the output.
function! s:BeanShell_Run() range "{{{1
  let l:old_cpoptions = &cpoptions
  set cpoptions-=F
  let l:tmpfile = tempname()
  let l:old_modified = &modified
  exe "silent " . a:firstline . "," . a:lastline . " write " . l:tmpfile
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

" Set up entry points: the command, the keymapping, and the menu.
if !exists(":BeanShell")
    command -nargs=0 -range=% BeanShell :<line1>,<line2>call <SID>BeanShell_Run()
endif

noremap <unique> <script> <Plug>BeanShell <SID>BeanShell_Run

noremenu <script> Plugin.Invoke\ BeanShell <SID>BeanShell_Run

noremap <silent> <SID>BeanShell_Run :<C-U>1,$call <SID>BeanShell_Run()<CR>
vnoremap <silent> <SID>BeanShell_Run :call <SID>BeanShell_Run()<CR>

let &cpoptions = s:save_cpoptions

" vim: set sts=2 sw=2:
