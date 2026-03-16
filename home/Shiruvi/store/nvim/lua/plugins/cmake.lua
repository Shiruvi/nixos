return{
  require("lspconfig").cmake_language_server.setup{
  cmd = { "cmake-language-server" },
  }
}
