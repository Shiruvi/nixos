return {
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "clangd", "nil_ls" },
      config = {
        clangd = {
          cmd = { "clangd" },
        },

        nil_ls = {
          cmd = { "nil" },
        },
      },
    },
  },
}
