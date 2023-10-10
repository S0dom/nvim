local options = {
    tabstop = 4,               --Number of spaces that a <Tab> in the file counts for.
    cmdheight = 1,             --Number of screen lines to use for the command-line.
    number = true,             --Print the line number in front of each line.
    relativenumber = true,     --Show the line number relative to the line.
    numberwidth = 4,           --Minimal number of columns to use for the line number.
    sidescrolloff = 16,        --Minimal number of side lines to keep beside the cursor.
    scrolloff = 8,             --Minimal number of screen lines to keep above and below the cursor.
    mouse = "a",               --Enables mouse support.
    background = "dark",       --Background colortheme.
    fileencoding = "utf-8",    --File-content encoding for the current buffer.
    guifont = "monospace:h17", --Font used in graphical neovim applications.
    wrap = false,              --Displays lines inside the window (false = displays one long line).
    signcolumn = "yes",        --Show the sign column (next to the line numbers).
    cursorline = true,         --Highlight the current line with a horizontal line.
    shiftwidth = 4,            --The number of spaces inserted for each indentation.
    expandtab = true,          --Convert tabs to spaces.
    writebackup = false,       --Make a backup before overwriting a file.
    updatetime = 300,          --Time for completetion (default 400ms).
    undofile = true,           --Enable persistent undo.
    timeoutlen = 500,          --Time towait for a mapped sequence to complete.
    termguicolors = true,      --Set term gui colors.
    swapfile = false,          --Creates a swapfile that resores data (if the computer crashes the data can be restored).
    splitright = true,         --Force all vertical splits to go to the right of current window.
    splitbelow = true,         --Force all horizontal splits to go below of current window.
    smartindent = true,        --Make indenting smart.
    smartcase = true,          --Smart case.
    showtabline = 2,           --Always show tabline.
    showmode = false,          --Does not show the mode anymore.
    pumheight = 10,            --Pop up menu height.
    hlsearch = true,           --Highlights all matches on previous search patterns.
    conceallevel = 0,          --Makes some characters visible.
    completeopt = {
        "menuone",
        "noselect",
    },                         --Popup menu for code completion for example.
    clipboard = "unnamedplus", --Allows neovim to access the system clipboard so copying and pasting is easier.
    backup = false,            --Creates a backup file.
    hidden = true,             --Required to keep multiple buffers and open multiple buffers
    ignorecase = true,         --ignore case in search patterns
    laststatus = 3,            --global statusline
    colorcolumn = "120",
    --fillchars = {
    --horiz     = '━',
    --horizup   = '┻',
    --horizdown = '┳',
    --vert      = '┃',
    --vertleft  = '┫',
    --vertright = '┣',
    --verthoriz = '╋',
    --},                    --Other separators if needed
}

vim.opt.shortmess:append "c"

local g = {
    loaded_perl_provider = 0,
    loaded_ruby_provider = 0,
    loaded_node_provider = 0,
    loaded_python_provider = 0,
    loaded_python3_provider = 0,
    loaded_netrw = 1,
    loaded_netrwPlugin = 1,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

for k, v in pairs(g) do
    vim.g[k] = v
end

-- vim.cmd "set whichwrap+=<,>,[,],h,l"
