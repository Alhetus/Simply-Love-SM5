-- only run in modified stepmania build 
if not SYNCMAN or not SYNCMAN:IsEnabled() then
  return Def.Actor{}
end

local MAX_PLAYER_COUNT = 6
local Y_FROM_BOTTOM = 30

local playerNameTexts = {}
local scoreTexts = {}

local t = Def.ActorFrame{
  SyncStartPlayerScoresChangedMessageCommand=function(self)
    self:queuecommand("UpdateScores")
  end,
  UpdateScoresCommand=function(self)
    local scores = SYNCMAN:GetCurrentPlayerScores()

    for i = 1, MAX_PLAYER_COUNT do
      local scoreIndex = (i - (MAX_PLAYER_COUNT - #scores))

      if scoreIndex > 0 and scoreIndex <= #scores then
        local score = scores[scoreIndex]
        playerNameTexts[i]:settext(score.playerName)
        scoreTexts[i]:settextf("%.2f", score.score * 100)
      else
        playerNameTexts[i]:settext("")
        scoreTexts[i]:settextf("")
      end 
    end
	end
}

for i = 1, MAX_PLAYER_COUNT do
  local playerIndex = MAX_PLAYER_COUNT - i + 1

  t[#t+1] = Def.BitmapText{
    Font="_miso",
    Text="",
    InitCommand=function(self)
      playerNameTexts[playerIndex] = self
      self:CenterX()
      self:align(0.5, 0.5)
      self:zoom(0.75)
      self:diffusealpha(0.5)
      self:y(SCREEN_HEIGHT - (i * 40) - Y_FROM_BOTTOM)
    end
  }

  t[#t+1] = Def.BitmapText{
    Font="_wendy small",
    Text="",
    InitCommand=function(self)
      scoreTexts[playerIndex] = self
      self:CenterX()
      self:align(0.5, 0.5)
      self:zoom(0.25)
      self:diffusealpha(0.5)
      self:y(SCREEN_HEIGHT - (i * 40) - Y_FROM_BOTTOM + 15)
    end
  }
end

return t
