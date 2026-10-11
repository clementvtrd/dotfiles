local ratio = 0.95 -- 95 % de la largeur et de la hauteur

local ignoredApps = {
	["Système Settings"] = true,
	["Calculator"] = true,
}

local function centerAndResize(win)
	if not win or not win:isStandard() then
		return
	end
	local app = win:application()
	if app and ignoredApps[app:name()] then
		return
	end

	local s = win:screen():frame() -- zone utile (hors barre de menus et Dock)
	local w, h = s.w * ratio, s.h * ratio
	win:setFrame({
		x = s.x + (s.w - w) / 2,
		y = s.y + (s.h - h) / 2,
		w = w,
		h = h,
	}, 0) -- 0 = sans animation
end

windowWatcher = hs.window.filter.new()
windowWatcher:subscribe(hs.window.filter.windowCreated, centerAndResize)
