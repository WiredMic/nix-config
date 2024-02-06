local M = {}

M.dap = {
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Toggle breakpoint",
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.rust = {
  n = {
    ["<localleader>rr"] = {
      -- function ()
      --   if vim.bo.filetype == "rust" then
      --   vim.cmd("RustRun")
      --   end
      -- end,
      "<cmd>RustRun<CR>",
      "Run the Rust compiler",
    },
  },
}

-- M.vimtex = {
--   n = {
--     ["<leader>ll"] = {
--       function ()
--         if vim.bo.filetype == "tex" then
--         vim.cmd("VimtexCompile")
--         end
--       end,
--       "Compile the LaTeX document",
--     },
--     ["<leader>lt"] = {
--       function ()
--         if vim.bo.filetype == "tex" then
--         vim.cmd("VimtexTocToggle")
--         end
--       end,
--       "Toggle table of contense"
--     },
--     ["<leader>li"] = {
--       function ()
--         if vim.bo.filetype == "tex" then
--         vim.cmd("VimtexInfo")
--         end
--       end,
--     },
--   }
-- }

M.undo = {
  n = {
    ["<A-u>"] = {
      "<cmd>UndotreeToggle<CR>",
      "Toggle Undotree"
    },
  },
}

M.open = {
  n = {
    ["gx"] = {
      function ()
        if vim.fn.has("mac") == 1 then
          vim.cmd([[call jobstart(["open", expand("<cfile>")], {"detach": v:true})]]);
        elseif vim.fn.has("unix") == 1 then
          vim.cmd([[execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)]]);
        elseif IsWSL() == 1 then
          vim.cmd([[execute '!wslview ' .. shellescape(expand('<cfile>'), v:true)]]);
        else
          vim.cmd([[lua print("Error: gx is not supported on this OS!")]]);
        end
      end,
      "Open URL under curser"
    }
  }
}

function IsWSL()
  if vim.fn.has("unix") then
    local lines = io.open("/proc/version", "r");
    if (lines[1] ~= nil and lines[1] == "Microsoft") then
      return 1
    end
  end
  return 0
end

return M
