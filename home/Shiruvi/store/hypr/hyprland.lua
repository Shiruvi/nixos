-- ~/.config/hypr/hyprland.lua
-- Hyprland config ported from my niri config
-- (Hyprland 0.55+, Lua config, built-in scrolling layout).
--
-- Dotfiles: https://github.com/Shiruvi/nixos
-- Wiki:     https://wiki.hypr.land/configuring/
--
-- Markers:  [~] approximate equivalent,  [x] no equivalent in Hyprland.
-- Hotkey cheat sheet: Mod+Shift+/  (requires fuzzel; searchable list).

local mainMod = "SUPER"

----------------------------------------------------------------------
-- MONITORS
----------------------------------------------------------------------
-- List outputs: `hyprctl monitors all`
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60",     position = "0x0",    scale = 1, transform = 0 })
hl.monitor({ output = "DP-1",     mode = "5120x1440@119.97", position = "0x1440", transform = 0 })
hl.monitor({ output = "DP-2",                                position = "2560x0" })
-- NOTE: HDMI-A-1 (640x360) overlaps eDP-1 (0x0, 1920x1080) if both are connected.
hl.monitor({ output = "HDMI-A-1",                            position = "640x360" })
-- Any other monitor: preferred mode, placed automatically
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

----------------------------------------------------------------------
-- ENVIRONMENT
----------------------------------------------------------------------
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")
-- fcitx5 on Wayland (if not already set elsewhere):
-- hl.env("XMODIFIERS", "@im=fcitx")
-- hl.env("QT_IM_MODULE", "fcitx")

----------------------------------------------------------------------
-- AUTOSTART
----------------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("solaar -w hide")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    -- equivalent of niri's focus-at-startup on DP-1
    hl.dispatch(hl.dsp.focus({ monitor = "DP-1" }))
end)

----------------------------------------------------------------------
-- INPUT
----------------------------------------------------------------------
hl.config({
    input = {
        kb_layout          = "us,ru",
        -- Caps Lock switches layout, Right Alt is Compose
        -- (ctrl:nocaps removed: it fought grp:caps_toggle over the same key).
        kb_options         = "grp:caps_toggle,compose:ralt",
        repeat_delay       = 300,
        numlock_by_default = true,
        follow_mouse       = 1,      -- focus-follows-mouse
        touchpad = {
            tap_to_click         = true,
            disable_while_typing = true,
            natural_scroll       = true,
        },
    },

    binds = {
        workspace_back_and_forth = 1,   -- workspace-auto-back-and-forth
        scroll_event_delay       = 150, -- niri's cooldown-ms=150 on the wheel
    },

    cursor = {
        hide_on_key_press        = true, -- hide-when-typing
        inactive_timeout         = 1,    -- hide-after-inactive-ms 1000 (seconds here)
        warp_on_change_workspace = 1,    -- warp-mouse-to-focus
    },
})

-- [x] track-layout "window" (per-window keyboard layout) has no built-in equivalent.

----------------------------------------------------------------------
-- LOOK AND LAYOUT
----------------------------------------------------------------------
hl.config({
    general = {
        layout      = "scrolling",
        gaps_in     = 5,   -- 5+5 = 10 between windows, same as niri's gaps 10
        gaps_out    = 10,
        border_size = 2,   -- plays the role of niri's focus-ring
        col = {
            active_border   = "rgb(125763)",
            inactive_border = "rgb(515752)",
        },
    },

    scrolling = {
        column_width             = 0.5,  -- default-column-width
        explicit_column_widths   = "0.25, 0.333, 0.5, 0.667, 0.75, 1.0", -- preset-column-widths
        focus_fit_method         = 1,    -- [~] center-focused-column "on-overflow"
        fullscreen_on_one_column = false,-- [~] always-center-single-column
        wrap_focus               = true, -- focus-column-*-or-first/last
        wrap_swapcol             = false,
    },

    decoration = {
        rounding = 20,     -- geometry-corner-radius 20
        shadow   = { enabled = false },
        blur = {
            enabled  = true,
            passes   = 3,
            size     = 4,
            noise    = 0.02,
            vibrancy = 0.5,
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

-- Default column width 0.25 on the ultrawide DP-1
hl.window_rule({
    name            = "dp1-quarter-columns",
    match           = { workspace = "m[DP-1]" },
    scrolling_width = 0.25,
})

-- Touchpad: three-finger swipes, like in niri
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
hl.gesture({ fingers = 3, direction = "vertical",   action = "workspace" })

----------------------------------------------------------------------
-- WINDOW AND LAYER RULES
----------------------------------------------------------------------
hl.window_rule({
    name            = "keepassxc-hide-cast",
    match           = { class = [[^org\.keepassxc\.KeePassXC$]] },
    no_screen_share = true,
})

hl.window_rule({
    name            = "steam-toasts",
    match           = { class = "^steam$", title = [[^notificationtoasts_\d+_desktop$]] },
    float           = true,
    move            = { "monitor_w-window_w-10", "monitor_h-window_h-10" },
    no_screen_share = true,
})

hl.window_rule({
    name  = "ninjabrain",
    match = { class = "ninjabrainbot-Main" },
    float = true,
    move  = { "monitor_w-window_w-10", "10" },
})

-- [x] is-window-cast-target (highlighting the window being cast) has no equivalent.

hl.layer_rule({ match = { namespace = "^launcher$" },      blur = true })
hl.layer_rule({ match = { namespace = "^notifications$" }, blur = true, no_screen_share = true })

----------------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------------
local function dispatch(d) hl.dispatch(d) end
local function layout(msg) return hl.dsp.layout(msg) end

-- Number of columns on the window's workspace
local function column_count(w)
    local max = -1
    for _, x in ipairs(hl.get_workspace_windows(w.workspace) or {}) do
        local l = x.layout
        if l and l.column and l.column.index and l.column.index > max then
            max = l.column.index
        end
    end
    return max + 1
end

-- focus-window-or-workspace-up/down
local function focus_window_or_workspace(dir) -- "u" | "d"
    return function()
        local w = hl.get_active_window()
        local l = w and w.layout
        if l and l.column and l.column.windows then
            local i, n = l.index_in_column, #l.column.windows
            if (dir == "u" and i > 0) or (dir == "d" and i < n - 1) then
                dispatch(layout("focus " .. dir))
                return
            end
        end
        dispatch(hl.dsp.focus({ workspace = dir == "u" and "r-1" or "r+1" }))
    end
end

-- move-column-left/right-or-to-monitor-left/right
local function move_column_or_monitor(dir) -- "l" | "r"
    return function()
        local w = hl.get_active_window()
        local l = w and w.layout
        if l and l.column and l.column.index then
            local idx = l.column.index
            if (dir == "l" and idx > 0) or (dir == "r" and idx < column_count(w) - 1) then
                dispatch(layout("swapcol " .. dir))
                return
            end
        end
        dispatch(hl.dsp.window.move({ monitor = dir }))
    end
end

-- maximize-column (toggle that remembers the previous width)
local prev_width = {}
local function toggle_maximize_column(also_center)
    return function()
        local w = hl.get_active_window()
        local l = w and w.layout
        if not (l and l.column and l.column.width) then return end
        if l.column.width >= 0.99 then
            dispatch(layout("colresize " .. tostring(prev_width[w.address] or 0.5)))
            prev_width[w.address] = nil
        else
            prev_width[w.address] = l.column.width
            dispatch(layout("colresize 1.0"))
        end
        if also_center then dispatch(layout("center")) end
    end
end

-- switch-focus-between-floating-and-tiling
local function switch_float_tile()
    local w = hl.get_active_window()
    if w and w.floating then
        dispatch(hl.dsp.window.cycle_next({ tiled = true }))
    else
        dispatch(hl.dsp.window.cycle_next({ floating = true }))
    end
end

-- DPMS through a timer (as the wiki recommends)
local function dpms(action)
    return function()
        hl.timer(function()
            hl.dispatch(hl.dsp.dpms({ action = action }))
        end, { timeout = 500, type = "oneshot" })
    end
end

-- Equivalent of niri's `quit` with confirmation: a small fuzzel Yes/No menu
local EXIT_CMD = [[printf 'No\nYes, quit\n' | fuzzel --dmenu --prompt 'Quit Hyprland? ' --lines 2 --width 30 ]]
    .. [[| grep -q '^Yes' && { command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'; }]]

-- Equivalent of toggle-keyboard-shortcuts-inhibit: forbid/allow the active
-- window to grab compositor hotkeys (games, VMs, remote desktop).
local function toggle_shortcuts_inhibit()
    hl.dispatch(hl.dsp.window.set_prop({ prop = "no_shortcuts_inhibit", value = "toggle" }))
end

----------------------------------------------------------------------
-- CHEAT SHEET
-- Every bind with a description shows up in `hyprctl binds` and in the
-- cheat sheet opened with Mod+Shift+/ (a searchable list in fuzzel).
----------------------------------------------------------------------
local CATEGORIES = { "System", "Applications", "Windows and columns", "Navigation", "Workspaces", "Screenshots" }
local sheet = {}
for _, c in ipairs(CATEGORIES) do sheet[c] = {} end

local function pretty(keys)
    return (keys:gsub("SUPER", "Super"):gsub("SHIFT", "Shift"):gsub("CTRL", "Ctrl")
                :gsub("ALT", "Alt"):gsub(" %+ ", "+"))
end

-- bind(keys, action, [category, description, [key label]], [flags])
-- Without a category the bind still works but is left out of the cheat sheet.
local function bind(keys, action, cat, desc, label, flags)
    if type(cat) == "table" then flags, cat = cat, nil end
    if type(label) == "table" then flags, label = label, nil end
    flags = flags or {}
    if desc then
        flags.description = desc
        table.insert(sheet[cat], { label or pretty(keys), desc })
    end
    hl.bind(keys, action, flags)
end

local M = mainMod .. " + "
local SYS, APP, WIN, NAV, WS, SHOT = table.unpack(CATEGORIES)

----------------------------------------------------------------------
-- KEYBINDINGS
----------------------------------------------------------------------

-- ── System ─────────────────────────────────────────────────────────
-- (Mod+Shift+/, the cheat sheet, is bound at the very end of the file)
bind(M .. "Escape",    toggle_shortcuts_inhibit, SYS, "Toggle shortcut inhibiting for window", { dont_inhibit = true })
bind(M .. "O",         dpms("disable"),          SYS, "Turn monitors off (Shift - on)", "Super+O / Shift+O")
bind(M .. "SHIFT + O", dpms("enable"))
bind(M .. "SHIFT + E", hl.dsp.exec_cmd(EXIT_CMD), SYS, "Quit Hyprland (with confirmation)")
-- [x] Mod+Shift+M / W / N (dynamic cast target): in Hyprland the cast source
--     is chosen in the xdg-desktop-portal-hyprland picker.

-- ── Applications ───────────────────────────────────────────────────
bind(M .. "Return",         hl.dsp.exec_cmd("kitty"),                        APP, "Terminal (kitty)")
bind(M .. "SHIFT + Return", hl.dsp.exec_cmd("kitty --hold sh -c fastfetch"), APP, "Terminal with fastfetch")
bind(M .. "Space",          hl.dsp.exec_cmd("fuzzel"),                       APP, "App launcher (fuzzel)")
bind(M .. "B",              hl.dsp.exec_cmd("floorp"),                       APP, "Browser (Floorp)")
bind(M .. "E",              hl.dsp.exec_cmd("nautilus"),                     APP, "Files (Nautilus)")
bind(M .. "ALT + T",        hl.dsp.exec_cmd("Telegram"),                     APP, "Telegram")
bind(M .. "ALT + D",        hl.dsp.exec_cmd("vesktop"),                      APP, "Discord (Vesktop)")
bind(M .. "ALT + O",        hl.dsp.exec_cmd("onlyoffice-desktopeditors"),    APP, "OnlyOffice")
bind(M .. "N",              hl.dsp.exec_cmd("java -jar ~/mine/Ninjabrain-Bot-1.5.2.jar"), APP, "Ninjabrain Bot")
bind(M .. "J",              hl.dsp.exec_cmd("fcitx5-remote -t"),             APP, "Toggle fcitx5 input method")

-- ── Windows and columns ────────────────────────────────────────────
bind(M .. "Q",         hl.dsp.window.close(),                    WIN, "Close window")
bind(M .. "T",         hl.dsp.window.float({ action = "toggle" }), WIN, "Toggle floating / tiled")
bind(M .. "Y",         switch_float_tile,                        WIN, "Focus: floating ⇄ tiled")
bind(M .. "F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }), WIN, "Fullscreen")
bind(M .. "SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" }),
                                                                 WIN, "Windowed fullscreen")
bind(M .. "M",         toggle_maximize_column(false),            WIN, "Maximize column")
bind(M .. "W",         toggle_maximize_column(true),             WIN, "Maximize and center column")
bind(M .. "C",         layout("center"),                         WIN, "Center column")
bind(M .. "SHIFT + C", layout("fit visible"),                    WIN, "Fit visible columns on screen")   -- [~]
bind(M .. "SHIFT + X", hl.dsp.group.toggle(),                    WIN, "Toggle window group (tabs)")        -- [~]

bind(M .. "equal",     layout("colresize +conf"), WIN, "Column width: next / previous preset", "Super+= / −")
bind(M .. "minus",     layout("colresize -conf"))
-- [~] no height presets in Hyprland: 100px steps instead
bind(M .. "SHIFT + equal", hl.dsp.window.resize({ x = 0, y =  100, relative = true }),
                           WIN, "Window height: taller / shorter", "Super+Shift+= / −", { repeating = true })
bind(M .. "SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), nil, nil, { repeating = true })
-- [x] Mod+R reset-window-height has no equivalent

bind(M .. "bracketleft",          hl.dsp.window.swap({ direction = "left" }),  WIN, "Swap window with neighbor", "Super+[ / ]")
bind(M .. "bracketright",         hl.dsp.window.swap({ direction = "right" }))
bind(M .. "SHIFT + bracketleft",  layout("consume_or_expel prev"), WIN, "Consume or expel window", "Super+Shift+[ / ]")
bind(M .. "SHIFT + bracketright", layout("consume_or_expel next"))

-- Mouse: Mod+LMB drags, Mod+RMB resizes
bind(M .. "mouse:272", hl.dsp.window.drag(),   WIN, "Drag window", "Super+LMB", { mouse = true })
bind(M .. "mouse:273", hl.dsp.window.resize(), WIN, "Resize window", "Super+RMB", { mouse = true })

-- ── Navigation ─────────────────────────────────────────────────────
bind(M .. "Left",  layout("focus l"), NAV, "Focus column left / right (wraps)", "Super+← / →")
bind(M .. "Right", layout("focus r"))
bind(M .. "Up",    focus_window_or_workspace("u"), NAV, "Focus window up / down, workspace at edge", "Super+↑ / ↓")
bind(M .. "Down",  focus_window_or_workspace("d"))
bind(M .. "SHIFT + grave", layout("focus u"), NAV, "Focus window up in column (wraps)", "Super+Shift+`")

bind(M .. "SHIFT + Left",  hl.dsp.focus({ monitor = "l" }), NAV, "Focus monitor", "Super+Shift+arrows")
bind(M .. "SHIFT + Right", hl.dsp.focus({ monitor = "r" }))
bind(M .. "SHIFT + Down",  hl.dsp.focus({ monitor = "d" }))
bind(M .. "SHIFT + Up",    hl.dsp.focus({ monitor = "u" }))

bind(M .. "CTRL + Left",  move_column_or_monitor("l"), NAV, "Move column / window (across monitors)", "Super+Ctrl+arrows")
bind(M .. "CTRL + Right", move_column_or_monitor("r"))
bind(M .. "CTRL + Down",  hl.dsp.window.move({ monitor = "d" }))
bind(M .. "CTRL + Up",    hl.dsp.window.move({ monitor = "u" }))

bind(M .. "mouse_down",  hl.dsp.focus({ workspace = "r+1" }), NAV, "Wheel: workspaces / columns", "Super+wheel")
bind(M .. "mouse_up",    hl.dsp.focus({ workspace = "r-1" }))
bind(M .. "mouse_right", layout("focus r"))
bind(M .. "mouse_left",  layout("focus l"))

-- ── Workspaces ─────────────────────────────────────────────────────
-- [~] no built-in overview: jump to the previous workspace (or use the hyprexpo plugin)
bind(M .. "Tab", hl.dsp.focus({ workspace = "previous" }), WS, "Previous workspace")

for i = 1, 10 do
    local key = i % 10 -- workspace 10 -> key 0
    if i == 1 then
        bind(M .. key,             hl.dsp.focus({ workspace = i }),       WS, "Go to workspace (0 = 10)", "Super+1…0")
        bind(M .. "SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), WS, "Move window to workspace", "Super+Shift+1…0")
    else
        bind(M .. key,             hl.dsp.focus({ workspace = i }))
        bind(M .. "SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
end

-- [~] moves the window, not the whole column
bind(M .. "period", hl.dsp.window.move({ workspace = "r+1" }), WS, "Move window to workspace down / up", "Super+. / ,")
bind(M .. "comma",  hl.dsp.window.move({ workspace = "r-1" }))
-- [x] Mod+Shift+Period/Comma (move-workspace-down/up) has no equivalent

bind(M .. "ALT + Left",  hl.dsp.workspace.move({ monitor = "l" }), WS, "Move workspace to monitor", "Super+Alt+arrows")
bind(M .. "ALT + Right", hl.dsp.workspace.move({ monitor = "r" }))
bind(M .. "ALT + Down",  hl.dsp.workspace.move({ monitor = "d" }))
bind(M .. "ALT + Up",    hl.dsp.workspace.move({ monitor = "u" }))

-- ── Screenshots (hyprshot: saves to HYPRSHOT_DIR and copies to clipboard) ──
bind("Print",              hl.dsp.exec_cmd("hyprshot -m region"),                             SHOT, "Screenshot area")
bind("CTRL + Print",       hl.dsp.exec_cmd("hyprshot -m window -m active"),                   SHOT, "Screenshot window (+Super - clipboard only)", "Ctrl+Print")
bind(M .. "CTRL + Print",  hl.dsp.exec_cmd("hyprshot -m window -m active --clipboard-only"))
bind(M .. "SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"), SHOT, "Screenshot screen to clipboard")

-- ── Media keys (also work on the lock screen) ──────────────────────
-- -l 1.0 caps the volume at 100%
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),        { locked = true, repeating = true })
bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true })
bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      { locked = true })

bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),       { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"),       { locked = true })

bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl --class=backlight set +10%"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --class=backlight set 10%-"), { locked = true, repeating = true })

----------------------------------------------------------------------
-- BUILDING THE CHEAT SHEET
-- The text is generated from the bind descriptions above and written to a
-- temp file on every config load; Mod+Shift+/ shows it in fuzzel.
----------------------------------------------------------------------
table.insert(sheet[SYS], 1, { "Super+Shift+/", "This cheat sheet (type to search)" })

local SHEET_FILE = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/hypr-cheatsheet.txt"
do
    -- width of the key column, UTF-8 aware (arrows, ellipsis)
    local width = 0
    for _, c in ipairs(CATEGORIES) do
        for _, e in ipairs(sheet[c]) do width = math.max(width, utf8.len(e[1])) end
    end

    local lines = {}
    for _, c in ipairs(CATEGORIES) do
        if #sheet[c] > 0 then
            if #lines > 0 then table.insert(lines, " ") end
            table.insert(lines, "━━━ " .. c .. " " .. string.rep("━", 40 - utf8.len(c)))
            for _, e in ipairs(sheet[c]) do
                local pad = string.rep(" ", width - utf8.len(e[1]) + 3)
                table.insert(lines, "  " .. e[1] .. pad .. e[2])
            end
        end
    end

    local f = io.open(SHEET_FILE, "w")
    if f then
        f:write(table.concat(lines, "\n"), "\n")
        f:close()
    end
end

-- Pressing it again closes the cheat sheet.
hl.bind(M .. "SHIFT + slash", hl.dsp.exec_cmd(
    "pkill -x fuzzel || fuzzel --dmenu --prompt '⌨  ' --width 80 --lines 45 "
    .. "--font 'monospace:size=11' < '" .. SHEET_FILE .. "' > /dev/null"),
    { description = "Hotkey cheat sheet" })
