local pss = ...
local t = Def.ActorFrame{}

-- flag (all fantastics except 1 ex): stars
t[#t+1] = LoadActor("./assets/half-star.png")..{
	OnCommand=function(self)
		if pss ~= nil and pss:GetTapNoteScores('TapNoteScore_Miss') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W5') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W4') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W3') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W2') == 1 then
			self:sleep(2)
			self:queuecommand('Animate')
		end
	end,
	AnimateCommand=function(self)
		self:rainbow()
		self:effectperiod(2 + 2 * math.random())
	end,
}

t[#t+1] = LoadActor("./assets/half-star.png")..{
	OnCommand=function(self)
		self:visible(false)
		if pss ~= nil and pss:GetTapNoteScores('TapNoteScore_Miss') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W5') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W4') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W3') == 0 and
				pss:GetTapNoteScores('TapNoteScore_W2') == 1 then
			self:sleep(9)
			self:queuecommand('Appear')
		end
	end,
	AppearCommand=function(self)
		self:visible(true)
		self:MaskSource(true)
		self:sleep(5)
		self:queuecommand('Animate')
	end,
	AnimateCommand=function(self)
		self:vibrate()
		local m = self:GetZoomedWidth() / 20
		self:effectmagnitude(m, m, m)
		self:sleep(5)
		self:queuecommand('Animate2')
	end,
	Animate2Command=function(self)
		local m = self:GetZoomedWidth() / 5
		self:effectmagnitude(m, m, m)
	end,
}


return t
