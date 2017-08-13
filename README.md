# vim-livemark

Real-time markdown preview plugin for vim.

# !!! NOT STABLE !!!

## Requirements

Latest Vim which has `+channel` and `+job` features.

Python 3.5+ and [livemark2](https://github.com/miyakogi/livemark2) are also required to be installed in your python.

To install them:

```
pip3 install -U git+https://github.com/miyakogi/livemark2
```

Or,

```
python3 -m pip intsall -U git+https://github.com/miyakogi/livemark2
```

## Install

```
git clone https://github.com/miyakogi/vim-livemark
```

## Usage

Open markdown file and execute `:LiveMark`.
This command opens browser window and starts real-time preview.

To stop previewing, execute `:LiveMarkDisable` command.

### Theming

By adding theme-name as an argument of the `:LiveMark` command, livemark change theme of the preview window.
To see available themes, press `<Tab>` key after `:LiveMark ` on vim.
Default theme is `skyblue`.

Note: Former version supported use-define js/css files, but current version does not support this feature.

### Scrolling Browser

LiveMark.vim has **BrowserMode**.

When execute `:LiveMarkBrowserMode`, some keys (`j/k/<C-d>/<C-u>/<C-f>/<C-b>/gg/G`) become to move browser window, not vim.
To exit this mode, press `<Esc>` key or execute `:LiveMarkBrowserModeExit`.

TODO: prepare screen cast.

Note: Former version has *cursor sync* feature, but its removed now.

## Configuration

#### Python binary

This plugin uses python3 installed in your path by default.
If you want to use another python, you can specify the path as follows:

```vim
let g:livemark_python = '/path/to/python/binary'  " default 'python3'
```

#### Browser

By default, this plugin use system's default browser to show preview.
To use other browser, for example, firefox, set `g:livemark_browser` variable in your vimrc.

```vim
let g:livemark_browser = 'firefox'
```

This value is passed to python's webbrowser module.
Available browsers and corresponding names are listed [here](https://docs.python.org/3/library/webbrowser.html#webbrowser.register).

#### Connections

For now, this plugin uses two ports; one for tornado web-server (8089), and the other for sending markdown texts from vim (8090).
If you want to change these port numbers, add the following lines to your vimrc and change values as you like.

```vim
let g:livemark_browser_port = 8089
let g:livemark_vim_port = 8090
```

#### Default theme

Default theme can change via `g:livemark_theme` option.
The following setting change default theme to `bootstrap3`.

```vim
let g:livemark_theme = "bootstrap3"
```

This setting can be overridden by `:LiveMark` command's argument.

#### Syntax highlighting

LiveMark.vim supports code blocks and syntax highlighting.
If you change theme of the code block, add the below option.

```vim
let g:livemark_highlight_theme = 'friendly'  " default ''
```

To list all available themes, run below command in shell.

```sh
python3 -c "import pygments.styles; print(pygments.styles.STYLE_MAP.keys())"
```

## License

[MIT License](https://github.com/miyakogi/livemark.vim/blob/master/LICENSE)
