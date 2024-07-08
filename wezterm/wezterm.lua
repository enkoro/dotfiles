local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Kanagawa (Gogh)'
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 14.0
config.use_fancy_tab_bar = false

config.colors = {
  tab_bar = {
    background = '#24242d',
    active_tab = {
      bg_color = '#43434c',
      fg_color = '#c8c3a6',
      intensity = 'Normal',
    },
    inactive_tab = {
      bg_color = '#24242d',
      fg_color = '#c8c3a6',
    },
    new_tab = {
      bg_color = '#24242d',
      fg_color = '#c8c3a6',
    },
    new_tab_hover = {
      bg_color = '#24242d',
      fg_color = '#c8c3a6',
    },
  },
}

wezterm.on('update-right-status', function(window, pane)
  -- "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %H:%M '

  local bat = ''
  for _, b in ipairs(wezterm.battery_info()) do
    local bi = '󰴔 '
    if b.state ~= 'Discharging' then
      bi = '󰻹 '
    else
      if b.state_of_charge > 0.85 then
        bi = '󰣐 '
      elseif b.state_of_charge > 0.5 then
        bi = '󰛞 '
      elseif b.state_of_charge > 0.25 then
        bi = '󰛟 '
      elseif b.state_of_charge > 0.15 then
        bi = '󰛠 '
      end
    end
    bat = bi .. string.format('%.0f%%', b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format {
    { Text = bat .. '   ' .. date },
  })
end)

-- Keybindings
local act = wezterm.action
config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = '"',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '\'',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = act.CloseCurrentTab { confirm = true },
  },
}

-- Tab keys
for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- and finally, return the configuration to wezterm
return config
