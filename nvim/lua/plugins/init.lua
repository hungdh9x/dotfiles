return {
  {
    "folke/which-key.nvim",
    enabled = true,
  },

  -- Autosave, auto-format
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local opts = require "nvchad.configs.nvimtree"
      opts.view.side = "right"
      return opts
    end,
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Sticky function name in header
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 20, -- Maximum number of lines to show for a single context
            trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
            zindex = 20, -- The Z-index of the context window
            on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
          }
        end,
      },
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- Install LSP server into local
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        -- for golang
        "gopls",
        "golangci-lint",
      },
    },
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  {
    "folke/trouble.nvim",
    ft = "go",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Parser and highlight code
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "go",
        "bash",
        "regex",
        "markdown",
        "markdown_inline",
        "dockerfile",
      },
    },
  },

  -- Like easy-motion, quick move by label
  {
    "smoka7/hop.nvim",
    -- event = "VeryLazy",
    config = function()
      require "configs.hop"
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require "configs.flash"
    end,
  },

  -- Navigate between Neovim vs tmux panel
  {
    "alexghergh/nvim-tmux-navigation",
    cmd = { "NvimTmuxNavigateLeft", "NvimTmuxNavigateRight", "NvimTmuxNavigateUp", "NvimTmuxNavigateDown" },
    config = function()
      require("nvim-tmux-navigation").setup {
        disable_when_zoomed = true,
      }
    end,
  },

  -- Git integration
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilterCurrentFile", "LazyGitFilter" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Beauty notification
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require "configs.noice"
      require "configs.notify"
    end,
  },

  -- Mark and quick jump to bookmark file
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "configs.harpoon"
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Collection of various small independent plugins/modules
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup { n_lines = 500 }
      -- require("mini.surround").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    opts = function()
      local conf = require "nvchad.configs.telescope"
      conf.extensions_list = { "themes", "terms", "fzf" }

      -- display {filename - basePath} instead full {filePath}
      local function filenameFirst(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        end
        return string.format("%s\t\t%s", tail, parent)
      end
      conf.defaults.path_display = filenameFirst

      return conf
    end,
  },

  -- Highlight instance under cursor follow by treesitter
  {
    "RRethy/vim-illuminate",
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
    config = function()
      require "configs.illuminate"
    end,
  },
}
