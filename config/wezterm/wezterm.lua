local wezterm = require 'wezterm'
local act = wezterm.action --用于设置鼠标等动作

-- 启动
wezterm.on( 'gui-startup', function( cmd )
                local _, _, window = wezterm.mux.spawn_window( cmd or {} )
                -- 最大化窗口
                window:gui_window():maximize()
end )

local config = {
    -- 通用
    audible_bell = 'Disabled',
    check_for_updates = false,
    front_end = 'WebGpu',
    use_ime = true,
    ime_preedit_rendering = "Builtin",

    -- 窗口
    window_decorations = 'RESIZE',
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    show_new_tab_button_in_tab_bar = false,
    window_background_opacity = 0.6,
    text_background_opacity = 0.6,
    macos_window_background_blur = 50,
    adjust_window_size_when_changing_font_size = false,
    window_close_confirmation = 'NeverPrompt',
    warn_about_missing_glyphs = false,
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 5
    },

    -- 字体
    font = wezterm.font("Sarasa Term SC Nerd", { weight = 'Regular' }),
    font_size = 12.0,

    -- 主题
    color_scheme = 'nordfox',

    -- 鼠标
    mouse_bindings = {
        {
            -- 右键粘贴
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = act({ PasteFrom = "Clipboard" }),
        },
    },
}

return config
