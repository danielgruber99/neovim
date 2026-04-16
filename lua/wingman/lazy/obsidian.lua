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
    local function daily_note_timestamp(note_id)
      local y, m, d = note_id:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
      if y and m and d then
        return os.time({
          year = tonumber(y),
          month = tonumber(m),
          day = tonumber(d),
          hour = 12,
        })
      end
      return os.time()
    end

    local function merge_tags(existing_tags, extra_tags)
      local seen, merged = {}, {}

      for _, tag in ipairs(existing_tags or {}) do
        if not seen[tag] then
          seen[tag] = true
          table.insert(merged, tag)
        end
      end

      for _, tag in ipairs(extra_tags) do
        if not seen[tag] then
          seen[tag] = true
          table.insert(merged, tag)
        end
      end

      return merged
    end

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
      note_frontmatter_func = function(note)
        local ts = daily_note_timestamp(note.id)
        local time_tags = {
          "year/" .. os.date("%Y", ts),
          "month/" .. os.date("%m", ts),
          "CW" .. os.date("%V", ts),
        }

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = merge_tags(note.tags, time_tags),
        }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for key, value in pairs(note.metadata) do
            out[key] = value
          end
        end

        return out
      end,
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
