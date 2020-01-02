--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--Funciones PSP
dofile("scripts/psp/npdrm.lua")
dofile("scripts/psp/pspctrls.lua")
dofile("scripts/psp/pluginspsp.lua")

function menu_psp()

	local npdrm_callback = function ()
		npdrm_free()
	end

	local psp_ctrls_callback = function ()
		psp_ctrls()
	end

	local psp_plugins_callback = function ()
		pluginsPSP()
	end

	local menu = {
		{ text = LANGUAGE["MENU_PSP_INSTALL_NPDRMFREE"],		desc = LANGUAGE["MENU_PSP_NPDRMFREE_DESC"],	funct = npdrm_callback },
		{ text = LANGUAGE["MENU_PSP_INSTALL_REMASTERED_CTRLS"],	desc = LANGUAGE["MENU_PSP_PSPCTRLS_DESC"],	funct = psp_ctrls_callback },
		{ text = LANGUAGE["MENU_PSP_INSTALL_PLUGINS"],			desc = LANGUAGE["MENU_PSP_PLUGINS_DESC"],	funct = psp_plugins_callback },
	}
	local scroll = newScroll(menu,#menu)

	local xscroll = 10
	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSP_TITLE"],1.2,color.white,0x0,__ACENTER)

		local y = 145
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			screen.print(480,y,menu[i].text,1.2,color.white,0x0,__ACENTER)
			y += 45
		end

		if screen.textwidth(menu[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 520, menu[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 520, menu[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		screen.flip()

		--Controls
		if buttons.up or buttons.analogly < -60 then
			if scroll:up() then xscroll = 10 end
		end
		if buttons.down or buttons.analogly > 60 then
			if scroll:down() then xscroll = 10 end
		end

		if buttons.cancel then break end
		if buttons.accept then menu[scroll.sel].funct() end

	end
end

