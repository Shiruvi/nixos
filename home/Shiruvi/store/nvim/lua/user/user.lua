return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        cmd = { "clangd" },
      },
      cmake_language_server = {
        cmd = { "cmake-language-server" },
      },
    },
  },
}
