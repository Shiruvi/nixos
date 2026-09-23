return {
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "clangd", "nil_ls", "cmake-language-server" },
      config = {
        clangd = {
          cmd = { "clangd" },
        },

        nil_ls = {
          cmd = { "nil" },
        },
        --TODO: сделать рабочий cmake lsp

        -- cmake-language-server = {
          -- cmd = { "cmake-language-server" },
        -- },
      },
    },
  },
}
