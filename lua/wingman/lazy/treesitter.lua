return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- Use main instead of master
  build = ":TSUpdate",
  lazy = false,
  main = "nvim-treesitter.config", -- Updated main module
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "query", "python", "c", "cpp", "markdown", "json" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    local status_ok, treesitter = pcall(require, "nvim-treesitter.config")
    if not status_ok then
      return
    end
    treesitter.setup(opts)
  end,
}   
