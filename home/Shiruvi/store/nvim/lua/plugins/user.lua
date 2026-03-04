return {
  "neovim/nvim-lspconfig",
  opts = {
    -- 1. Отключаем установку серверов через Mason.
    -- Серверы уже установлены в NixOS и лежат в PATH.
    mason = {
      ensure_installed = {},
    },

    -- 2. Включаем нужные серверы.
    -- Ключи должны совпадать с названиями в lspconfig.
    servers = {
      -- Nix (для файлов .nix)
      nil_ls = {},

      -- Lua (для конфигурации самого Neovim/AstroNvim)
      -- lua_ls = {
        -- settings = {
          -- Lua = {
            -- diagnostics = {
              -- globals = { "vim", "AstroNvim" },
            -- },
            -- workspace = {
              -- library = {
                -- vim.fn.expand "$VIMRUNTIME",
                -- "${config_path}/lua", -- Подсказки для плагинов AstroNvim
              -- },
            -- },
          -- },
        -- },
      -- },

    },

    format_on_save = {
      enabled = true,
      timeout = 1000,
    },
  },
}
