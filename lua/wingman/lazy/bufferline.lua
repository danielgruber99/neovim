return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { "<M-j>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<M-k>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
  },
  config = function()
    vim.opt.termguicolors = true
    require('bufferline').setup({
      options = {
        mode = "buffers",
        always_show_bufferline = true,
        show_tab_indicators = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    })
  end
}
