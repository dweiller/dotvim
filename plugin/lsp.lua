local function mapper(mode, key, result, opts, desc)
    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, { buffer = 0, noremap = true, silent = true, desc = desc })
    vim.keymap.set(mode, key, result, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf, noremap = true, silent = true }
        mapper('n', 'gd',    vim.lsp.buf.declaration, opts, "goto declaration (LSP)")
        mapper('n', '<c-k>', vim.lsp.buf.signature_help, opts, "signature help (LSP)")
        mapper('n', '1gD',   vim.lsp.buf.type_definition, opts, "goto type definition (LSP)")
        mapper('n', 'gW',    vim.lsp.buf.workspace_symbol, opts, "list workspace symbols (LSP)")
        mapper('n', '<leader>=', vim.lsp.buf.format, opts, "format (LSP)")

        vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')
    end
})

local language_servers = {
    'ocamllsp',
    'texlab',
    'rust_analyzer',
    'zls',
}

local installed_servers = {}

for _, v in ipairs(language_servers) do
    if (vim.fn.executable(v) == 1) then
        table.insert(installed_servers, v)
    end
end

vim.lsp.enable(installed_servers);

vim.diagnostic.config({ virtual_text = true})
