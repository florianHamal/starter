require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>lf", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })

map("n", "<leader>fw", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Workspace Diagnostics" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
