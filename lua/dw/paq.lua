--Bootstrap paq

local download_packages = false

local function download_paq()
    local install_path = string.format('%s/site/pack/paqs/start/paq-nvim', vim.fn.stdpath('data'))
    vim.notify('Downloading paq-nvim', vim.log.levels.INFO)
    local out = vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})

    vim.notify(out, vim.log.levels.DEBUG)
    download_packages = true
    vim.opt.runtimepath:append(install_path)
end

local function load_paqs()
    require 'paq' {
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
    }
end

if (not pcall(require, 'paq')) then
    if vim.fn.input('Download Paq? (y to confirm): ') == 'y' then
        download_paq()
        load_paqs()
    end
else
    load_paqs()
end

if download_packages then
    vim.notify('Downloading Paq packages, you will need to restart neovim in order for them to work')
    require 'paq':install()
    _G['bootstrap-paq'] = true
end
