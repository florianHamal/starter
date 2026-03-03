require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>dgf", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })

map("n", "<leader>dg", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Workspace Diagnostics" })

map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>cf", function()
  require("conform").format()
end, { desc = "Format with conform" })


map("n", "gor", "<cmd>Telescope lsp_references<cr>", { desc = "LSP: Go to references" })
map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "LSP: Go to implementation" })


map("n", "<leader>gsf", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Git Stage hunk" })
map("n", "<leader>gsb", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Git Stage Buffer" })
map("n", "<leader>guh", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Git undo stage" })
map("n", "<leader>guf", "<cmd>Gitsigns reset_buffer_index<cr>", { desc = "Git: Unstage File" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git view diff" })

-- Reset (Revert) Hunk: Only revert the block under the cursor
map("n", "<leader>grh", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Git reset hunk" })

-- Reset (Revert) Buffer: Revert the ENTIRE file to its last commit state
map("n", "<leader>grb", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Git reset buffer" })


map("n", "<leader>gh", "<cmd>Telescope git_commits<cr>", { desc = "Git commit history" })
map("n", "<leader>gfh", "<cmd>Telescope git_bcommits<cr>", { desc = "Buffer git commit history" })

map("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Git blame window" })


map("n", "<A-Up>", "<cmd>resize -2<cr>", { desc = "Window: Resize Up" })
map("n", "<A-Down>", "<cmd>resize +2<cr>", { desc = "Window: Resize Down" })
map("n", "<A-Left>", "<cmd>vertical resize +2<cr>", { desc = "Window: Resize Left" })
map("n", "<A-Right>", "<cmd>vertical resize -2<cr>", { desc = "Window: Resize Right" })

-- Visual Mode: Revert only the lines you have selected
map("v", "<leader>rh", function()
  require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
end, { desc = "Git reset selected hunk" })


map("n", "<leader>daf", function()
  -- Save the file first so the formatter sees the latest changes
  vim.cmd("silent write")
  -- Run the external command on the current file (%)
  vim.cmd("!fvm dart format lib test --line-length 120 %")
  
  -- Reload the file in the buffer to show the formatted version
  vim.cmd("edit!")
end, { desc = "FVM: Dart Format current file" })---- Ask OpenCode (the main chat/prompt)
--map({ "n", "x" }, "<C-a>", function()
--  require("opencode").ask("@this: ", { submit = true })
--end, { desc = "OpenCode: Ask AI" })
--
---- Select from OpenCode Actions (Prompts like explain, fix, etc.)
--map({ "n", "x" }, "<C-x>", function()
--  require("opencode").select()
--end, { desc = "OpenCode: Actions" })
--
---- Toggle the OpenCode Terminal/UI
--map({ "n", "t" }, "<C-.>", function()
--  require("opencode").toggle()
--end, { desc = "OpenCode: Toggle UI" })
--
---- Use 'go' as an operator (e.g., 'goip' to send a paragraph to AI)
--map("n", "<C-o>", function()
--  return require("opencode").operator("@this ")
--end, { desc = "OpenCode: Send range to AI", expr = true })

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })


-- Quick Commit (Opens a prompt for the message)
map("n", "<leader>gc", function()
  local msg = vim.fn.input("Commit Message: ")
  if msg ~= "" then
    vim.cmd("!git commit -m '" .. msg .. "'")
  end
end, { desc = "Git Quick Commit" })

-- map({ "n", "i", "v" }, "<C-s>", "<cm > w <cr>")
