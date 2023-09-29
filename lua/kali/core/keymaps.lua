local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function  name
local keymap = vim.keymap.set

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--  Modes
--  normal_mode = "n",
--  insert_mode = "i",
--  visual_mode = "v",
--  visual_block_mode = "x",
--  term_mode = "t",
--  command_mode = "c",

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Center search result
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay  in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Smart Split --
-- Better split controll
-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
keymap('n', '<C-Left>', ":lua require('smart-splits').resize_left()<CR>", opts)
keymap('n', '<C-Down>', ":lua require('smart-splits').resize_down()<CR>", opts)
keymap('n', '<C-Up>', ":lua require('smart-splits').resize_up()<CR>", opts)
keymap('n', '<C-Right>', ":lua require('smart-splits').resize_right()<CR>", opts)
-- moving between splits
keymap('n', '<M-h>', ":lua require('smart-splits').move_cursor_left()<CR>", opts)
keymap('n', '<M-j>', ":lua require('smart-splits').move_cursor_down()<CR>", opts)
keymap('n', '<M-k>', ":lua require('smart-splits').move_cursor_up()<CR>", opts)
keymap('n', '<M-l>', ":lua require('smart-splits').move_cursor_right()<CR>", opts)
-- swapping buffers between windows
keymap('n', '<leader><leader>h', ":lua require('smart-splits').swap_buf_left()<CR>", opts)
keymap('n', '<leader><leader>j', ":lua require('smart-splits').swap_buf_down()<CR>", opts)
keymap('n', '<leader><leader>k', ":lua require('smart-splits').swap_buf_up()<CR>", opts)
keymap('n', '<leader><leader>l', ":lua require('smart-splits').swap_buf_right()<CR>", opts)

-- Exit and save
opts.desc = "Write"
keymap('n', '<leader>w', ":w<CR>", opts)

opts.desc = "Quit"
keymap('n', '<leader>q', ":q<CR>", opts)

opts.desc = "Quit all"
keymap('n', '<leader>Q', ":qa<CR>", opts)
