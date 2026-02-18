require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>lf", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })

map("n", "<leader>fw", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Workspace Diagnostics" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


map("n", "<leader>gsf", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Git stage hunk" })
map("n", "<leader>gsb", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Git Stage Buffer" })
map("n", "<leader>gr", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Git undo stage" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git view diff" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

-- Quick Commit (Opens a prompt for the message)
map("n", "<leader>gc", function()
  local msg = vim.fn.input("Commit Message: ")
  if msg ~= "" then
    vim.cmd("!git commit -m '" .. msg .. "'")
  end
end, { desc = "Git Quick Commit" })

-- map({ "n", "i", "v" }, "<C-s>", "<cm > w <cr>")
