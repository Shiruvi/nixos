-- ┌──────────────────────────────────────────────────────────────────────┐
-- │  Hyprland — ~/.config/hypr/hyprland.lua                              │
-- │  Hyprland 0.55+ (Lua config, built-in scrolling layout)              │
-- │  + caelestia-shell (bar, launcher, notifications, OSD, lock, etc.)   │
-- │                                                                      │
-- │  Author:   Shiruvi                                                   │
-- │  Repo:     https://github.com/Shiruvi/nixos                          │
-- │  License:  GNU GPL v3.0 or later                                     │
-- │                                                                      │
-- │  Hyprland wiki:   https://wiki.hypr.land/configuring/                │
-- │  Caelestia shell: https://github.com/caelestia-dots/shell            │
-- │  Markers:  [~] approximate niri equivalent, [x] no equivalent.       │
-- │  Hotkey cheat sheet:  Super+Shift+/                                  │
-- └──────────────────────────────────────────────────────────────────────┘

local mainMod = "SUPER"
local HOME    = os.getenv("HOME")

-- ════════════════════════════════════════════════════════════════════════
--  COLOUR SCHEME
--  caelestia-cli writes hypr/scheme/current.lua on every wallpaper or
--  scheme change. Before the first change the file does not exist yet,
--  so fall back to fixed colours.
-- ════════════════════════════════════════════════════════════════════════
local ok, scheme = pcall(dofile, HOME .. "/.config/hypr/scheme/current.lua")
if not ok or type(scheme) ~= "table" then
    scheme = { primary = "125763", onSurfaceVariant = "515752" }
end

-- ════════════════════════════════════════════════════════════════════════
--  MONITORS
--  List outputs: `hyprctl monitors all`
-- ════════════════════════════════════════════════════════════════════════
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60",     position = "0x0",    scale = 1, transform = 0 })
hl.monitor({ output = "DP-1",     mode = "5120x1440@119.97", position = "0x1440", transform = 0 })
hl.monitor({ output = "DP-2",                                position = "2560x0" })
-- NOTE: HDMI-A-1 (640x360) overlaps eDP-1 (0x0, 1920x1080) if both are connected.
hl.monitor({ output = "HDMI-A-1",                            position = "640x360" })
-- Any other monitor: preferred mode, placed automatically
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- ════════════════════════════════════════════════════════════════════════
--  ENVIRONMENT
--  Locale and Qt theme are set system-wide in NixOS (i18n.defaultLocale,
--  environment.sessionVariables); only compositor-specific bits live here.
-- ════════════════════════════════════════════════════════════════════════
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- Icon theme for Quickshell (caelestia-shell): it calls QIcon::setThemeName
-- with this value at startup, independent of the Qt platform theme.
hl.env("QS_ICON_THEME", "Fluent-dark")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
-- fcitx5 on Wayland (if not already set elsewhere):
-- hl.env("XMODIFIERS", "@im=fcitx")
-- hl.env("QT_IM_MODULE", "fcitx")

-- ════════════════════════════════════════════════════════════════════════
--  AUTOSTART
-- ════════════════════════════════════════════════════════════════════════
hl.on("hyprland.start", function()
    -- Systemd session: graphical-session.target is a hard requirement
    -- (Requisite=) of xdg-desktop-portal, so without it screen sharing,
    -- OBS and file pickers fail. hyprland-session.target (hypr.nix) binds
    -- graphical-session.target; the environment is exported first.
    hl.exec_cmd("dbus-update-activation-environment --systemd --all"
        .. " && systemctl --user start hyprland-session.target")

    -- Caelestia shell, through its Nix wrapper (sets FONTCONFIG_FILE for
    -- the icon fonts and puts the caelestia CLI on the shell's PATH).
    -- It also draws the wallpaper: set it with `caelestia wallpaper -f <file>`.
    hl.exec_cmd("caelestia-shell -d")

    -- Clipboard history for `caelestia clipboard` (Super+V)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    hl.exec_cmd("fcitx5 -d")
    -- XWayland starts with an "us"-only keymap and never takes Hyprland's
    -- us,ru, so X11 apps (Steam, OnlyOffice) cannot switch to Russian.
    -- Set it on the X server once XWayland is up (retries until it is);
    -- Hyprland then switches the group as usual.
    hl.exec_cmd("sh -c 'sleep 2; for i in $(seq 20); do setxkbmap -layout us,ru && break; sleep 0.5; done'")
    hl.exec_cmd("solaar -w hide")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    -- equivalent of niri's focus-at-startup on DP-1
    hl.dispatch(hl.dsp.focus({ monitor = "DP-1" }))
end)

-- ════════════════════════════════════════════════════════════════════════
--  INPUT
-- ════════════════════════════════════════════════════════════════════════
hl.config({
    input = {
        kb_layout          = "us,ru",
        -- Right Alt is Compose. Caps Lock is disabled here and switches the
        -- layout through a bind (see "Layout switching" below): with
        -- grp:caps_toggle XWayland apps (Steam, OnlyOffice) never switch.
        kb_options         = "caps:none,compose:ralt",
        repeat_delay       = 300,
        numlock_by_default = true,
        follow_mouse       = 1,      -- focus-follows-mouse
        touchpad = {
            tap_to_click         = true,
            disable_while_typing = true,
            natural_scroll       = true,
        },
    },

    general = {
        -- Directional focus stops at the edge instead of wrapping around;
        -- Super+Up/Down uses this to fall through to the next workspace.
        no_focus_fallback = true,
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

-- ════════════════════════════════════════════════════════════════════════
--  LOOK AND LAYOUT
-- ════════════════════════════════════════════════════════════════════════
hl.config({
    general = {
        layout      = "scrolling",
        gaps_in     = 5,   -- 5+5 = 10 between windows, same as niri's gaps 10
        gaps_out    = 10,
        border_size = 2,   -- plays the role of niri's focus-ring
        col = {
            -- Follows the wallpaper (see COLOUR SCHEME above)
            active_border   = "rgb(" .. scheme.primary .. ")",
            inactive_border = "rgba(" .. scheme.onSurfaceVariant .. "40)",
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

    animations = { enabled = true },
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

-- ════════════════════════════════════════════════════════════════════════
--  ANIMATIONS
--  Workspaces slide vertically, like niri's workspace strip.
-- ════════════════════════════════════════════════════════════════════════
hl.curve("standard",        { type = "bezier", points = { { 0.2, 0 },    { 0, 1 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 },    { 0.8, 0.15 } } })

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "layersIn",    enabled = true, speed = 5, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "layersOut",   enabled = true, speed = 4, bezier = "emphasizedAccel", style = "slide" })
hl.animation({ leaf = "fade",        enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "border",      enabled = true, speed = 6, bezier = "standard" })
-- Regular workspaces: vertical slide (the default "slide" is horizontal)
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5, bezier = "standard",        style = "slidevert" })
-- Special workspace (Super+S): slides in vertically with a fade
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "emphasizedDecel", style = "slidefadevert 15%" })

-- ════════════════════════════════════════════════════════════════════════
--  WINDOW AND LAYER RULES
-- ════════════════════════════════════════════════════════════════════════
-- Ignore maximize requests from apps (kitty, browsers...): in the
-- scrolling layout a maximized window covers the whole screen instead of
-- taking a normal column. Super+M / Super+F still maximize on demand.
hl.window_rule({
    name           = "no-app-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

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

-- fuzzel (cheat sheet, clipboard, emoji) uses the "launcher" namespace
hl.layer_rule({ match = { namespace = "^launcher$" }, blur = true })

-- ════════════════════════════════════════════════════════════════════════
--  HELPERS
-- ════════════════════════════════════════════════════════════════════════
local function dispatch(d) hl.dispatch(d) end
local function layout(msg) return hl.dsp.layout(msg) end
-- Caelestia global shortcut (registered by the shell, see `hyprctl globalshortcuts`)
local function shell(name) return hl.dsp.global("caelestia:" .. name) end

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

-- Is the scrolling (niri-like) layout active? See toggle_layout below.
local function is_scrolling()
    return hl.get_config("general:layout") == "scrolling"
end

-- focus-window-or-workspace-up/down
-- Try to move focus inside the column first; if the focused window did not
-- change (top/bottom of the column, floating window, empty workspace),
-- switch to the workspace above/below instead. Relies on
-- general.no_focus_fallback = true, so focus does not wrap inside the column.
local function focus_window_or_workspace(dir) -- "u" | "d"
    return function()
        local before = hl.get_active_window()
        if before and not before.floating then
            if is_scrolling() then
                dispatch(layout("focus " .. dir))
            else
                dispatch(hl.dsp.focus({ direction = dir == "u" and "up" or "down" }))
            end
            local after = hl.get_active_window()
            if after and after.address ~= before.address then return end
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

-- Show/hide the special workspace (scratchpad): closes whichever special
-- workspace is open, otherwise opens "special".
local function toggle_special()
    local active = hl.get_active_special_workspace()
    local target = active and active.name:gsub("^special:", "") or "special"
    dispatch(hl.dsp.workspace.toggle_special(target))
end

-- Switch between the niri-like scrolling layout and classic dwindle
-- tiling (windows split the screen, no endless strip). Applies to all
-- workspaces; a config reload goes back to scrolling.
local function toggle_layout()
    local next_layout = is_scrolling() and "dwindle" or "scrolling"
    hl.config({ general = { layout = next_layout } })
    hl.exec_cmd("notify-send -a Hyprland -i view-grid 'Layout' '" .. next_layout .. "'")
end

-- Focus left/right: column in scrolling, neighbouring window in dwindle
local function focus_horizontal(dir) -- "l" | "r"
    return function()
        if is_scrolling() then
            dispatch(layout("focus " .. dir))
        else
            dispatch(hl.dsp.focus({ direction = dir == "l" and "left" or "right" }))
        end
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

-- Equivalent of toggle-keyboard-shortcuts-inhibit: forbid/allow the active
-- window to grab compositor hotkeys (games, VMs, remote desktop).
local function toggle_shortcuts_inhibit()
    hl.dispatch(hl.dsp.window.set_prop({ prop = "no_shortcuts_inhibit", value = "toggle" }))
end

-- ════════════════════════════════════════════════════════════════════════
--  CHEAT SHEET
--  Every bind with a description shows up in `hyprctl binds` and in the
--  cheat sheet opened with Super+Shift+/ (a searchable list in fuzzel).
-- ════════════════════════════════════════════════════════════════════════
local CATEGORIES = {
    "Shell", "System", "Applications", "Windows and columns",
    "Navigation", "Workspaces", "Screenshots and recording",
}
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
local SHL, SYS, APP, WIN, NAV, WS, SHOT = table.unpack(CATEGORIES)

-- ════════════════════════════════════════════════════════════════════════
--  KEYBINDINGS
-- ════════════════════════════════════════════════════════════════════════

-- ── Shell (caelestia) ───────────────────────────────────────────────────
-- The "caelestia:launcher" global only toggles on key *release*, and the
-- release is lost when Super is let go before Space. Toggle the drawer
-- over Quickshell IPC instead: it fires on press, like Super+K.
bind(M .. "Space",     hl.dsp.exec_cmd("caelestia-shell ipc call drawers toggle launcher"),
                       SHL, "Launcher (type > for commands: >wallpaper, >scheme, >calc)")
bind(M .. "A",         shell("dashboard"),   SHL, "Dashboard (media, calendar, weather, performance)")
bind(M .. "SHIFT + N", shell("sidebar"),     SHL, "Sidebar (notifications, quick settings)")
bind(M .. "K",         shell("showall"),     SHL, "Show all panels")
bind(M .. "SHIFT + E", shell("session"),     SHL, "Session menu (log out, reboot, shut down)")
bind(M .. "L",         shell("lock"),        SHL, "Lock screen")
bind("CTRL + ALT + C", shell("clearNotifs"), SHL, "Clear notifications", { locked = true })
bind(M .. "V",         hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"),
                       SHL, "Clipboard history (+Alt - delete entries)", "Super+V / Alt+V")
bind(M .. "ALT + V",   hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
bind(M .. "ALT + period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"), SHL, "Emoji picker")
-- Restart the shell if it hangs or after an update
bind(M .. "CTRL + ALT + R", hl.dsp.exec_cmd("caelestia shell -k; sleep .3; caelestia-shell -d"),
                       SHL, "Restart caelestia shell", { release = true })

-- ── System ─────────────────────────────────────────────────────────────
-- (Super+Shift+/, the cheat sheet, is bound at the very end of the file)
bind(M .. "Escape",    toggle_shortcuts_inhibit, SYS, "Toggle shortcut inhibiting for window", { dont_inhibit = true })
bind(M .. "O",         dpms("disable"),          SYS, "Turn monitors off (Shift - on)", "Super+O / Shift+O")
bind(M .. "SHIFT + O", dpms("enable"))
-- [x] Mod+Shift+M / W / N (dynamic cast target): in Hyprland the cast source
--     is chosen in the xdg-desktop-portal-hyprland picker.

-- ── Layout switching ───────────────────────────────────────────────────
-- Caps Lock (keycode 66; its keysym is disabled by caps:none) switches
-- us/ru on every keyboard at once. The compositor consumes the key, so
-- XWayland only sees the new layout group and does not toggle it back
-- with its own copy of grp:caps_toggle; "all" keeps several keyboards
-- (Wooting, Logitech receiver) on the same layout.
bind("code:66", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"),
                SYS, "Switch keyboard layout (us / ru)", "Caps Lock", { locked = true })

-- ── Applications ───────────────────────────────────────────────────────
bind(M .. "Return",         hl.dsp.exec_cmd("kitty"),                        APP, "Terminal (kitty)")
bind(M .. "SHIFT + Return", hl.dsp.exec_cmd("kitty --hold sh -c fastfetch"), APP, "Terminal with fastfetch")
bind(M .. "B",              hl.dsp.exec_cmd("floorp"),                       APP, "Browser (Floorp)")
bind(M .. "E",              hl.dsp.exec_cmd("nautilus"),                     APP, "Files (Nautilus)")
bind(M .. "ALT + T",        hl.dsp.exec_cmd("Telegram"),                     APP, "Telegram")
bind(M .. "ALT + D",        hl.dsp.exec_cmd("vesktop"),                      APP, "Discord (Vesktop)")
bind(M .. "ALT + O",        hl.dsp.exec_cmd("onlyoffice-desktopeditors"),    APP, "OnlyOffice")
bind(M .. "N",              hl.dsp.exec_cmd("java -jar ~/mine/Ninjabrain-Bot-1.5.2.jar"), APP, "Ninjabrain Bot")
bind(M .. "J",              hl.dsp.exec_cmd("fcitx5-remote -t"),             APP, "Toggle fcitx5 input method")

-- ── Windows and columns ────────────────────────────────────────────────
bind(M .. "Q",         hl.dsp.window.close(),                    WIN, "Close window")
bind(M .. "T",         hl.dsp.window.float({ action = "toggle" }), WIN, "Toggle floating / tiled")
bind(M .. "Y",         switch_float_tile,                        WIN, "Focus: floating ⇄ tiled")
bind(M .. "P",         hl.dsp.window.pin(),                      WIN, "Pin floating window to all workspaces")
bind(M .. "F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }), WIN, "Fullscreen")
bind(M .. "SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" }),
                                                                 WIN, "Windowed fullscreen")
bind(M .. "M",         toggle_maximize_column(false),            WIN, "Maximize column")
bind(M .. "W",         toggle_maximize_column(true),             WIN, "Maximize and center column")
bind(M .. "C",         layout("center"),                         WIN, "Center column")
bind(M .. "SHIFT + C", layout("fit visible"),                    WIN, "Fit visible columns on screen")   -- [~]
bind(M .. "SHIFT + X", hl.dsp.group.toggle(),                    WIN, "Toggle window group (tabs)")        -- [~]
bind(M .. "SHIFT + T", toggle_layout,                            WIN, "Layout: scrolling ⇄ classic tiling (dwindle)")

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

-- Mouse: Super+LMB drags, Super+RMB resizes
bind(M .. "mouse:272", hl.dsp.window.drag(),   WIN, "Drag window", "Super+LMB", { mouse = true })
bind(M .. "mouse:273", hl.dsp.window.resize(), WIN, "Resize window", "Super+RMB", { mouse = true })

-- ── Navigation ─────────────────────────────────────────────────────────
bind(M .. "Left",  focus_horizontal("l"), NAV, "Focus column left / right (wraps)", "Super+← / →")
bind(M .. "Right", focus_horizontal("r"))
bind(M .. "Up",    focus_window_or_workspace("u"), NAV, "Focus window up / down, workspace at edge", "Super+↑ / ↓")
bind(M .. "Down",  focus_window_or_workspace("d"))
bind(M .. "SHIFT + grave", layout("focus u"), NAV, "Focus window up in column", "Super+Shift+`")

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

-- ── Workspaces ─────────────────────────────────────────────────────────
-- [x] no built-in overview: jump to the previous workspace
bind(M .. "Tab", hl.dsp.focus({ workspace = "previous" }), WS, "Previous workspace")

for i = 1, 10 do
    local key = i % 10 -- workspace 10 -> key 0
    if i == 1 then
        bind(M .. key,               hl.dsp.focus({ workspace = i }),       WS, "Go to workspace (0 = 10)", "Super+1…0")
        bind(M .. "SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), WS, "Move window to workspace", "Super+Shift+1…0")
    else
        bind(M .. key,               hl.dsp.focus({ workspace = i }))
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

-- Special workspace: a hidden scratchpad that slides over the current one
bind(M .. "S",       toggle_special,                                         WS, "Show / hide special workspace")
bind(M .. "ALT + S", hl.dsp.window.move({ workspace = "special:special" }), WS, "Move window to special workspace")

-- ── Screenshots and recording (caelestia) ──────────────────────────────
-- Area screenshots open the shell's area picker; the result goes to the
-- clipboard and a notification offers to edit it in swappy.
bind("Print",               shell("screenshot"),                     SHOT, "Screenshot area")
bind(M .. "SHIFT + S",      shell("screenshotFreeze"),               SHOT, "Screenshot area (frozen screen)")
bind("CTRL + Print",        hl.dsp.exec_cmd("caelestia screenshot"), SHOT, "Screenshot whole screen")
bind(M .. "ALT + R",        hl.dsp.exec_cmd("caelestia record -r"),  SHOT, "Record area (press again to stop)")
bind(M .. "CTRL + ALT + S", hl.dsp.exec_cmd("caelestia record -s"),  SHOT, "Record screen with sound (press again to stop)")

-- ── Media, volume, brightness (also work on the lock screen) ───────────
-- Volume goes through wpctl; caelestia shows its OSD by itself.
-- -l 1.0 caps the volume at 100%
bind("XF86AudioRaiseVolume",
     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"),
     { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),   { locked = true, repeating = true })
bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true })
bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Media keys control the player selected in the caelestia dashboard
bind("XF86AudioPlay",  shell("mediaToggle"), { locked = true })
bind("XF86AudioPause", shell("mediaToggle"), { locked = true })
bind("XF86AudioNext",  shell("mediaNext"),   { locked = true })
bind("XF86AudioPrev",  shell("mediaPrev"),   { locked = true })
bind("XF86AudioStop",  shell("mediaStop"),   { locked = true })

-- Brightness through the shell (brightnessctl on laptops, ddcutil on monitors)
bind("XF86MonBrightnessUp",   shell("brightnessUp"),   { locked = true, repeating = true })
bind("XF86MonBrightnessDown", shell("brightnessDown"), { locked = true, repeating = true })

-- ════════════════════════════════════════════════════════════════════════
--  BUILDING THE CHEAT SHEET
--  The text is generated from the bind descriptions above and written to a
--  temp file on every config load; Super+Shift+/ shows it in fuzzel.
-- ════════════════════════════════════════════════════════════════════════
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
