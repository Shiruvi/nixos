return {
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "clangd", "cmake" },
      config = {
        clangd = {
          cmd = { "clangd" },
        },
        cmake = {
          cmd = { "cmake-language-server" },
        },
      },
    },
  },
}
