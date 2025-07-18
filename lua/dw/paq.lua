--Bootstrap paq

local function download_paq()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
    vim.notify('Downloading paq-nvim', vim.log.levels.INFO)

    local out = vim.fn.system({
        'git',
        'clone',
        '--depth=1',
        'https://github.com/savq/paq-nvim.git',
        install_path,
    })

    vim.notify(out, vim.log.levels.DEBUG)
    download_packages = true
end

local packages = {
    'savq/paq-nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
    'neovim/nvim-lspconfig',
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    'nvim-treesitter/playground',
    {'norcalli/nvim-colorizer.lua', opt=true},
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'b3nj5m1n/kommentary',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'nvim-lua/plenary.nvim',
    'lewis6991/gitsigns.nvim',
    'ggandor/leap.nvim',
    {'nvim-telescope/telescope.nvim', branch = '0.1.x'},
    'ThePrimeagen/harpoon',
    'mbbill/undotree',
    'danymat/neogen',
    'j-hui/fidget.nvim',
    'tpope/vim-sleuth',
    'mfussenegger/nvim-dap',
    'kylechui/nvim-surround',
    {'nordtheme/vim', as = 'nord-theme', opt=true},
}

if (not pcall(require, 'paq')) then
    if vim.fn.input('Download Paq? (y to confirm): ') == 'y' then
        download_paq()
        vim.cmd.packAdd('paq-nvim')
        local paq = require('paq')
        paq(packages)
        vim.notify('Downloading Paq packages, you may need to restart neovim in order for them to work')
        paq.install()
    end
else
    require('paq')(packages)
end
