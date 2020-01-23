--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function pluginsmanager()

	local tb_cop = {}

	update_translations(plugins, tb_cop)

	table.insert(tb_cop, { name = "Kuio by Rinnegatamante", path = "kuio.skprx", section = "KERNEL",  path2 = false, section2 = false })
	table.insert(tb_cop, { name = "MiniVitaTV by TheOfficialFloW vbeta0.2", path = "minivitatv.skprx", section = "KERNEL",  path2 = "ds3.skprx", section2 = "KERNEL" })

	--Init load configs
	tai.load()
	local partition = 0
	if tai[__UX0].exist then partition = __UX0
	elseif tai[__UR0].exist then partition = __UR0
	end

	local limtpm, scrollp, y1 = 8, {}, 70

	local section,sel_section = {},1
	local tmp={}
	for k,v in pairs(tai[partition].gameid) do
		--os.message(tostring(tai[partition].gameid[k].section))
		local scroll_tmp = newScroll( tai[partition].gameid[ k ].prx, limtpm)
		if scroll_tmp.maxim > 0 then
			table.insert(tmp, tai[partition].gameid[k].section)
		end
	end
	if #tmp > 1 then table.sort(tmp) end

	--*KERNEL,*main,*ALL...more
	for i=1,#tmp do
		if tmp[i]:upper() == "KERNEL" then
			table.insert(section, 1, tmp[i])
		elseif tmp[i]:upper() == "MAIN" then
			table.insert(section, 2, tmp[i])
		elseif tmp[i]:upper() == "ALL" then
			table.insert(section, 3, tmp[i])
		else
			table.insert(section, tmp[i])
		end
	end

	if tai[partition].gameid[ section[sel_section] ] then
		--os.message(tostring(#tai[partition].gameid[ section[sel_section] ].prx))
		scrollp = newScroll( tai[partition].gameid[ section[sel_section] ].prx, limtpm)
	else
		scrollp = newScroll( {}, limtpm)
	end

	while true do
		buttons.read()
		if back2 then back2:blit(0,0) end

		screen.print(480,18,LANGUAGE["UNINSTALLP_TITLE"],1.2,color.white, 0x0, __ACENTER)

		if not tai[partition].exist then screen.print(480,270,LANGUAGE["UNINSTALLP_NOCONFIG_FOUND"]..locations[partition],1.3,color.red, 0x0, __ACENTER)
		else

			if #section > 0 and scrollp.maxim > 0 then
				--Partitions
				local xRoot = 750
				local w = (960-xRoot)/#locations
				for i=1, #locations do
					if partition == i then
						draw.fillrect(xRoot,0,w,40, color.green:a(90))
					end
					screen.print(xRoot+(w/2), 12, locations[i], 1, color.white, color.blue, __ACENTER)
					xRoot += w
				end

				draw.fillrect(0,40,960,350,color.shine:a(25))

				screen.print(15,20, "*"..section[sel_section],1,color.yellow, 0x0)

				if tai[partition].gameid[ section[sel_section] ] then

					local y = y1

					for i=scrollp.ini, scrollp.lim do
						if i == scrollp.sel then draw.offsetgradrect(0,y-10,940,35,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

						if not files.exists(tai[partition].gameid[ section[sel_section] ].prx[i].path) then ccolor = color.orange else ccolor = color.white end
						screen.print(20,y, tai[partition].gameid[ section[sel_section] ].prx[i].path,1,ccolor,0x0)
						y+=40
					end
				end

				---- Draw Scroll Bar
				local ybar,hbar = y1-10, (limtpm*40)-4
				if scrollp.maxim >= limtpm then
					draw.fillrect(950,ybar-2,8,hbar,color.shine)
					local pos_height = math.max(hbar/scrollp.maxim, limtpm)
					--Bar Scroll
					draw.fillrect(950, ybar-2 + ((hbar-pos_height)/(scrollp.maxim-1))*(scrollp.sel-1), 8, pos_height, color.new(0,255,0))
				end

				screen.print(480,405,locations[partition].."tai/config.txt",1.3,color.green, 0x0, __ACENTER)

				if buttonskey then buttonskey:blitsprite(5,448,saccept) end
				screen.print(30,450,LANGUAGE["UNINSTALLP_PLUGIN"],1,color.white,color.black,__ALEFT)

				if buttonskey2 then buttonskey2:blitsprite(5,475,0) end
				if buttonskey2 then buttonskey2:blitsprite(35,475,1) end
				screen.print(70,475,LANGUAGE["UNINSTALLP_LEFTRIGHT_SECTION"],1,color.white,color.black,__ALEFT)

			else
				screen.print(480,270,LANGUAGE["UNINSTALLP_EMPTY"],1.3,color.red,0x0,__ACENTER)
			end
		end

		if buttonskey2 then buttonskey2:blitsprite(5,498,2) end
		if buttonskey2 then buttonskey2:blitsprite(35,498,3) end
		screen.print(70,500,LANGUAGE["LR_SWAP"],1,color.white,color.black,__ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(35,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)
		
		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------
		
		if buttons.released.cancel then break end

		--Exit
		if buttons.start then
			if change then
				os.message(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(250)
				buttons.homepopup(1)
				power.restart()
			end
			os.exit()
		end

		if scrollp.maxim > 0 then
			if buttons.up or buttons.analogly < -60 then scrollp:up() end
			if buttons.down or buttons.analogly > 60 then scrollp:down() end		

			if buttons.accept then
				if tai[partition].gameid[ section[sel_section] ] then

					table.remove(tai[partition].raw, tai[partition].gameid[section[sel_section]].prx[scrollp.sel].line)
					local name = files.nopath(tai[partition].gameid[ section[sel_section] ].prx[scrollp.sel].path:lower())

					--No delete
					if name != "adrenaline_kernel.skprx" then
						local subpath = tai[partition].gameid[ section[sel_section] ].prx[scrollp.sel].path
						if #subpath > 4 then
							--os.message("1\n"..subpath)
						--	files.delete(subpath)
						end
					end

					tai.sync(partition)
					tai.load()

					--Yamt
					if name == "yamt.suprx" then
						--os.message("yamt")
						if files.exists("ur0:tai/boot_config.txt") then
							local cont = {}
							for line in io.lines("ur0:tai/boot_config.txt") do
								if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
								table.insert(cont,line)
							end
							if cont then
								for i=#cont,1,-1 do
									if string.find(cont[i]:lower(), "ur0:tai/yamt.skprx", 1, true) or string.find(cont[i]:upper(), "YAMT", 1, true) then
										table.remove(cont,i)
									end
								end
								local file = io.open("ur0:tai/boot_config_backup.txt", "w+")
								for s,t in pairs(cont) do
									file:write(string.format('%s\n', tostring(t)))
								end
								file:close()
							end
						end
						--files.delete("ux0:tai/yamt.skprx")
						--files.delete("ur0:tai/yamt.skprx")
					end

					for i=#tb_cop,1,-1 do
						if name == tb_cop[i].path then
							if tb_cop[i].section2 and tai[partition].gameid[ tb_cop[i].section2 ] then
								del_plugin_tai(partition, tb_cop[i].section2, tb_cop[i].path2)
							end
						end
						if name == tb_cop[i].path2 then
							if tb_cop[i].section and tai[partition].gameid[ tb_cop[i].section ] then
								del_plugin_tai(partition, tb_cop[i].section, tb_cop[i].path)
							end
						end
					end

					--update
					if tai[partition].gameid[ section[sel_section] ] then
						scrollp = newScroll( tai[partition].gameid[ section[sel_section] ].prx, limtpm)
						if scrollp.maxim <= 0 then
							for i=1,#section do
								if section[sel_section] == section[i] then
									os.message(section[i])
									table.remove(section,i)
									sel_section +=1
									if sel_section > #section then sel_section = 1 end
									if tai[partition].gameid[ section[sel_section] ] then
										scrollp = newScroll( tai[partition].gameid[ section[sel_section] ].prx, limtpm)
									else
										scrollp = newScroll( {}, limtpm)
									end
									break
								end
							end
						end
					--else
					--	scrollp = newScroll( {}, limtpm)
					end
					change = true
					buttons.homepopup(0)
				end
			end

		end

		if tai[partition].exist then
			if buttons.released.right then
				sel_section +=1
				if sel_section > #section then sel_section = 1 end
				if tai[partition].gameid[ section[sel_section] ] then
					scrollp = newScroll( tai[partition].gameid[ section[sel_section] ].prx, limtpm)
				--else
				--	scrollp = newScroll( {}, limtpm)
				end
			end

			if buttons.released.left then
				sel_section -=1
				if sel_section < 1 then	sel_section = #section end
				if tai[partition].gameid[ section[sel_section] ] then
					scrollp = newScroll( tai[partition].gameid[ section[sel_section] ].prx, limtpm)
				--else
				--	scrollp = newScroll( {}, limtpm)
				end
			end
		end

		if buttons.released.l or buttons.released.r then
			if partition == __UX0 then partition = __UR0 else partition = __UX0 end
			if tai[partition].exist then
				sel_section = 1
				if tai[partition].gameid[ section[sel_section] ] then
					scrollp = newScroll( tai[partition].gameid[ section[sel_section] ].prx, limtpm)
				--else
				--	scrollp = newScroll( {}, limtpm)
				end
			end
		end

	end

end

function del_plugin_tai(mount, obj1, obj2)

	local idx = tai.find(mount, obj1, obj2)
	if idx then
		if name != "adrenaline_kernel.skprx" then
			local subpath = tai[mount].gameid[ obj1 ].prx[idx].path
			--delete plugin physical
			if #subpath > 4 then
				--os.message("2\n"..subpath)
				--files.delete(subpath)
			end
		end
	end

	tai.del(mount, obj1, obj2)
	tai.sync(mount)
	tai.load()

end
