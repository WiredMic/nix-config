local M = {}

M.vimtex = {
  n = {
    ["<leader>ll"] = {
      "<cmd>VimtexCompile<cr>",
      "Compile the LaTeX document"
    },
    ["<leader>lt"] = {
      "<cmd>VimtexTocToggle<cr>",
    },
    ["<leader>li"] = {
      "<cmd>Vimtex<cr>",
    },
    -- :VimtexInfo: show all relevant info about current LaTeX project.
    -- :VimtexTocOpen: show table of contents window
    -- :VimtexTocToggle: toggle table of contents window
    -- :VimtexCompile: Compile the current LaTeX source file and opens the viewer after successful compilation.
    -- :VimtexStop: Stop compilation for the current project.
    -- :VimtexClean: clean auxiliary files generated in compliation process.
  }
}
return M
