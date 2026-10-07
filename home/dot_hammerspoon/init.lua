local ignoredApps = {
	["Système Settings"] = true,
	["Calculator"] = true,
}

local function maximize(win)
	if not win or not win:isStandard() then
		return
	end
	local app = win:application()
	if app and ignoredApps[app:name()] then
		return
	end

	win:maximize(0) -- zone utile (hors barre de menus et Dock), sans animation
end

windowWatcher = hs.window.filter.new()
windowWatcher:subscribe(hs.window.filter.windowCreated, maximize)

-- init.lua est ré-exécuté à chaque rechargement : on applique la règle aux fenêtres existantes
for _, win in ipairs(windowWatcher:getWindows()) do
	maximize(win)
end
