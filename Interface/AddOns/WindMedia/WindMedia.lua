-- 自用素材包
-- 作者：houshuu
-- 素材来自于各个地方无法一一列举了
-- 可以自己複製對應語言的一行代碼來模仿添加自己的材質哦~！
local LSM = LibStub("LibSharedMedia-3.0")
local region = 128
if GetLocale() == 'zhCN' then region = 4 end
if GetLocale() == 'zhTW' then region = 8 end

-- English 例子
-- LSM:Register("font", "Vistor", [[Interface\Addons\WindMedia\font\EN_Vistor.ttf]], region) 

-- 简体 例子
if region == 4 then
	-- LSM:Register("font", "思源黑体 Heavy", [[Interface\Addons\WindMedia\font\CN_Siyuan_Heavy.ttf]], region)
	LSM:Register("font", "01", [[Interface\Fonts\001.ttf]], region)
	LSM:Register("font", "02", [[Interface\Fonts\002.ttf]], region)
	LSM:Register("font", "03", [[Interface\Fonts\003.ttf]], region)
	LSM:Register("font", "04", [[Interface\Fonts\004.ttf]], region)
	LSM:Register("font", "05", [[Interface\Fonts\005.ttf]], region)
	LSM:Register("font", "06", [[Interface\Fonts\006.ttf]], region)
	LSM:Register("font", "07", [[Interface\Fonts\007.ttf]], region)
	LSM:Register("font", "08", [[Interface\Fonts\008.ttf]], region)
    LSM:Register("font", "09", [[Interface\Fonts\009.ttf]], region)
end
-- 正體  例子
if region == 8 then
	-- LSM:Register("font", "思源黑體 Heavy", [[Interface\Addons\WindMedia\font\CN_Siyuan_Heavy.ttf]], region) 
end

-- 状态条材质
-- ElvUI_CustomMedia
LSM:Register("statusbar", "ElvUI_01", [[Interface\Addons\WindMedia\statusbar\ElvUI A.tga]]) 
LSM:Register("statusbar", "ElvUI_02", [[Interface\Addons\WindMedia\statusbar\ElvUI B.tga]]) 
LSM:Register("statusbar", "ElvUI_03", [[Interface\Addons\WindMedia\statusbar\ElvUI C.tga]]) 
LSM:Register("statusbar", "ElvUI_04", [[Interface\Addons\WindMedia\statusbar\ElvUI D.tga]]) 
LSM:Register("statusbar", "ElvUI_05", [[Interface\Addons\WindMedia\statusbar\ElvUI E.tga]]) 
LSM:Register("statusbar", "ElvUI_06", [[Interface\Addons\WindMedia\statusbar\ElvUI F.tga]]) 
LSM:Register("statusbar", "ElvUI_07", [[Interface\Addons\WindMedia\statusbar\ElvUI G.tga]]) 
LSM:Register("statusbar", "ElvUI_08", [[Interface\Addons\WindMedia\statusbar\ElvUI H.tga]]) 
LSM:Register("statusbar", "ElvUI_09", [[Interface\Addons\WindMedia\statusbar\ElvUI I.tga]]) 
LSM:Register("statusbar", "ElvUI_10", [[Interface\Addons\WindMedia\statusbar\ElvUI J.tga]]) 
LSM:Register("statusbar", "ElvUI_11", [[Interface\Addons\WindMedia\statusbar\ElvUI K.tga]]) 
LSM:Register("statusbar", "ElvUI_12", [[Interface\Addons\WindMedia\statusbar\ElvUI L.tga]]) 
LSM:Register("statusbar", "ElvUI_13", [[Interface\Addons\WindMedia\statusbar\ElvUI M.tga]]) 
LSM:Register("statusbar", "ElvUI_14", [[Interface\Addons\WindMedia\statusbar\ElvUI N.tga]]) 
LSM:Register("statusbar", "ElvUI_15", [[Interface\Addons\WindMedia\statusbar\ElvUI O.tga]]) 
LSM:Register("statusbar", "ElvUI_16", [[Interface\Addons\WindMedia\statusbar\ElvUI P.tga]])
-- FreeUI.Fluffy
LSM:Register("statusbar", "ElvUI_17", [[Interface\Addons\WindMedia\statusbar\FF_Angelique.tga]]) 
LSM:Register("statusbar", "ElvUI_18", [[Interface\Addons\WindMedia\statusbar\FF_Antonia.tga]]) 
LSM:Register("statusbar", "ElvUI_19", [[Interface\Addons\WindMedia\statusbar\FF_Bettina.tga]]) 
LSM:Register("statusbar", "ElvUI_20", [[Interface\Addons\WindMedia\statusbar\FF_Jasmin.tga]]) 
LSM:Register("statusbar", "ElvUI_21", [[Interface\Addons\WindMedia\statusbar\FF_Larissa.tga]]) 
LSM:Register("statusbar", "ElvUI_22", [[Interface\Addons\WindMedia\statusbar\FF_Lisa.tga]])
LSM:Register("statusbar", "ElvUI_23", [[Interface\Addons\WindMedia\statusbar\FF_Sam.tga]])
LSM:Register("statusbar", "ElvUI_24", [[Interface\Addons\WindMedia\statusbar\FF_Stella.tga]])
-- 风行丨GG @ NGA
LSM:Register("statusbar", "A01", [[Interface\Addons\WindMedia\statusbar\FX_001.tga]])
LSM:Register("statusbar", "A02", [[Interface\Addons\WindMedia\statusbar\FX_002.tga]])
LSM:Register("statusbar", "A03", [[Interface\Addons\WindMedia\statusbar\FX_003.tga]])
LSM:Register("statusbar", "A04", [[Interface\Addons\WindMedia\statusbar\FX_004.tga]])
LSM:Register("statusbar", "A004", [[Interface\Addons\WindMedia\statusbar\009.tga]])
LSM:Register("statusbar", "MaUI1", [[Interface\Addons\WindMedia\statusbar\MaUI1.blp]])
LSM:Register("statusbar", "MaUI2", [[Interface\Addons\WindMedia\statusbar\MaUI2.blp]])
LSM:Register("statusbar", "MaUI3", [[Interface\Addons\WindMedia\statusbar\MaUI3.blp]])
LSM:Register("statusbar", "MaUI4", [[Interface\Addons\WindMedia\statusbar\MaUI4.blp]])
LSM:Register("statusbar", "MaUI5", [[Interface\Addons\WindMedia\statusbar\MaUI5.blp]])
LSM:Register("statusbar", "MaUI6", [[Interface\Addons\WindMedia\statusbar\MaUI6.blp]])
LSM:Register("statusbar", "MaUI7", [[Interface\Addons\WindMedia\statusbar\MaUI7.blp]])
LSM:Register("statusbar", "MaUI8", [[Interface\Addons\WindMedia\statusbar\MaUI8.blp]])
LSM:Register("statusbar", "MaUI9", [[Interface\Addons\WindMedia\statusbar\MaUI9.blp]])
LSM:Register("statusbar", "MaUI10", [[Interface\Addons\WindMedia\statusbar\MaUI10.blp]])
LSM:Register("statusbar", "MaUI11", [[Interface\Addons\WindMedia\statusbar\MaUI11.blp]])
LSM:Register("statusbar", "MaUI12", [[Interface\Addons\WindMedia\statusbar\MaUI12.blp]])
-- 自作
LSM:Register("statusbar", "Wind_1", [[Interface\Addons\WindMedia\statusbar\WindTools_1.tga]])
-- 随便收集的
LSM:Register("statusbar", "Wind_2", [[Interface\Addons\WindMedia\statusbar\WindTools_2.tga]])

---------------------plater
LSM:Register("statusbar", "11StripesOverlay",				[[Interface\AddOns\SharedMedia_MyMedia\background\StripesOverlay.tga]])
LSM:Register("statusbar", "11Stripes",				[[Interface\AddOns\SharedMedia_MyMedia\background\Stripes.tga]])
LSM:Register("statusbar", "11Stripes2",				[[Interface\AddOns\SharedMedia_MyMedia\background\Stripes2.tga]])
LSM:Register("statusbar", "11StripesOverlay2",				[[Interface\AddOns\SharedMedia_MyMedia\background\StripesOverlay2.tga]])
LSM:Register("statusbar", "11Statusbar",				[[Interface\AddOns\SharedMedia_MyMedia\background\Statusbar2]])
LSM:Register("statusbar", "11RenStripe3L",				[[Interface\AddOns\SharedMedia_MyMedia\background\RenStripe3L]])
LSM:Register("statusbar", "11StatusBar3",				[[Interface\AddOns\SharedMedia_MyMedia\background\StatusBar3]])
LSM:Register("statusbar", "11Neonbar",				[[Interface\AddOns\SharedMedia_MyMedia\background\Neon_Bar]])
LSM:Register("statusbar", "11Neon_Bar_Backdrop",				[[Interface\AddOns\SharedMedia_MyMedia\background\Neon_Bar_Backdrop]])
LSM:Register("statusbar", "11nameplate_bar",				[[Interface\AddOns\SharedMedia_MyMedia\background\nameplate_bar]])
LSM:Register("statusbar", "11cast_bar",				[[Interface\AddOns\SharedMedia_MyMedia\background\cast_bar]])
LSM:Register("statusbar", "11nameplate_bar2",				[[Interface\AddOns\SharedMedia_MyMedia\background\nameplate_bar2]])
LSM:Register("statusbar", "11Neon_HealthOverlay",				[[Interface\AddOns\SharedMedia_MyMedia\background\Neon_HealthOverlay]])
LSM:Register("statusbar", "11Stripes",				[[Interface\AddOns\SharedMedia_MyMedia\background\Stripes]])
LSM:Register("statusbar", "11RenStripe3LL",				[[Interface\AddOns\SharedMedia_MyMedia\background\RenStripe3LL]])
LSM:Register("statusbar", "11stippled-bar",				[[Interface\AddOns\SharedMedia_MyMedia\background\stippled-bar]])
LSM:Register("statusbar", "11mMedia6b",				[[Interface\AddOns\SharedMedia_MyMedia\background\mMedia6b]])
LSM:Register("statusbar", "11Bar5",				[[Interface\AddOns\SharedMedia_MyMedia\background\Bar5]])
LSM:Register("statusbar", "11Bar5Sd",				[[Interface\AddOns\SharedMedia_MyMedia\background\Bar5Sd]])
LSM:Register("statusbar", "11Bar5Glow",				[[Interface\AddOns\SharedMedia_MyMedia\background\Bar5Glow]])
LSM:Register("statusbar", "11Bar5Fill",				[[Interface\AddOns\SharedMedia_MyMedia\background\Bar5Fill]])
LSM:Register("statusbar", "11Bar7",				[[Interface\AddOns\SharedMedia_MyMedia\background\Bar7]])
LSM:Register("statusbar", "11statusbar-glass",				[[Interface\AddOns\SharedMedia_MyMedia\background\statusbar-glass]])
LSM:Register("statusbar", "11statusbar-texture",				[[Interface\AddOns\SharedMedia_MyMedia\background\statusbar-texture]])
LSM:Register("statusbar", "11statusbar-normal",				[[Interface\AddOns\SharedMedia_MyMedia\background\statusbar-normal]])
LSM:Register("statusbar", "11mUI_3",				[[Interface\AddOns\SharedMedia_MyMedia\background\mUI_3]])
LSM:Register("statusbar", "11k9",				[[Interface\AddOns\SharedMedia_MyMedia\background\k9]])
LSM:Register("statusbar", "11n16",				[[Interface\AddOns\SharedMedia_MyMedia\background\n16]])
LSM:Register("statusbar", "11n19",				[[Interface\AddOns\SharedMedia_MyMedia\background\n19]])



--Shift+鼠标左键指向设置焦点
local modifier = "shift" -- shift, alt or ctrl
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any

local function SetFocusHotkey(frame)
	frame:SetAttribute(modifier.."-type"..mouseButton,"focus")
end

local function CreateFrame_Hook(type, name, parent, template)
	if template == "SecureUnitButtonTemplate" then
		SetFocusHotkey(_G[name])
	end
end

hooksecurefunc("CreateFrame", CreateFrame_Hook)

-- Keybinding override so that models can be shift/alt/ctrl+clicked
local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
f:SetAttribute("type1","macro")
f:SetAttribute("macrotext","/focus mouseover")
SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton")

-- Set the keybindings on the default unit frames since we won't get any CreateFrame notification about them
local duf = {
	PlayerFrame,
	PetFrame,
	PartyMemberFrame1,
	PartyMemberFrame2,
	PartyMemberFrame3,
	PartyMemberFrame4,
	PartyMemberFrame1PetFrame,
	PartyMemberFrame2PetFrame,
	PartyMemberFrame3PetFrame,
	PartyMemberFrame4PetFrame,
	TargetFrame,
	TargetofTargetFrame,
	ElvUF_Player,
	ElvUF_Target,
	ElvUF_TargetTarget,
	ElvUF_PartyGroup1UnitButton1,
    ElvUF_PartyGroup1UnitButton2,
	ElvUF_PartyGroup1UnitButton3,
	ElvUF_PartyGroup1UnitButton4,
	ElvUF_PartyGroup1UnitButton5,
    ElvUF_Raid40Group1UnitButton1,
	ElvUF_Raid40Group1UnitButton2,
	ElvUF_Raid40Group1UnitButton3,
	ElvUF_Raid40Group1UnitButton4,
	ElvUF_Raid40Group1UnitButton5,
    ElvUF_Raid40Group2UnitButton1,
	ElvUF_Raid40Group2UnitButton2,
	ElvUF_Raid40Group2UnitButton3,
	ElvUF_Raid40Group2UnitButton4,
	ElvUF_Raid40Group2UnitButton5,
    ElvUF_Raid40Group3UnitButton1,
	ElvUF_Raid40Group3UnitButton2,
	ElvUF_Raid40Group3UnitButton3,
	ElvUF_Raid40Group3UnitButton4,
	ElvUF_Raid40Group3UnitButton5,
    ElvUF_Raid40Group4UnitButton1,
	ElvUF_Raid40Group4UnitButton2,
	ElvUF_Raid40Group4UnitButton3,
	ElvUF_Raid40Group4UnitButton4,
	ElvUF_Raid40Group4UnitButton5,
    ElvUF_Raid40Group5UnitButton1,
	ElvUF_Raid40Group5UnitButton2,
	ElvUF_Raid40Group5UnitButton3,
	ElvUF_Raid40Group5UnitButton4,
	ElvUF_Raid40Group5UnitButton5,
    ElvUF_Raid40Group6UnitButton1,
	ElvUF_Raid40Group6UnitButton2,
	ElvUF_Raid40Group6UnitButton3,
	ElvUF_Raid40Group6UnitButton4,
	ElvUF_Raid40Group6UnitButton5,
    ElvUF_Raid40Group7UnitButton1,
	ElvUF_Raid40Group7UnitButton2,
	ElvUF_Raid40Group7UnitButton3,
	ElvUF_Raid40Group7UnitButton4,
	ElvUF_Raid40Group7UnitButton5,
    ElvUF_Raid40Group8UnitButton1,
	ElvUF_Raid40Group8UnitButton2,
	ElvUF_Raid40Group8UnitButton3,
	ElvUF_Raid40Group8UnitButton4,
	ElvUF_Raid40Group8UnitButton5,
     ElvUF_Boss1,
                ElvUF_Boss2,
                ElvUF_Boss3,
                ElvUF_Boss4,
                ElvUF_Boss5,
    }

for i,frame in pairs(duf) do
	SetFocusHotkey(frame)
end

--alt点击批量购买
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick 
function MerchantItemButton_OnModifiedClick(self, ...) 
   if ( IsAltKeyDown() ) then 
      local itemLink = GetMerchantItemLink(self:GetID()) 
      if not itemLink then return end 
      local maxStack = select(8, GetItemInfo(itemLink)) 
      if ( maxStack and maxStack > 1 ) then 
         BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID())) 
      end 
   end 
   savedMerchantItemButton_OnModifiedClick(self, ...) 
end

--自动Delete
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"],"OnShow",function(boxEditor) boxEditor.editBox:SetText(DELETE_ITEM_CONFIRM_STRING) end)

--聊天敏感词汇过滤关闭
--SET profanityFilter "0"
SetCVar("profanityFilter", 0) ReloadUI()