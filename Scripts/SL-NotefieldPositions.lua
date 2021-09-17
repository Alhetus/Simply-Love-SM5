-- linear interpolation between value1 and value2
Lerp = function(value1, value2, percent)
	return value1 * (1 - percent) + value2 * percent
end

-- used in theme metrics that are fetched by SLGameplayMargins
GetPlayer1NotefieldX = function()
	local percent = SL.P1.ActiveModifiers.NotefieldPositionX:gsub("%%","") / 100
	local halfNotefieldWidth = GetNotefieldWidth(PLAYER_1) / 2

	-- player1 min X pos is left edge of screen plus notefield size offset
	local minXPosition = halfNotefieldWidth
	-- player1 max X pos is center of screen minus notefield size offset
	local maxXPosition = _screen.cx - halfNotefieldWidth

	-- interpolate between min and max
	return math.round(Lerp(minXPosition, maxXPosition, percent))
end

-- used in theme metrics that are fetched by SLGameplayMargins
GetPlayer2NotefieldX = function()
	local percent = SL.P2.ActiveModifiers.NotefieldPositionX:gsub("%%","") / 100
	local halfNotefieldWidth = GetNotefieldWidth(PLAYER_2) / 2

	-- player2 min X pos is center of screen plus notefield size offset
	local minXPosition = _screen.cx + halfNotefieldWidth
	-- player2 max X pos is right edge of screen minus notefield size offset
	local maxXPosition = _screen.w - halfNotefieldWidth

	-- interpolate between min and max
	return math.round(Lerp(minXPosition, maxXPosition, percent))
end

-- StepMania has no per player settings for notefield height so we're going to keep track of the previously handled players
-- so we can apply the notefield Y position for the correct player
lastPlayerSetInGetNotefieldY = PLAYER_2
lastPlayerSetInGetNotefieldYReverse = PLAYER_2
minNotefieldYPos = -125
maxNotefieldYPos = 140
minNotefieldYPosReverse = 145
maxNotefieldYPosReverse = -120

-- call this before starting gameplay of a new song
ResetPlayerNoteFieldPositioningState = function()
	lastPlayerSetInGetNotefieldY = PLAYER_2
	lastPlayerSetInGetNotefieldYReverse = PLAYER_2
end

local GetPlayerToSetNotefieldFor = function()
	local humanPlayers = GAMESTATE:GetHumanPlayers()
	local playerCount = #humanPlayers

	-- if there is only one player joined, just return that player
	if (playerCount == 1) then
		return humanPlayers[1]
	end

	-- if there are 2 players we will see which one was set last time
	if (lastPlayerSetInGetNotefieldY == PLAYER_2 and lastPlayerSetInGetNotefieldYReverse == PLAYER_2) then
		lastPlayerSetInGetNotefieldY = PLAYER_1
		return PLAYER_1
	elseif (lastPlayerSetInGetNotefieldY == PLAYER_1 and lastPlayerSetInGetNotefieldYReverse == PLAYER_2) then
		lastPlayerSetInGetNotefieldYReverse = PLAYER_1
		return PLAYER_1
	elseif (lastPlayerSetInGetNotefieldY == PLAYER_1 and lastPlayerSetInGetNotefieldYReverse == PLAYER_1) then
		lastPlayerSetInGetNotefieldY = PLAYER_2
		return PLAYER_2
	elseif (lastPlayerSetInGetNotefieldY == PLAYER_2 and lastPlayerSetInGetNotefieldYReverse == PLAYER_1) then
		lastPlayerSetInGetNotefieldYReverse = PLAYER_2
		return PLAYER_2
	end
end

local GetPlayerNotefieldPositionY = function(player)
	if (player == PLAYER_1) then
		return SL.P1.ActiveModifiers.NotefieldPositionY:gsub("%%","") / 100
	else
		return SL.P2.ActiveModifiers.NotefieldPositionY:gsub("%%","") / 100
	end
end

GetNotefieldY = function()
	local currentPlayer = GetPlayerToSetNotefieldFor()
	local playerOptions = GAMESTATE:GetPlayerState(currentPlayer):GetPlayerOptions("ModsLevel_Preferred")

	-- if playing on reverse return the default position
	if (playerOptions:UsingReverse()) then
		return minNotefieldYPos
	end

	local percent = GetPlayerNotefieldPositionY(currentPlayer)

	-- interpolate between min and max
	return math.round(Lerp(minNotefieldYPos, maxNotefieldYPos, percent))
end

GetNotefieldYReverse = function()
	local currentPlayer = GetPlayerToSetNotefieldFor()
	local playerOptions = GAMESTATE:GetPlayerState(currentPlayer):GetPlayerOptions("ModsLevel_Preferred")

	-- if NOT playing on reverse return the default position
	if (not playerOptions:UsingReverse()) then
		return minNotefieldYPosReverse
	end

	local percent = GetPlayerNotefieldPositionY(currentPlayer)

	-- interpolate between min and max, take reverse into account
	return math.round(Lerp(minNotefieldYPosReverse, maxNotefieldYPosReverse, percent))
end

-- In the MarginFunction defined in the fallback theme, the positions of players' notefields affect each other.
-- That's bad, so we'll define our own that doesn't define center margins at all.
SLGameplayMargins = function(enabledPlayers, styleType)
	if Center1Player() then
		return 0, 0, 0
	end

	local left = 0
	local right = 0

	for i, pn in ipairs(enabledPlayers) do
		local notefieldCenter = THEME:GetMetric("ScreenGameplay", "Player"..ToEnumShortString(pn)..ToEnumShortString(styleType).."X")
		local distanceToCenter = math.abs(_screen.cx - notefieldCenter)

		if pn == PLAYER_1 then
			left = _screen.cx - distanceToCenter * 2
		elseif pn == PLAYER_2 then
			right = _screen.w - (_screen.cx + distanceToCenter * 2)
		end
	end

	return left, 0, right
end
