local E, L, V, P, G = unpack(ElvUI)
local HMO = E:NewModule("HealerManaOnly", "AceEvent-3.0")
local UF = E:GetModule("UnitFrames")

local _G = _G
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local function SetHideMana(frame)
    local role = UnitGroupRolesAssigned(frame.unit)
    if role ~= "NONE" then
        if not frame.Power:IsShown() then frame.Power:Show() end
        if frame.BOTTOM_OFFSET == 0 then frame.BOTTOM_OFFSET = UF:GetHealthBottomOffset(frame) end
        if role == "DAMAGER" then--不要T的 改成  if role == "DAMAGER" or role == "TANK" then
            frame.Power:Hide()
            frame.BOTTOM_OFFSET = 0
        end
        UF:Configure_HealthBar(frame)
    end
end

local function FramesEnable(header)
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        for j = 1, group:GetNumChildren() do
            local frame = select(j, group:GetChildren())
            if frame then
                SetHideMana(frame)
            end
        end
    end
end

function HMO:ElvUIHideMana()
    if _G["ElvUF_Party"] then FramesEnable(_G["ElvUF_Party"]) end
    if _G["ElvUF_Raid"] then FramesEnable(_G["ElvUF_Raid"]) end
    if _G["ElvUF_Raid40"] then FramesEnable(_G["ElvUF_Raid40"]) end
end

function HMO:Initialize()
    self:ElvUIHideMana()
    self:RegisterEvent("GROUP_ROSTER_UPDATE", function()
        E:Delay(.1, HMO.ElvUIHideMana)
    end)
end

local function InitializeCallback()
    HMO:Initialize()
end

E:RegisterModule(HMO:GetName(), InitializeCallback)
