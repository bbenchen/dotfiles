local wezterm = require 'wezterm'
local act = wezterm.action --用于设置鼠标等动作

-- 获取系统信息，返回系统名和架构信息
local function get_os_info()
    local raw_os_name, raw_arch_name = '', ''

    -- LuaJIT shortcut
    if jit and jit.os and jit.arch then
        raw_os_name = jit.os
        raw_arch_name = jit.arch
        -- print( ("Debug jit name: %q %q"):format( raw_os_name, raw_arch_name ) )
    else
        if package.config:sub(1,1) == '\\' then
            -- Windows
            local env_OS = os.getenv('OS')
            local env_ARCH = os.getenv('PROCESSOR_ARCHITECTURE')
            -- print( ("Debug: %q %q"):format( env_OS, env_ARCH ) )
            if env_OS and env_ARCH then
                raw_os_name, raw_arch_name = env_OS, env_ARCH
            end
        else
            -- other platform, assume uname support and popen support
            raw_os_name = io.popen('uname -s','r'):read('*l')
            raw_arch_name = io.popen('uname -m','r'):read('*l')
        end
    end

    raw_os_name = (raw_os_name):lower()
    raw_arch_name = (raw_arch_name):lower()

    -- print( ("Debug: %q %q"):format( raw_os_name, raw_arch_name) )

    local os_patterns = {
        ['windows']     = 'Windows',
        ['linux']       = 'Linux',
        ['osx']         = 'Mac',
        ['mac']         = 'Mac',
        ['darwin']      = 'Mac',
        ['^mingw']      = 'Windows',
        ['^cygwin']     = 'Windows',
        ['bsd$']        = 'BSD',
        ['sunos']       = 'Solaris',
    }

    local arch_patterns = {
        ['^x86$']           = 'x86',
        ['i[%d]86']         = 'x86',
        ['amd64']           = 'x86_64',
        ['x86_64']          = 'x86_64',
        ['x64']             = 'x86_64',
        ['power macintosh'] = 'powerpc',
        ['^arm']            = 'arm',
        ['^mips']           = 'mips',
        ['i86pc']           = 'x86',
    }

    local os_name, arch_name = 'unknown', 'unknown'

    for pattern, name in pairs(os_patterns) do
        if raw_os_name:match(pattern) then
            os_name = name
            break
        end
    end
    for pattern, name in pairs(arch_patterns) do
        if raw_arch_name:match(pattern) then
            arch_name = name
            break
        end
    end
    return os_name, arch_name
end

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
    font = wezterm.font 'Sarasa Term SC Nerd',

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

local os_name, _ = get_os_info()
if os_name == 'Mac' then
    config.font_size = 10.0
else
    config.font_size = 12.0
end

return config
