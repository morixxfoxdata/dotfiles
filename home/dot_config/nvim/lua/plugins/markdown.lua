return {
  -- Typora preview keybind
  vim.keymap.set("n", "<leader>mp", function()
    local ft = vim.bo.filetype
    if ft ~= "markdown" then
      print("Not a markdown file")
      return
    end
    local path = vim.fn.expand("%:p")
    vim.fn.system("open -a Typora " .. vim.fn.shellescape(path))
    print("Opened in Typora: " .. vim.fn.expand("%:."))
  end, { desc = "Preview markdown in Typora" }),
}
