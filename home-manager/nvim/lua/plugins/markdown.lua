return {
  {
    "arto-app/arto.vim",
    ft = "markdown",
    init = function()
      -- Nix store path is dynamic; resolve from arto binary in PATH
      local arto_bin = vim.fn.exepath("arto")
      if arto_bin ~= "" then
        local real_path = vim.fn.resolve(arto_bin)
        local app_path = real_path:match("(.+)/Contents/MacOS/arto$")
        if app_path then
          vim.g.arto_path = app_path
        end
      end
    end,
    keys = {
      { "<leader>mp", "<cmd>Arto<cr>", desc = "Preview markdown in Arto", ft = "markdown" },
    },
  },
}
