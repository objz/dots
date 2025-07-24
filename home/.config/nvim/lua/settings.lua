local utils = require "utils"

local options = {
    fileencoding = "utf-8",
    autoread = true,
    wrap = true,
    backup = false,
    swapfile = true,
    hlsearch = true,
    incsearch = true,
    showmode = false,
    expandtab = true,
    shiftwidth = 2,
    tabstop = 2,
    softtabstop = 2,
    scrolloff = 5,
    autoindent = true,
    smartindent = true,
    sidescrolloff = 5,
    signcolumn = "yes",
    hidden = true,
    ignorecase = true,
    timeoutlen = 1000,
    shiftround = true,
    smartcase = true,
    splitbelow = true,
    splitright = true,
    number = true,
    relativenumber = true,
    clipboard = "unnamed,unnamedplus",
    cursorline = true,
    mouse = "a",
    cmdheight = 1,
    undodir = "/tmp/.nvimdid",
    undofile = true,
    pumheight = 10,
    laststatus = 3,
    updatetime = 100,
    background = "dark",
    completeopt = "menuone",
    breakindent = true,
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    foldlevelstart = 99,
    foldlevel = 99,
    foldenable = true,
    title = true,
    confirm = true,
}

for key, value in pairs(options) do
    vim.opt[key] = value
end

vim.opt.shortmess:append "c"

vim.cmd [[set fcs=eob:\ ]]
vim.cmd [[filetype plugin indent on]]

utils.set_indent_sizes { go = 4, python = 4, rust = 4, cpp = 4, c = 4, make = 4, lua = 4, java = 4, json = 4 }

vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h9"


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local _notify, notify = pcall(require, "notify")
if _notify then
    vim.notify = notify
end

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- UI theme
require("theme").set_active_theme("sonokai")
