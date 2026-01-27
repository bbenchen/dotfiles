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
