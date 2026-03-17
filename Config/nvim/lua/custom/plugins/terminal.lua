return {
  {

    'local-terminal',
    dir = vim.fn.stdpath 'config',
    keys = {
      {
        '<F6>',
        function()
          local terminal_size = 15
          if not _G._terminal_buf or not vim.api.nvim_buf_is_valid(_G._terminal_buf) then
            vim.cmd 'botright split | terminal'
            _G._terminal_buf = vim.api.nvim_get_current_buf()
            _G._terminal_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_height(_G._terminal_win, terminal_size)
          else
            local win_id = vim.fn.bufwinid(_G._terminal_buf)
            if win_id ~= -1 then
              vim.api.nvim_win_hide(win_id)
            else
              vim.cmd('botright sbuf ' .. _G._terminal_buf)
              local new_win = vim.api.nvim_get_current_win()
              vim.api.nvim_win_set_height(new_win, terminal_size)
              vim.cmd 'startinsert'
            end
          end
        end,
        mode = { 'n', 't' },
        desc = 'Terminal: Toggle',
      },
    },
    config = function()
      -- np. autokomendę, która automatycznie przechodzi w tryb insert po otwarciu
      vim.api.nvim_create_autocmd('TermOpen', {
        group = vim.api.nvim_create_augroup('custom-terminal-setup', { clear = true }),
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.spell = false
          vim.cmd('startinsert')
        end,
      })
    end,
  },
}
