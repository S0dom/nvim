return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- require'alpha'.setup(require'alpha.themes.startify'.config)
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[              .                                                      .                 ]],
            [[            .n                   .                 .                  n.               ]],
            [[       .   .dP                  dP                   9b                 9b.    .       ]],
            [[      4    qXb         .       dX                     Xb       .        dXp     t      ]],
            [[     dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb     ]],
            [[     9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP     ]],
            [[      9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP      ]],
            [[       `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'       ]],
            [[         `9XXXXXXXXXXXP' `9XX'   DIE    `98v8P'  HUMAN   `XXP' `9XXXXXXXXXXXP'         ]],
            [[             ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~             ]],
            [[                             )b.  .dbo.dP'`v'`9b.odb.  .dX(                            ]],
            [[                           ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.                           ]],
            [[                          dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb                          ]],
            [[                         dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb                         ]],
            [[                         9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP                         ]],
            [[                          `'      9XXXXXX(   )XXXXXXP      `'                          ]],
            [[                                   XXXX X.`v'.X XXXX                                   ]],
            [[                                   XP^X'`b   d'`X^XX                                   ]],
            [[                                   X. 9  `   '  P )X                                   ]],
            [[                                   `b  `       '  d'                                   ]],
            [[                                    `             '                                    ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", ":Telescope find_files find_command=rg,--hidden,--files <CR>"),
            dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
            dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
            dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
            dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
            dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
        }

        local function footer()
            -- Uncomment the following lines if you have the fortune-mod package installed
            -- local handle = io.popen("fortune")
            -- local fortune = handle:read("*a")
            -- handle:close()
            -- return fortune

            -- Return a custom footer value if desired
            -- return "chrisatmachine.com"
        end

        -- dashboard.section.footer.val = footer()

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.noautocmd = true

        alpha.setup(dashboard.config)
    end
}
