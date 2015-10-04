BINDING_HEADER_RENEWSPAM_HEADER = "RenewSpam"
BINDING_NAME_RENEWSPAM_BUFF = "Autocast Renew"
local tracking = {};
local last_cast = 0;

function RenewSpam_OnLoad()
	SLASH_RENEWSPAM1 = "/renewspam";
	SlashCmdList["RENEWSPAM"] = RenewSpam_Command;
end

function RenewSpam_Command(msg)
	RenewSpam_Buff();
end

function RenewSpam_Buff()

	local start, duration = GetSpellCooldown(139, "BOOKTYPE_SPELL");
	
	if( (GetTime() - last_cast > 1.5) and duration == 0) then
		for i = 1,40 do
			target = 'raid'..i
			if (UnitName(target) and CheckInteractDistance(target, 4) and ( (not tracking[target]) or (GetTime() - tracking[target] >= 10) ) ) then
				name,_,group,level,class,CLASS,zone,online,dead = GetRaidRosterInfo(i)
				if (not dead) then
					
					local hasRenew = RenewSpam_CheckForBuff(target, "Interface\\Icons\\Spell_Holy_Renew");
					--DEFAULT_CHAT_FRAME:AddMessage(target.." "..hasRenew);
					if(not hasRenew) then
						TargetUnit(target); 
						
						tracking[target] = GetTime();
						last_cast = GetTime();
						--DEFAULT_CHAT_FRAME:AddMessage(target.." "..tracking[target]);

						CastSpellByName("Renew(Rank 1)");
						break;
					end
				end
			end
		end
	end
end

function RenewSpam_CheckForBuff(unit, buff)
	local found = false;
	for i = 1,16 do
		buffTexture, buffApplications = UnitBuff(unit,i)
		if(not buffTexture) then
			break;
		elseif(buffTexture == buff) then
			found = true;
			break;
		end
	end
	return found;
end