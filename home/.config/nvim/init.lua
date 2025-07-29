vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")
require("config.mappings")
require("config.autocmds")

local options = {
	number = true,
	relativenumber = true,
	clipboard = "unnamed,unnamedplus",
	mouse = "a",
	undodir = "/tmp/.nvimdid",
	undofile = true,
	confirm = true,
    signcolumn = "yes:1",
}



for key, value in pairs(options) do
	vim.o[key] = value
end
