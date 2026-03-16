return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      mason = {
        ensure_installed = {},
      },
      servers = {
        clangd = {
          cmd = { "clangd" },
        },
      },
    },
  },
    }
