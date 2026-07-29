return {
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "clangd", "cmake-language-server", "tinymist", "openscad-lsp", "nil" },
      config = {
        clangd = {
          cmd = { "clangd" },
        },
        cmake-language-server = {
          cmd = { "cmake-language-server" },
        },
        tinymist = {
          cmd = { "tinymist" },
        },
        nil = {
          cmd = { "nil" },
        },
        openscad-lsp = {
          cmd = { "openscad-lsp" },
        },
      },
    },
  },
}
