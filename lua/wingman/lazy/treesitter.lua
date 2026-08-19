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
    local legacy_configs = {
      setup = function(new_opts)
        opts = vim.tbl_deep_extend("force", opts, new_opts or {})
      end,
      get_module = function(name)
        return opts[name] or {}
      end,
      is_enabled = function(name, lang, _)
        local module = opts[name]
        if type(module) ~= "table" or module.enable ~= true then
          return false
        end

        local disabled = module.disable
        if type(disabled) == "function" then
          return not disabled(lang)
        end
        if type(disabled) == "table" then
          return not vim.tbl_contains(disabled, lang)
        end

        return true
      end,
    }
    package.preload["nvim-treesitter.configs"] = function()
      return legacy_configs
    end
    package.loaded["nvim-treesitter.configs"] = legacy_configs

    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok then
      if type(parsers.ft_to_lang) ~= "function" then
        parsers.ft_to_lang = function(ft)
          if vim.treesitter.language and type(vim.treesitter.language.get_lang) == "function" then
            return vim.treesitter.language.get_lang(ft)
          end
          return ft
        end
      end

      if type(parsers.get_parser) ~= "function" then
        parsers.get_parser = function(bufnr, lang)
          return vim.treesitter.get_parser(bufnr, lang)
        end
      end
    end

    local status_ok, treesitter = pcall(require, "nvim-treesitter.config")
    if not status_ok then
      return
    end
    treesitter.setup(opts)
  end,
}   
