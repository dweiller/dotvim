--[[
 Neovim plugin for highlighting matches under cursor

 This is an adaptation of Damian Conway's HLNext plugin
 (see github.com/thoughtstream/Damian-Conway-s-Vim-Setup/plugin/hlnext.vim)
--]]

local M = {}

local ns_id = vim.api.nvim_create_namespace('HLNext')

function M.HLNextOff()
    --vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    if (vim.w.HLNext_m_id ~= nil)
    then
        vim.fn.matchdelete(vim.w.HLNext_m_id)
        vim.w.HLNext_m_id = nil
    end
end

function M.HLNext()
    M.HLNextOff()
    local pattern = '\\%#\\%(' .. vim.fn.getreg('/') .. '\\)'
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local m_start = vim.fn.searchpos(pattern, 'zcn')[2]
    local m_end = vim.fn.searchpos(pattern, 'zcen')[2]
    if (m_start >= 0) then
        vim.w.HLNext_m_id = vim.fn.matchaddpos("HLNext", {{ line_num, m_start, m_end - m_start + 1}})
        --nvim_buf_add_highlight is presumably preferred, but as of 0.5 it seems to
        --have lower precedence than the /search highlighting
        --vim.api.nvim_buf_add_highlight(0, ns_id, 'HLNext', line_num - 1, m_start - 1, m_end)
    end
    vim.cmd([[
        augroup plugin-HLNext
            autocmd! CursorMoved * ++once :lua require('hlnext').HLNextOff()
        augroup END
    ]])
end

return M
