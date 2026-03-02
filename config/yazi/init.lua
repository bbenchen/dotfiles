require("full-border"):setup {
    -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
    type = ui.Border.ROUNDED,
}

require("smart-enter"):setup {
    open_multi = true,
}

require("folder-rules"):setup()

require("git"):setup {
    -- Order of status signs showing in the linemode
    order = 1500,
}

require("copy-file-contents"):setup({
    append_char = "\n",
    notification = true,
})

require("yatline"):setup({
    section_separator = { open = "", close = "" },
    part_separator = { open = "", close = "" },
    inverse_separator = { open = "", close = "" },

    padding = { inner = 1, outer = 1 },

    style_a = {
        bg = "white",
        fg = "black",
        bg_mode = {
            normal = "white",
            select = "brightyellow",
            un_set = "brightred",
        },
    },
    style_b = { bg = "brightblack", fg = "brightwhite" },
    style_c = { bg = "black", fg = "brightwhite" },

    permissions_t_fg = "green",
    permissions_r_fg = "yellow",
    permissions_w_fg = "red",
    permissions_x_fg = "cyan",
    permissions_s_fg = "white",

    tab_width = 20,

    selected = { icon = "󰻭", fg = "yellow" },
    copied = { icon = "", fg = "green" },
    cut = { icon = "", fg = "red" },

    files = { icon = "", fg = "blue" },
    filtereds = { icon = "", fg = "magenta" },

    total = { icon = "󰮍", fg = "yellow" },
    success = { icon = "", fg = "green" },
    failed = { icon = "", fg = "red" },

    show_background = true,

    display_header_line = true,
    display_status_line = true,

    component_positions = { "header", "tab", "status" },

    header_line = {
        left = {
            section_a = {
                { type = "line", name = "tabs" },
            },
            section_b = {},
            section_c = {},
        },
        right = {
            section_a = {
                { type = "string", name = "date", params = { "%A, %d %B %Y" } },
            },
            section_b = {
                { type = "string", name = "date", params = { "%X" } },
            },
            section_c = {},
        },
    },

    status_line = {
        left = {
            section_a = {
                { type = "string", name = "tab_mode" },
            },
            section_b = {
                { type = "string", name = "hovered_size" },
            },
            section_c = {
                { type = "string", name = "hovered_path" },
                { type = "coloreds", name = "count" },
            },
        },
        right = {
            section_a = {
                { type = "string", name = "cursor_position" },
            },
            section_b = {
                { type = "string", name = "cursor_percentage" },
            },
            section_c = {
                { type = "string", name = "hovered_file_extension", params = { true } },
                { type = "coloreds", name = "permissions" },
            },
        },
    },
})

function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
    elseif os.date("%Y", time) == os.date("%Y") then
        time = os.date("%b %d %H:%M", time)
    else
        time = os.date("%b %d  %Y", time)
    end

    local size = self._file:size()
    if size then
        return string.format("%s %s", ya.readable_size(size), time)
    else
        local folder = cx.active:history(self._file.url)
        return string.format("%s %s", folder and tostring(#folder.files) or "-", time)
    end
end

Status:children_add(function()
    local h = cx.active.current.hovered
    if not h or ya.target_family() ~= "unix" then
        return ""
    end

    return ui.Line {
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        " ",
    }
end, 500, Status.RIGHT)
