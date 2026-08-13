hl.config({
	binds = {
		scroll_event_delay = 0,
	},
})

local throttled = false

local function throttled_dsp(dsp)
	return function()
		if throttled then
			return
		end
		throttled = true
		hl.dispatch(dsp)
		hl.timer(function()
			throttled = false
		end, {
			timeout = 200,
			type = "oneshot",
		})
	end
end

local prevWs = hl.dsp.focus({ workspace = "r+1" })
local nextWs = hl.dsp.focus({ workspace = "r-1" })

hl.bind("SUPER + mouse_down", throttled_dsp(prevWs))
hl.bind("SUPER + mouse_up", throttled_dsp(nextWs))
