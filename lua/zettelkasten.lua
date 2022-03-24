local config = {}

local no_root_msg = 'zettelkasten: root not set, either set the root option in setup() or ensure the $ZETTELKASTEN_ROOT environment variable is set'
--[[
  Extract the link path of a link, and return it along with its type
--]]
local function get_link(position)
    local pos = position or vim.api.nvim_win_get_cursor(0)
    local row = pos[1]
    local col = pos[2]

    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]

    local link_pattern = '%[.+%]%((.*)%)'
    local ref_pattern = '%[.+%]%[(.*)%]'
    local internal_pat = '%[.+%]%[%[(.*)%]%]'
    local link_text = nil

    local type

    local found = false
    local i = 0
    while not found do
        local s, e, text = string.find(line, internal_pat, i + 1)
        type = 'internal'
        if (s == nil) then
            s, e, text = string.find(line, link_pattern, i + 1)
            type = 'link'
        end
        if (s == nil) then
            s, e, text = string.find(line, ref_pattern, i + 1)
            type = 'reference'
        end
        if s and e then
            if s - 1 <= col and e - 1 >= col then
                found = true
                link_text = text
            end
        else
            break
        end
        i = s
    end
    return link_text, type
end

local function open_zettel(filename)
    if config.root then
        vim.cmd(':e ' .. config.root .. '/' .. filename .. '.md')
    else
        error(no_root_msg)
    end
end

local function open_external(path)
    vim.api.nvim_command('!xdg-open ' .. path)
end

local function open_reference(path)
    error('zettelkasten: reference links are not yet supported')
end

local function sanitise_filename(unsanitised)
    return string.gsub(unsanitised, ' +', '-')
end

local function create_zettel(unsanitised)
    if unsanitised == nil or unsanitised == '' then
        return
    end
    local filename = sanitise_filename(unsanitised)
    open_zettel(filename)
end

--[[
TODO:
  - setup buffer-local mapping making <c-]> open links
  - compound filetype? markdown.zettel or zettel.markdown
--]]

local function setup_buffer(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(buf, 'tagfunc', "v:lua.require'zettelkasten'.tagfunc")
    vim.api.nvim_buf_set_option(buf, 'tw', 80)
end

local default_config = {
    mapping = {
        follow_link = '<c-]>',
    },
    root = os.getenv('ZETTELKASTEN_ROOT'),
    buffer_setup = nil,
}

local function setup(opts)
    if opts then
        vim.validate {
            mapping = { opts.mapping, 'table', true },
            root = { opts.root, 'string', true },
            buffer_setup = { opts.buffer_setup, 'function', true },
        }
        config = opts
    end
    config = vim.tbl_deep_extend('keep', config, default_config)
    if config.root == nil then
        vim.notify(no_root_msg .. '. Aborting setup.', vim.log.levels.WARN)
        return
    end
    vim.cmd(string.format('autocmd BufNewFile,BufRead %s/*.md lua require"zettelkasten"._setup_buffer()', config.root))
end

local function tagfunc(pat, flags)
    if string.match(flags, 'c') then
        local path, type = get_link()
        if path then
            if type == 'internal' then
                if config.root then
                    tag = {
                        name = path,
                        filename = config.root .. '/' .. path .. '.md',
                        kind = 'internal',
                        cmd = "call cursor(0,0)|",
                    }
                    return { tag }
                else
                    error(no_root_msg)
                end
            elseif type == 'external' then
                return {}
            elseif  type == 'reference' then
                return {}
            end
        end
    end
end

local M = {
    open_link = function()
        local path, type = get_link()
        if path then
            if type == 'internal' then
                open_zettel(path)
            elseif type == 'link' then
                open_external(path)
            else --type == reference
                open_reference(path)
            end
        end
    end,
    open_index = function()
        open_zettel("index")
    end,
    new_zettel = function()
        vim.ui.input({ prompt = "Name of zettel: " }, create_zettel)
    end,
    _setup_buffer = function(buf_num)
        local f = config.buffer_setup or setup_buffer
        f(buf_num)
    end,
    setup = setup,
    tagfunc = tagfunc,
}

return M
