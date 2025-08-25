return {
  -- Tab out functionality for insert mode
  {
    "tab-out",
    dir = vim.fn.stdpath("config"),
    config = function()
      -- Smart tab out function
      local function tab_out()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        
        -- Characters we want to tab out of
        local closing_chars = { ")", "}", "]", '"', "'", "`" }
        
        -- Check if cursor is before any closing character
        if col < #line then
          local next_char = line:sub(col + 1, col + 1)
          for _, char in ipairs(closing_chars) do
            if next_char == char then
              -- Move cursor past the closing character
              vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col + 1 })
              return
            end
          end
        end
        
        -- If no closing character found, use default Shift+Tab behavior (unindent)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, true, true), "n", false)
      end
      
      -- Map Shift+Tab in insert mode only
      vim.keymap.set("i", "<S-Tab>", tab_out, { desc = "Tab out of closing character" })
    end,
  },
}