local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")

local vicious = require("vicious")

wibox.widget {
  font = "Font Awesome 6 Free"
}

local textbox = wibox.widget.textbox()

textbox.font = "Font Awesome 6 Free, 10"

local spacer = wibox.widget.textbox()
local separator = wibox.widget.textbox()
spacer:set_text(" ")
separator:set_text(" | ")



local cpu = vicious.register(wibox.widget.textbox(), vicious.widgets.cpu, '<span foreground="#89b4fa"> $1%</span>')
cpu.font = "Font Awesome 6 Free, 10"

local battery = vicious.register(textbox, function(format, warg)
  local args = vicious.widgets.bat(format, warg)
  if args[2] < 100 then
    args['{color}'] = '#a6e3a1'
    args['{icon}'] = ""
  elseif args[2] < 50 then
    args['{color}'] = '#f9e2af'
    args['{icon}'] = ""
  elseif args[2] < 30 then
    args['{color}'] = '#f38ba8'
    args['{icon}'] = ""
  elseif args[2] < 30 then
    args['{color}'] = 'red'
    args['{icon}'] = ""
  else
    args['{color}'] = '#a6e3a1'
  end
  return args
end, '<span foreground="${color}">${icon}: $2% </span>', 10, 'BAT0')

-- Weather widget
local myweatherwidget = wibox.widget.textbox()
myweatherwidget.font = "Font Awesome 6 Free, 10"
local weather_t = awful.tooltip({ objects = { myweatherwidget }, })
vicious.register(myweatherwidget, vicious.widgets.weather,
  function(widget, args)
    weather_t:set_text("City: " ..
      args["{city}"] ..
      "\nWind: " ..
      args["{windkmh}"] ..
      "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
    return "<span foreground='#cba6f7'> " .. args["{tempc}"] .. "C </span>"
  end, 1800, "VAPO")
--'1800': check every 30 minutes.
--'EDDN': Nuernberg ICAO code.

-- memory widget
local memwidget = wibox.widget.textbox()
memwidget.font = "Font Awesome 6 Free, 10"
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "<span foreground='#f7768e'> $1%</span>", 13)

local widgetsConfig = {
  spacer = spacer,
  separator = separator,
  cpu = cpu,
  battery = battery,
  weather = myweatherwidget,
  mytextclock = wibox.widget.calendar.month(os.date('*t')),
  memory = memwidget
}


return widgetsConfig
