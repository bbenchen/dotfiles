require("full-border"):setup {
    -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
    type = ui.Border.ROUNDED,
}

require("folder-rules"):setup()

require("git"):setup()

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

function Status:name()
    local h = self._tab.current.hovered
    if not h then
        return ui.Line {}
    end

    local linked = ""
    if h.link_to ~= nil then
        linked = " -> " .. tostring(h.link_to)
    end
    return ui.Span(" " .. h.name .. linked)
end

Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= "unix" then
        return ""
    end

    return ui.Line {
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        " ",
    }
end, 500, Status.RIGHT)
