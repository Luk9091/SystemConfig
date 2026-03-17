return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    vim.g.vimtex_view_method = "zathura"
    -- vim.g.vimtex_view_general_viewer = 'evince'

    vim.g.vimtex_compiler_latexmk = {
        out_dir = 'build',
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          -- "-interaction=nonstopmode",
        },
    }

    -- Dont show warning
    vim.g.vimtex_quickfix_open_on_warning = 0
  end
}
