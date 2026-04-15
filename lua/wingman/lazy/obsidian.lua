return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",
  cmd = {
    "ObsidianQuickSwitch",
    "ObsidianSearch",
    "ObsidianNew",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianBacklinks",
    "ObsidianLinks",
    "ObsidianRename",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local vault_path = vim.fn.expand("~/Documents/Obsidian Vault")

    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = vault_path,
        },
      },
      notes_subdir = "notes",
      new_notes_location = "notes_subdir",
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      daily_notes = {
        folder = "daily",
      },
      templates = {
        folder = "templates",
      },
      picker = {
        name = "telescope.nvim",
      },
      ui = {
        conceallevel = 1,
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 1
      end,
    })

    vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian quick switch" })
    vim.keymap.set("n", "<leader>of", "<cmd>ObsidianSearch<CR>", { desc = "Obsidian search" })
    vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Obsidian new note" })
    vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Obsidian today note" })
    vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<CR>", { desc = "Obsidian yesterday note" })
    vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Obsidian backlinks" })
    vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Obsidian links" })
    vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Obsidian rename note" })
  end,
}
