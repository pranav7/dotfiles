return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      claude_path = "/Users/pranav/.claude/local/claude",  -- Use full path instead of alias
    })
  end,
}
