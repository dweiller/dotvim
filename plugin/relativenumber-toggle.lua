local augroup = vim.api.nvim_create_augroup("relativenumber-toggle", {})

local events_on = {
    "BufEnter",
    "FocusGained",
    "InsertLeave",
    "CmdlineLeave",
    "WinEnter",
}

local function invert_event(event)
    local i, _ = string.find(event, "Gained$")
    if i ~= nil then
        return string.sub(event, 1, i-1) .. "Lost"
    end

    i, _ = string.find(event, "Lost$")
    if i ~= nil then
        return string.sub(event, 1, i-1) .. "Gained"
    end

    i, _ = string.find(event, "Enter$")
    if i ~= nil then
        return string.sub(event, 1, i - 1) .. "Leave"
    end

    i, _ = string.find(event, "Leave$")
    if i ~= nil then
        return string.sub(event, 1, i - 1) .. "Enter"
    end

    error("event '" .. event .. "' cannot be inverted")
end

local events_off = {}
for i, v in ipairs(events_on) do
    events_off[i] = invert_event(v)
end

local events_off = {
    "BufLeave",
    "FocusLost",
    "InsertEnter",
    "CmdlineEnter",
    "WinLeave",
}

vim.api.nvim_create_autocmd(events_on, {
    pattern = "*",
    group = augroup,
    callback = function()
        if vim.o.number
            and vim.api.nvim_get_mode().mode ~= "i"
            and not vim.o.relativenumber then
            vim.o.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd(events_off, {
    pattern = "*",
    group = augroup,
    callback = function()
        if vim.o.number then
            vim.o.relativenumber = false
        end
    end,
})
