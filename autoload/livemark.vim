scriptencoding utf-8

let s:root_dir = expand('<sfile>:p:h:h')
let s:module_path = s:root_dir . '/livemark2/livemark2'
let s:initialized_preview = 0
let s:theme = ""

function! s:send(msg) abort
  let handle = ch_open('localhost:' . g:livemark_vim_port, {'mode': 'json', 'waittime': 3000, 'timeout': 0})
  call ch_sendexpr(handle, a:msg)
  call ch_close(handle)
endfunction

function! livemark#move(cmd) abort
  echo 'LiveMark Browser Mode: ' . a:cmd
  let msg = {}
  let msg.line = line('w0')
  let msg.event = 'move'
  let msg.command = a:cmd
  call s:send(msg)
endfunction

noremap <Plug>LivemarkTop :call livemark#move('top')<CR>
noremap <Plug>LivemarkBottom :call livemark#move('bottom')<CR>
noremap <Plug>LivemarkUp :call livemark#move('up')<CR>
noremap <Plug>LivemarkDown :call livemark#move('down')<CR>
noremap <Plug>LivemarkPageUp :call livemark#move('page_up')<CR>
noremap <Plug>LivemarkPageDown :call livemark#move('page_down')<CR>
noremap <Plug>LivemarkHalfUp :call livemark#move('half_up')<CR>
noremap <Plug>LivemarkHalfDown :call livemark#move('half_down')<CR>

function! livemark#browser_mode() abort
  nmap <buffer> gg <Plug>LivemarkTop
  nmap <buffer> G  <Plug>LivemarkBottom
  nmap <buffer> k  <Plug>LivemarkUp
  nmap <buffer> j  <Plug>LivemarkDown
  nmap <buffer> <C-u> <Plug>LivemarkHalfUp
  nmap <buffer> <C-d> <Plug>LivemarkHalfDown
  nmap <buffer> <C-b> <Plug>LivemarkPageUp
  nmap <buffer> <C-f> <Plug>LivemarkPageDown
  nnoremap <buffer><nowait> <Esc> :call livemark#browser_mode_exit()<CR>
endfunction

function! livemark#browser_mode_exit() abort
  nunmap <buffer> gg
  nunmap <buffer> G
  nunmap <buffer> k
  nunmap <buffer> j
  nunmap <buffer> <C-u>
  nunmap <buffer> <C-d>
  nunmap <buffer> <C-b>
  nunmap <buffer> <C-f>
  nunmap <buffer> <Esc>
  echo 'LiveMark Browser Mode Exit'
endfunction

function! livemark#move_cursor() abort
  if !s:initialized_preview
    call livemark#update_preview()
    let s:initialized_preview = 1
    autocmd! livemark CursorMoved <buffer>
    return
  endif
endfunction

function! livemark#update_preview() abort
  let msg = {}
  let msg.text = getline(0, '$')
  if g:livemark_disable_scroll
    let msg.line = -1
  else
    let msg.line = line('w0')
  endif
  let msg.ext = &filetype
  let msg.event = 'update'
  call s:send(msg)
endfunction

function! s:start_server() abort
  let l:options = ' --browser "' . g:livemark_browser . '"'
        \     . ' --port ' . g:livemark_browser_port
        \     . ' --vim-port ' . g:livemark_vim_port
        \     . ' --open-browser'

  if len(s:theme)
    let l:options .= ' --theme ' . s:theme
  elseif len(g:livemark_theme)
    let l:options .= ' --theme ' . g:livemark_theme
  endif

  if len(g:livemark_highlight_theme)
    let l:options .= ' --highlight-theme "' . g:livemark_highlight_theme . '"'
  endif

  let cmd = g:livemark_python . ' ' . s:module_path . l:options
  let s:server_job = job_start(cmd)
endfunction

function! s:stop_server() abort
  if job_status(s:server_job) ==# 'run'
    call job_stop(s:server_job)
  endif
endfunction

function! s:check_features() abort
  if !has('channel') || !has('job')
    echoerr 'Livemark requires "channel" and "job".'
    return 1
  endif
  return 0
endfunction

function! livemark#enable_livemark(...) abort
  if s:check_features() | return | endif
  if len(a:000) > 0
    let s:theme = a:1
  endif

  if !has('channel') || g:livemark_force_pysocket
    call s:initialize_pysocket()
  endif
  augroup livemark
    autocmd!
    autocmd TextChanged,TextChangedI <buffer> call livemark#update_preview()
    autocmd CursorMoved <buffer> call livemark#move_cursor()
    autocmd VimLeave * call s:stop_server()
  augroup END
  call s:start_server()
  let s:theme = ""
endfunction

function! livemark#disable_livemark() abort
  augroup livemark
    autocmd!
  augroup END
  call s:stop_server()
endfunction

" vim set\ ts=2\ sts=2\ sw=2\ et
