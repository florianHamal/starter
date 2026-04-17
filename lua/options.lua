require "nvchad.options"

-- add yours here!

vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 5

-- force Neovim to use fish for :! and terminal
local fish = vim.fn.exepath "fish"
if fish ~= "" then
  vim.opt.shell = fish
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
