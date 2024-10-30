local E, L, V, P, G = unpack(ElvUI)
local HMO = E:NewModule("HealerManaOnly", "AceEvent-3.0")
local UF = E:GetModule("UnitFrames")

local _G = _G
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected

local function SetHealerManaOnly(header)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton then
				unitbutton.Power:Hide()
                unitbutton.BOTTOM_OFFSET = 0
                local role = UnitGroupRolesAssigned(unitbutton.unit)
                if UnitIsConnected(unitbutton.unit) and role == "HEALER" then
                    unitbutton.Power:Show()
                    unitbutton.BOTTOM_OFFSET = UF:GetHealthBottomOffset(unitbutton)
                end
                UF:Configure_HealthBar(unitbutton)
			end
		end
	end
end

local function ElvUIHealerManaOnly()
    SetHealerManaOnly(_G["ElvUF_Party"])
    SetHealerManaOnly(_G["ElvUF_Raid"])
    SetHealerManaOnly(_G["ElvUF_Raid40"])
end

function HMO:Initialize()
    self:RegisterEvent("GROUP_ROSTER_UPDATE", ElvUIHealerManaOnly)
    E:Delay(.1, ElvUIHealerManaOnly)
end

local function InitializeCallback()
    HMO:Initialize()
end

E:RegisterModule(HMO:GetName(), InitializeCallback)
