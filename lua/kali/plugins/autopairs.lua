return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
        fast_wrap = {
            map = '<M-e>',
            chars = { '{', '[', '(', '"', "'" },
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = '$',
            keys = 'qwertyuiopzxcvbnmasdfghjkl',
            highlight = 'Search',
            highlight_grey = 'Comment',
            manual_position = true,
        },
    },
}
