-- format
return {
  "stevearc/conform.nvim",
  event = { "LspAttach", "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    notify_on_error = true,

    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt", "goimports_reviser" },
      json = { "jq" },
      yaml = { "yamlfmt" },
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "deno_fmt" },
      toml = { "taplo" },
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format" }
        else
          return { "isort", "black" }
        end
      end,
    },

    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true, go = true }

      if disable_filetypes[vim.bo[bufnr].filetype] then
        return
      end

      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,

    formatters = {
      goimports_reviser = function(bufnr)
        local project_root = vim.fn.getcwd()

        -- Determine the project root using LSP
        local lsp_clients = vim.lsp.get_clients { bufnr = bufnr }
        for _, client in ipairs(lsp_clients) do
          if client.config.root_dir then
            project_root = client.config.root_dir
            break
          end
        end

        local project_name = vim.fn.fnamemodify(project_root, ":t")

        return {
          command = "goimports-reviser",
          stdin = true,
          inherit = false,
          args = {
            "-company-prefixes",
            "gitlab.id.vin",
            "-project-name",
            project_name,
            "-imports-order",
            "std,general,company,project",
            "-rm-unused",
            "-output",
            "stdout",
            "$FILENAME",
          },
        }
      end,
    },
  },
}
