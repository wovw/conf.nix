return {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_format = 'fallback' })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    config = function()
        require("conform").setup({
            notify_on_error = false,
            notify_no_formatters = false,
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = 'never'
                else
                    lsp_format_opt = 'fallback'
                end
                return {
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,
            formatters_by_ft = {
                typescript = { "prettierd", "prettier", "eslint_d" },
                javascript = { "prettierd", "prettier", "eslint_d" },
                typescriptreact = { "prettierd", "prettier", "eslint_d" },
                javascriptreact = { "prettierd", "prettier", "eslint_d" },
                json = { "prettierd", "prettier", },
                html = { "prettierd", "prettier", },
                css = { "prettierd", "prettier", },

                lua = { "stylua" },
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                go = { "goimports", "gofmt" },
                rust = { "rustfmt" },

                ["_"] = { "trim_whitespace" },
            },
            formatters = {
                eslint_d = {
                    -- Enable autofix by default
                    prepend_args = { "--fix" },
                    -- Ensure eslint_d uses local config
                    cwd = require("conform.util").root_file({
                        ".eslintrc",
                        ".eslintrc.js",
                        ".eslintrc.json",
                    }),
                },
                prettierd = {
                    -- Ensure prettierd uses local config
                    cwd = require("conform.util").root_file({
                        ".prettierrc",
                        ".prettierrc.js",
                        ".prettierrc.json",
                        "prettier.config.js",
                    }),
                },
            }
        })
    end,
}