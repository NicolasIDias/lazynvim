-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		
		{ "nvim-lua/plenary.nvim",       lazy = true }, 
		{ "nvim-tree/nvim-web-devicons", lazy = true }, 
        {
			"folke/tokyonight.nvim",
			lazy = false, 
			priority = 1000, 
			config = function()
				vim.cmd.colorscheme("tokyonight-storm")
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = {
						theme = "tokyonight",
					},
				})
			end,
		},
		{
			"akinsho/bufferline.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			version = "*",
			config = true, 
		},

	
		{
			"nvim-tree/nvim-tree.lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("nvim-tree").setup({
					disable_netrw = true,
					hijack_netrw = true,
					view = {
						width = 30,
						side = "left",
					},
					renderer = {
						group_empty = true,
					},
				})

				vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "[E]xplorer" })
			end,
		},

		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			branch = "0.1.x",
			config = function()
				local telescope = require("telescope")
				telescope.setup({}) 

				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" }) 
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" }) 
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" }) 
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" }) 
			end,
		},

		{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v3.x",
			dependencies = {
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },

				{ "neovim/nvim-lspconfig" },

				{ "hrsh7th/nvim-cmp" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-path" },
				{ "hrsh7th/cmp-cmdline" },

				{ "L3MON4D3/LuaSnip" },
				{ "saadparwaiz1/cmp_luasnip" },
				{ "rafamadriz/friendly-snippets" },
			},
			config = function()
				local lsp_zero = require("lsp-zero")
				lsp_zero.on_attach(function(client, bufnr)
					lsp_zero.default_keymaps({ buffer = bufnr })
				end)

				require("mason").setup({})
				require("mason-lspconfig").setup({
					ensure_installed = {
						"ts_ls", 
						"lua_ls", 
						"pyright", 
						"gopls", 					},
					handlers = {
						lsp_zero.default_setup,
					},
				})
			end,
		},

		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		},
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			config = function()
				require("conform").setup({
					formatters_by_ft = {
						lua = { "stylua" },
						python = { "isort", "black" },
						javascript = { { "prettierd", "prettier" } },
						typescript = { { "prettierd", "prettier" } },
					},
					format_on_save = {
						timeout_ms = 500,
						lsp_fallback = true,
					},
				})
			end,
		},
	},
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true },
})
