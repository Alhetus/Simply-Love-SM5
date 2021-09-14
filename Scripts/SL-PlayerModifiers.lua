function PlayerModifiersString(player)
	local pn = ToEnumShortString(player)

	-- grab the song options from this PlayerState
	local PlayerOptions = GAMESTATE:GetPlayerState(player):GetPlayerOptionsArray("ModsLevel_Preferred")
	-- start with an empty string...
	local optionslist = ""

	-- if the player used an XMod of 1x, it won't be in PlayerOptions list
	-- so check here, and add it in manually if necessary
	if SL[pn].ActiveModifiers.SpeedModType == "X" and SL[pn].ActiveModifiers.SpeedMod == 1 then
		optionslist = "1x, "
	end

	--  ...and append options to that string as needed
	for i,option in ipairs(PlayerOptions) do
		-- these don't need to show up in the mods list
		if option ~= "FailAtEnd" and option ~= "FailImmediateContinue" and option ~= "FailImmediate" then
			-- 100% Mini will be in the PlayerOptions as just "Mini" so use the value from the SL table instead
			if option:match("Mini") then
				option = SL[pn].ActiveModifiers.Mini .. " Mini"
			end

			if option:match("Cover") then
				option = THEME:GetString("OptionNames", "Cover")
			end

			if i < #PlayerOptions then
				optionslist = optionslist..option..", "
			else
				optionslist = optionslist..option
			end
		end
	end

	-- Display TimingWindowScale as a modifier if it's set to anything other than 1
	local TimingWindowScale = PREFSMAN:GetPreference("TimingWindowScale")
	if TimingWindowScale ~= 1 then
		optionslist = optionslist .. ", " .. (ScreenString("TimingWindowScale")):format(TimingWindowScale*100)
	end

	return optionslist
end
