return {

    {
        name = "Stage Hunk",
        cmd = "Gitsigns stage_hunk",
    },
    {
        name = "Reset Hunk",
        cmd = "Gitsigns reset_hunk",
    },

    {
        name = "Stage Buffer",
        cmd = "Gitsigns stage_buffer",
    },
    {
        name = "Undo Stage Hunk",
        cmd = "Gitsigns undo_stage_hunk",
    },
    {
        name = "Reset Buffer",
        cmd = "Gitsigns reset_buffer",
    },
    {
        name = "Preview Hunk",
        cmd = "Gitsigns preview_hunk",
    },
    { name = "separator" },
    {
        name = "Blame Line",
        cmd = 'lua require"gitsigns".blame_line{full=true}',
    },
    {
        name = "Toggle Current Line Blame",
        cmd = "Gitsigns toggle_current_line_blame",
    },

    { name = "separator" },

    {
        name = "Diff This",
        cmd = "Gitsigns diffthis",
    },
    {
        name = "Diff Last Commit",
        cmd = 'lua require"gitsigns".diffthis("~")',
    },
    {
        name = "Toggle Deleted",
        cmd = "Gitsigns toggle_deleted",
    },
}
