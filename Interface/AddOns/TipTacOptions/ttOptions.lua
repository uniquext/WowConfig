local cfg = TipTac_Config;
local MOD_NAME = ...;
local PARENT_MOD_NAME = "TipTac";

-- 获取库
local LibFroznFunctions = LibStub:GetLibrary("LibFroznFunctions-1.0");
local LibSerialize = LibStub:GetLibrary("LibSerialize");
local LibDeflate = LibStub:GetLibrary("LibDeflate");

-- 常量
local TT_OPTIONS_CATEGORY_LIST_WIDTH = 117;

-- 下拉列表
local DROPDOWN_FONTFLAGS = {
	["|cffffa0a0无"] = "",
	["轮廓"] = "OUTLINE",
	["粗轮廓"] = "THICKOUTLINE",
};
local DROPDOWN_ANCHORTYPE = {
	["普通跟随"] = "normal",
	["鼠标跟随"] = "mouse",
	["两者跟随"] = "parent",
};

local DROPDOWN_ANCHORPOS = {
	["顶部"] = "TOP",
	["左上"] = "TOPLEFT",
	["右上"] = "TOPRIGHT",
	["底部"] = "BOTTOM",
	["左下"] = "BOTTOMLEFT",
	["右下"] = "BOTTOMRIGHT",
	["左侧"] = "LEFT",
	["右侧"] = "RIGHT",
	["中间"] = "CENTER",
};

local DROPDOWN_ANCHORHALIGN = {
	["左"] = "LEFT",
	["中"] = "CENTER",
	["右"] = "RIGHT",
};

local DROPDOWN_ANCHORVALIGN = {
	["上"] = "TOP",
	["中"] = "MIDDLE",
	["下"] = "BOTTOM",
};

local DROPDOWN_ANCHORGROWDIRECTION = {
	["上"] = "UP",
	["右"] = "RIGHT",
	["下"] = "DOWN",
	["左"] = "LEFT",
};

local DROPDOWN_BARTEXTFORMAT = {
	["|cffffa0a0无"] = "none",
	["百分比"] = "percent",
	["仅当前"] = "current",
	["数值"] = "value",
	["数值与百分比"] = "full",
	["逆差"] = "deficit",
};

-- 选项 -- 类别子表的 "y" 值将进一步增加项目的垂直偏移位置
--
-- 布局选项提示：
-- 要设置选项的像素完美缩放以调整选项元素：
-- /run local psw, psh = GetPhysicalScreenSize(); local uf = 768 / psh; local uis = UIParent:GetEffectiveScale(); local ttos = uf / uis; _G["TipTacOptions"]:SetScale(ttos);
local activePage = 1;
local options = {};
local option;

-- 常规
local ttOptionsGeneral = {
	{ type = "Check", var = "showMinimapIcon", label = "启用小地图图标", tip = "将为 " .. PARENT_MOD_NAME .. " 显示小地图图标" },
	{ type = "Slider", var = "gttScale", label = "提示缩放大小", min = 0.2, max = 4, step = 0.05, y = 10 },
	
	{ type = "Header", label = "单位提示外观" },
	{ type = "Check", var = "showUnitTip", label = "启用" .. PARENT_MOD_NAME .. "单位提示外观", tip = "将改变单位提示的外观。许多选项在 " .. PARENT_MOD_NAME .. " 中仅在此设置启用时有效。\n注意：在非英语客户端使用此选项可能会导致问题！" },
	
	{ type = "Check", var = "showStatus", label = "显示<离线>/<暂离>/<勿扰>状态", tip = "将在玩家名称后显示 <DC>, <AFK> 和 <DND> 状态", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 },
	{ type = "Check", var = "showTargetedBy", label = "看谁把该单位作为目标", tip = "在团队或队伍中，提示将显示谁在你的组中以目标单位。\n当不在组中时，评估可见的姓名板（可以在魔兽世界选项 '游戏->游戏玩法->界面->姓名板' 下启用）", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
	{ type = "Check", var = "showPlayerGender", label = "显示玩家性别", tip = "这将显示玩家的性别。例如：\"85 女性血精灵圣骑士\"。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
	{ type = "Check", var = "showCurrentUnitSpeed", label = "显示当前单位速度", tip = "这将显示单位的当前速度，位于种族和职业之后。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end }
};

if (C_PlayerInfo.GetPlayerMythicPlusRatingSummary) then
	tinsert(ttOptionsGeneral, { type = "Check", var = "showMythicPlusDungeonScore", label = "显示传奇+ 地下城分数", tip = "这将显示玩家的传奇+ 地下城分数。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 });
	tinsert(ttOptionsGeneral, { type = "DropDown", var = "mythicPlusDungeonScoreFormat", label = "地下城分数格式", list = { ["只有分数"] = "dungeonScore", ["分数 + 最高限时记录"] = "both", ["只有最高限时记录"] = "highestSuccessfullRun" }, enabled = function(factory) return factory:GetConfigValue("showUnitTip") end });
end

tinsert(ttOptionsGeneral, { type = "Check", var = "showMount", label = "显示坐骑", tip = "这将显示玩家的当前坐骑。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 });
tinsert(ttOptionsGeneral, { type = "Check", var = "showMountCollected", label = "已收藏", tip = "此选项使提示显示一个图标，指示您是否已经收集了该坐骑。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showMount") end, x = 122 });
tinsert(ttOptionsGeneral, { type = "Check", var = "showMountIcon", label = "图标", tip = "此选项使提示显示坐骑图标。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showMount") end, x = 210 });
tinsert(ttOptionsGeneral, { type = "Check", var = "showMountText", label = "文字", tip = "此选项使提示显示坐骑文字。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showMount") end, x = 122 });
tinsert(ttOptionsGeneral, { type = "Check", var = "showMountSpeed", label = "速度", tip = "此选项使提示显示坐骑速度。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showMount") end, x = 210 });

tinsert(ttOptionsGeneral, { type = "DropDown", var = "nameType", label = "名字 & 称号", list = { ["只有名字"] = "normal", ["名字 + 称号"] = "title", ["复制自原始提示消息"] = "original", ["玛丽苏协议"] = "marysueprot" }, enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 });
tinsert(ttOptionsGeneral, { type = "DropDown", var = "showRealm", label = "显示单位服务器", list = { ["|cffffa0a0不显示服务器"] = "none", ["显示服务器"] = "show", ["显示服务器在新行"] = "showInNewLine", ["显示 (*) 来代替"] = "asterisk" }, enabled = function(factory) return factory:GetConfigValue("showUnitTip") end });
tinsert(ttOptionsGeneral, { type = "DropDown", var = "showTarget", label = "显示单位目标", list = { ["|cffffa0a0不显示目标"] = "none", ["在名字后"] = "afterName", ["在名字/服务器下面"] = "belowNameRealm", ["末行"] = "last" }, enabled = function(factory) return factory:GetConfigValue("showUnitTip") end });

tinsert(ttOptionsGeneral, { type = "Text", var = "targetYouText", label = "关注你文字", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 });

tinsert(ttOptionsGeneral, { type = "Check", var = "showGuild", label = "显示玩家公会", tip = "这将显示玩家的公会。", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 });
tinsert(ttOptionsGeneral, { type = "Check", var = "showGuildRank", label = "显示玩家公会阶级", tip = "除了公会名称，启用此选项后，您还将看到他们的公会等级和/或称号", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showGuild") end });
tinsert(ttOptionsGeneral, { type = "DropDown", var = "guildRankFormat", label = "公会阶级格式", list = { ["只有抬头"] = "title", ["抬头 + 会阶"] = "both", ["只有会阶"] = "level" }, enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showGuild") and factory:GetConfigValue("showGuildRank") end });

tinsert(ttOptionsGeneral, { type = "Check", var = "showBattlePetTip", label = "启用战宠提示", tip = "将为野生和伴侣战宠显示特殊提示。可能需要在某些非英语客户端中禁用", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 });

tinsert(ttOptionsGeneral, { type = "Header", label = "工具提示的默认文本", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end });

tinsert(ttOptionsGeneral, { type = "Check", var = "hidePvpText", label = "隐藏PvP文字", tip = "从工具提示中删除PvP行", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end });

if (LibFroznFunctions.hasWoWFlavor.specializationAndClassTextInPlayerUnitTip) then
	tinsert(ttOptionsGeneral, { type = "Check", var = "hideSpecializationAndClassText", label = "隐藏专精 & 职业文字", tip = "从工具提示中删除专精 & 职业文字", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end });
end

-- 颜色
local ttOptionsColors = {
	{ type = "Check", var = "enableColorName", label = "启用名字着色", tip = "开启或关闭名字着色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
	{ type = "Color", var = "colorName", label = "名字颜色", tip = "名字的颜色，当不使用将其设置为与反应颜色相同的选项时", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("enableColorName") end },
	{ type = "Check", var = "colorNameByReaction", label = "基于互动关系着色名字", tip = "名字颜色将与反应颜色相同\n注意：此选项被玩家的职业颜色覆盖", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
	{ type = "Check", var = "colorNameByClass", label = "基于职业颜色着色玩家名字", tip = "启用此选项后，玩家名字将按其职业颜色着色\n注意：此选项覆盖玩家的反应颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
	
	{ type = "Color", var = "colorGuild", label = "公会颜色", tip = "公会名称的颜色，当不使用将其设置为与反应颜色相同的选项时", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showGuild") end, y = 10 },
	{ type = "Color", var = "colorSameGuild", label = "你的公会颜色", tip = "为了更好地识别来自你公会的玩家，您可以单独配置公会名称的颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showGuild") end, x = 120 },
	{ type = "Check", var = "colorGuildByReaction", label = "按阵营来对公会进行着色", tip = "公会颜色将与反应颜色相同", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("showGuild") end },
	
	{ type = "Color", var = "colorRace", label = "种族和生物类型颜色", tip = "种族和生物类型文本的颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 },
	{ type = "Color", var = "colorLevel", label = "中立等级颜色", tip = "您无法攻击的单位将以此颜色显示其等级文本", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
	
	{ type = "Check", var = "factionText", label = "显示单位的阵营文字", tip = "启用此选项后，单位的阵营文字将在等级行下方显示", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 },
	{ type = "Check", var = "enableColorFaction", label = "启用阵营文字着色", tip = "开启或关闭阵营文字着色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("factionText") end },
	{ type = "Color", var = "colorFactionAlliance", label = "联盟阵营文字颜色", tip = "联盟阵营文字的颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("factionText") and factory:GetConfigValue("enableColorFaction") end },
	{ type = "Color", var = "colorFactionHorde", label = "部落阵营文字颜色", tip = "部落阵营文字的颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("factionText") and factory:GetConfigValue("enableColorFaction") end },
	{ type = "Color", var = "colorFactionNeutral", label = "中立阵营文字颜色", tip = "中立阵营文字的颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("factionText") and factory:GetConfigValue("enableColorFaction") end },
	
	{ type = "Check", var = "classColoredBorder", label = "提示边框按职业颜色着色", tip = "对于玩家，边框颜色将按其职业颜色着色\n注意：此选项覆盖反应颜色边框", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end, y = 10 },
	
	{ type = "Header", label = "自定义职业颜色" },
	
	{ type = "Check", var = "enableCustomClassColors", label = "启用自定义职业颜色", tip = "开启或关闭自定义职业颜色" }
};

local numClasses = GetNumClasses();
local firstClass = true;

for i = 1, numClasses do
	local className, classFile = GetClassInfo(i);
	
	if (classFile) then
		local camelCasedClassFile = LibFroznFunctions:CamelCaseText(classFile);
		
		tinsert(ttOptionsColors, { type = "Color", var = "colorCustomClass" .. camelCasedClassFile, label = camelCasedClassFile .. " 颜色", enabled = function(factory) return factory:GetConfigValue("enableCustomClassColors") end, y = (firstClass and 10 or nil) });
		
		firstClass = false;
	end
end

-- 锚点
local ttOptionsAnchors = {
	{ type = "DropDown", var = "anchorWorldUnitType", label = "世界单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end },
	{ type = "DropDown", var = "anchorWorldUnitPoint", label = "世界单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end },
	
	{ type = "DropDown", var = "anchorWorldTipType", label = "世界提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 },
	{ type = "DropDown", var = "anchorWorldTipPoint", label = "世界提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end },
	
	{ type = "DropDown", var = "anchorFrameUnitType", label = "框架单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 },
	{ type = "DropDown", var = "anchorFrameUnitPoint", label = "框架单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end },
	
	{ type = "DropDown", var = "anchorFrameTipType", label = "框架提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 },
	{ type = "DropDown", var = "anchorFrameTipPoint", label = "框架提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end },
};

local priority = 0;

if (LibFroznFunctions.hasWoWFlavor.challengeMode) then
	priority = priority + 1;
	tinsert(ttOptionsAnchors, { type = "Header", label = "Prio #" .. priority .. ": 挑战模式中定位覆盖", tip = "在挑战模式（传奇+）期间的特殊锚点覆盖", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });

	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideWorldUnitDuringChallengeMode", label = "挑战模式中世界单位", tip = "此选项将在挑战模式（传奇+）期间覆盖世界单位的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldUnitTypeDuringChallengeMode", label = "世界单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldUnitDuringChallengeMode") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldUnitPointDuringChallengeMode", label = "世界单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldUnitDuringChallengeMode") end });
	
	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideWorldTipDuringChallengeMode", label = "挑战模式中世界提示", tip = "此选项将在挑战模式（传奇+）期间覆盖世界提示的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldTipTypeDuringChallengeMode", label = "世界提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldTipDuringChallengeMode") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldTipPointDuringChallengeMode", label = "世界提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldTipDuringChallengeMode") end });
	
	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideFrameUnitDuringChallengeMode", label = "挑战模式中框架单位", tip = "此选项将在挑战模式（传奇+）期间覆盖框架单位的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameUnitTypeDuringChallengeMode", label = "框架单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameUnitDuringChallengeMode") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameUnitPointDuringChallengeMode", label = "框架单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameUnitDuringChallengeMode") end });
	
	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideFrameTipDuringChallengeMode", label = "挑战模式中框架提示", tip = "此选项将在挑战模式（传奇+）期间覆盖框架提示的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameTipTypeDuringChallengeMode", label = "框架提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameTipDuringChallengeMode") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameTipPointDuringChallengeMode", label = "框架提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameTipDuringChallengeMode") end });
end

if (LibFroznFunctions.hasWoWFlavor.skyriding) then
	priority = priority + 1;
	tinsert(ttOptionsAnchors, { type = "Header", label = "Prio #" .. priority .. ": 天空骑术定位覆盖", tip = "在天空骑术期间的特殊锚点覆盖", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });

	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideWorldUnitDuringSkyriding", label = "天空骑术时世界单位", tip = "此选项将在天空骑术期间覆盖世界单位的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldUnitTypeDuringSkyriding", label = "世界单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldUnitDuringSkyriding") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldUnitPointDuringSkyriding", label = "世界单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldUnitDuringSkyriding") end });
	
	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideWorldTipDuringSkyriding", label = "天空骑术时世界提示", tip = "此选项将在天空骑术期间覆盖世界提示的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldTipTypeDuringSkyriding", label = "世界提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldTipDuringSkyriding") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldTipPointDuringSkyriding", label = "世界提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldTipDuringSkyriding") end });
	
	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideFrameUnitDuringSkyriding", label = "天空骑术时框架单位", tip = "此选项将在天空骑术期间覆盖框架单位的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameUnitTypeDuringSkyriding", label = "框架单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameUnitDuringSkyriding") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameUnitPointDuringSkyriding", label = "框架单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameUnitDuringSkyriding") end });
	
	tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideFrameTipDuringSkyriding", label = "天空骑术时框架提示", tip = "此选项将在天空骑术期间覆盖框架提示的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameTipTypeDuringSkyriding", label = "框架提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameTipDuringSkyriding") end });
	tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameTipPointDuringSkyriding", label = "框架提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameTipDuringSkyriding") end });
end

priority = priority + 1;
tinsert(ttOptionsAnchors, { type = "Header", label = (priority > 1 and "Prio #" .. priority .. ": " or "") .. "战斗中定位覆盖", tip = "战斗中的特殊锚点覆盖", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });

tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideWorldUnitInCombat", label = "战斗中世界单位", tip = "此选项将在战斗中覆盖世界单位的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldUnitTypeInCombat", label = "世界单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldUnitInCombat") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldUnitPointInCombat", label = "世界单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldUnitInCombat") end });

tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideWorldTipInCombat", label = "战斗中世界提示", tip = "此选项将在战斗中覆盖世界提示的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldTipTypeInCombat", label = "世界提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldTipInCombat") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorWorldTipPointInCombat", label = "世界提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideWorldTipInCombat") end });

tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideFrameUnitInCombat", label = "战斗中框架单位", tip = "此选项将在战斗中覆盖框架单位的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameUnitTypeInCombat", label = "框架单位类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameUnitInCombat") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameUnitPointInCombat", label = "框架单位位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameUnitInCombat") end });

tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideFrameTipInCombat", label = "战斗中框架提示", tip = "此选项将在战斗中覆盖框架提示的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end, y = 10 });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameTipTypeInCombat", label = "框架提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameTipInCombat") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorFrameTipPointInCombat", label = "框架提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideFrameTipInCombat") end });

tinsert(ttOptionsAnchors, { type = "Header", label = "其他特别定位覆盖", tip = "其他特殊锚点覆盖", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });

tinsert(ttOptionsAnchors, { type = "Check", var = "enableAnchorOverrideCF", label = "(公会 & 社群) 聊天框架", tip = "此选项将覆盖 (公会 & 社区) 聊天框架的锚点", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorOverrideCFType", label = "提示类型", list = DROPDOWN_ANCHORTYPE, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideCF") end });
tinsert(ttOptionsAnchors, { type = "DropDown", var = "anchorOverrideCFPoint", label = "提示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableAnchor") and factory:GetConfigValue("enableAnchorOverrideCF") end });

tinsert(ttOptionsAnchors, { type = "Header", label = "鼠标设置", enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });

tinsert(ttOptionsAnchors, { type = "Slider", var = "mouseOffsetX", label = "鼠标定位水平偏移", min = -200, max = 200, step = 1, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });
tinsert(ttOptionsAnchors, { type = "Slider", var = "mouseOffsetY", label = "鼠标定位垂直偏移", min = -200, max = 200, step = 1, enabled = function(factory) return factory:GetConfigValue("enableAnchor") end });

-- 隐藏
local ttOptionsHiding = {};
priority = 0;

if (LibFroznFunctions.hasWoWFlavor.challengeMode) then
	priority = priority + 1;
	tinsert(ttOptionsHiding, { type = "Header", label = "Prio #" .. priority .. ": 挑战模式中隐藏提示" });
	
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeWorldUnits", label = "隐藏世界单位", tip = "当您勾选此选项时，世界单位将在挑战模式（mythic+）中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeFrameUnits", label = "隐藏框架单位", tip = "当您勾选此选项时，框架单位将在挑战模式（mythic+）中隐藏。", x = 160 });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeWorldTips", label = "隐藏世界提示", tip = "当您勾选此选项时，世界提示将在挑战模式（mythic+）中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeFrameTips", label = "隐藏框架提示", tip = "当您勾选此选项时，框架提示将在挑战模式（mythic+）中隐藏。", x = 160 });
	
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeUnitTips", label = "隐藏单位提示", tip = "当您勾选此选项时，单位提示将在挑战模式（mythic+）中隐藏。", y = 10 });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeSpellTips", label = "隐藏法术提示", tip = "当您勾选此选项时，法术提示将在挑战模式（mythic+）中隐藏。", x = 160 });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeItemTips", label = "隐藏物品提示", tip = "当您勾选此选项时，物品提示将在挑战模式（mythic+）中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeActionTips", label = "隐藏动作条提示", tip = "当您勾选此选项时，动作条提示将在挑战模式（mythic+）中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringChallengeModeExpBarTips", label = "隐藏经验条提示", tip = "当您勾选此选项时，经验条提示将在挑战模式（mythic+）中隐藏。", x = 160 });
end

if (LibFroznFunctions.hasWoWFlavor.skyriding) then
	priority = priority + 1;
	tinsert(ttOptionsHiding, { type = "Header", label = "Prio #" .. priority .. ": 在天空骑术时隐藏提示" });
	
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingWorldUnits", label = "隐藏世界单位", tip = "当您勾选此选项时，世界单位将在天空骑术中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingFrameUnits", label = "隐藏框架单位", tip = "当您勾选此选项时，框架单位将在天空骑术中隐藏。", x = 160 });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingWorldTips", label = "隐藏世界提示", tip = "当您勾选此选项时，世界提示将在天空骑术中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingFrameTips", label = "隐藏框架提示", tip = "当您勾选此选项时，框架提示将在天空骑术中隐藏。", x = 160 });
	
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingUnitTips", label = "隐藏单位提示", tip = "当您勾选此选项时，单位提示将在天空骑术中隐藏。", y = 10 });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingSpellTips", label = "隐藏法术提示", tip = "当您勾选此选项时，法术提示将在天空骑术中隐藏。", x = 160 });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingItemTips", label = "隐藏物品提示", tip = "当您勾选此选项时，物品提示将在天空骑术中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingActionTips", label = "隐藏动作条提示", tip = "当您勾选此选项时，动作条提示将在天空骑术中隐藏。" });
	tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsDuringSkyridingExpBarTips", label = "隐藏经验条提示", tip = "当您勾选此选项时，经验条提示将在天空骑术中隐藏。", x = 160 });
end

priority = priority + 1;
tinsert(ttOptionsHiding, { type = "Header", label = (priority > 1 and "Prio #" .. priority .. ": " or "") .. "战斗中隐藏提示" });

tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatWorldUnits", label = "隐藏世界单位", tip = "当您勾选此选项时，世界单位将在战斗中隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatFrameUnits", label = "隐藏框架单位", tip = "当您勾选此选项时，框架单位将在战斗中隐藏。", x = 160 });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatWorldTips", label = "隐藏世界提示", tip = "当您勾选此选项时，世界提示将在战斗中隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatFrameTips", label = "隐藏框架提示", tip = "当您勾选此选项时，框架提示将在战斗中隐藏。", x = 160 });

tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatUnitTips", label = "隐藏单位提示", tip = "当您勾选此选项时，单位提示将在战斗中隐藏。", y = 10 });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatSpellTips", label = "隐藏法术提示", tip = "当您勾选此选项时，法术提示将在战斗中隐藏。", x = 160 });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatItemTips", label = "隐藏物品提示", tip = "当您勾选此选项时，物品提示将在战斗中隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatActionTips", label = "隐藏动作条提示", tip = "当您勾选此选项时，动作条提示将在战斗中隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsInCombatExpBarTips", label = "隐藏经验条提示", tip = "当您勾选此选项时，经验条提示将在战斗中隐藏。", x = 160 });

tinsert(ttOptionsHiding, { type = "Header", label = (priority > 1 and "Prio #" .. priority .. ": " or "") .. "战斗外隐藏提示" });

tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsWorldUnits", label = "隐藏世界单位", tip = "当您勾选此选项时，世界单位将被隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsFrameUnits", label = "隐藏框架单位", tip = "当您勾选此选项时，框架单位将被隐藏。", x = 160 });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsWorldTips", label = "隐藏世界提示", tip = "当您勾选此选项时，世界提示将被隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsFrameTips", label = "隐藏框架提示", tip = "当您勾选此选项时，框架提示将被隐藏。", x = 160 });

tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsUnitTips", label = "隐藏单位提示", tip = "当您勾选此选项时，单位提示将被隐藏。", y = 10 });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsSpellTips", label = "隐藏法术提示", tip = "当您勾选此选项时，法术提示将被隐藏。", x = 160 });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsItemTips", label = "隐藏物品提示", tip = "当您勾选此选项时，物品提示将被隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsActionTips", label = "隐藏动作条提示", tip = "当您勾选此选项时，动作条提示将被隐藏。" });
tinsert(ttOptionsHiding, { type = "Check", var = "hideTipsExpBarTips", label = "隐藏经验条提示", tip = "当您勾选此选项时，经验条提示将被隐藏。", x = 160 });

tinsert(ttOptionsHiding, { type = "Header", label = "其他" });

tinsert(ttOptionsHiding, { type = "DropDown", var = "showHiddenModifierKey", label = "仍然显示隐藏的提示\n当按下\n快捷键时", list = { ["Shift"] = "shift", ["Ctrl"] = "ctrl", ["Alt"] = "alt", ["|cffffa0a0None"] = "无" } });
tinsert(ttOptionsHiding, { type = "TextOnly", label = "", y = -12 }); -- spacer for multi-line label above

-- 构建选项
local options = {
	-- 常规
	{
		category = "一般设置",
		options = ttOptionsGeneral
	},
	-- 颜色
	{
		category = "颜色设置",
		options = ttOptionsColors
	},
	-- 互动属性
	{
		category = "互动属性",
		options = {
			{ type = "Check", var = "reactColoredBorder", label = "边框基于单位互动着色", tip = "与上述选项相同，仅适用于边框\n注意：此选项被职业着色边框覆盖", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			{ type = "Check", var = "reactIcon", label = "以图标显示与目标互动关系", tip = "此选项使提示显示单位的反应作为图标，位于等级后面", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			
			{ type = "Check", var = "reactText", label = "以文字显示与目标互动关系", tip = "启用此选项后，单位的反应将作为文本显示在等级行下方", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 },
			{ type = "Color", var = "colorReactText", label = "单位互动关系文字颜色", tip = "单位反应作为文本的颜色，当不使用将其设置为与反应颜色相同的选项时", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("reactText") end },
			
			{ type = "Check", var = "reactColoredText", label = "基于单位互动关系着色互动文字", tip = "启用此选项后，单位的反应作为文本将基于单位的反应", enabled = function(factory) return factory:GetConfigValue("showUnitTip") and factory:GetConfigValue("reactText") end },
			
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.tapped, label = "已被接触颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end, y = 10 },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.hostile, label = "敌对颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.caution, label = "警告颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.neutral, label = "中立颜色" , enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.friendlyPlayer, label = "友好玩家颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.friendlyPvPPlayer, label = "友好PVP玩家颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.friendlyNPC, label = "友好NPC颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.honoredNPC, label = "尊敬NPC颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.reveredNPC, label = "崇敬NPC颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.exaltedNPC, label = "崇拜NPC颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
			{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.dead, label = "死亡颜色", enabled = function(factory) return factory:GetConfigValue("showUnitTip") end },
		}
	},
	-- 背景颜色
	{
		category = "背景颜色",
		options = {
			{ type = "Check", var = "reactColoredBackdrop", label = "背景基于单位互动着色", tip = "如果您希望提示的背景颜色由单位对您的反应决定，请启用此选项。关闭此选项后，背景颜色将是“背景”页面上选择的颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.tapped, label = "已被接触颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end, y = 10 },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.hostile, label = "敌对颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.caution, label = "警告颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.neutral, label = "中立颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.friendlyPlayer, label = "友好玩家颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.friendlyPvPPlayer, label = "友好PVP玩家颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.friendlyNPC, label = "友好NPC颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.honoredNPC, label = "尊敬NPC颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.reveredNPC, label = "崇敬NPC颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.exaltedNPC, label = "崇拜NPC颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
			{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.dead, label = "死亡颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("reactColoredBackdrop") end },
		}
	},
	-- 背景设置
	{
		category = "背景设置",
		enabled = { type = "Check", var = "enableBackdrop", tip = "启用背景修改\n注意: 重载UI (/reload) 是必须的以让设置套用效果" },
		options = {
			{ type = "DropDown", var = "tipBackdropBG", label = "背景材质", media = "background", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			{ type = "DropDown", var = "tipBackdropBGLayout", label = "背景材质布局", list = { ["重复适应提示"] = "tile", ["伸展适应提示"] = "stretch" }, enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			{ type = "DropDown", var = "tipBackdropEdge", label = "边框材质", media = "border", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			
			{ type = "Slider", var = "backdropEdgeSize", label = "背景边缘大小", min = -20, max = 64, step = 0.5, enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end, y = 10 },
			{ type = "Slider", var = "backdropInsets", label = "背景嵌入", min = -20, max = 20, step = 0.5, enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			{ type = "Check", var = "pixelPerfectBackdrop", label = "像素完美的背景边缘和插入", tip = "背景边缘大小和嵌入对应于真实像素", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end, y = 10 },
			
			{ type = "Color", var = "tipColor", label = "提示背景颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end, y = 10 },
			{ type = "Color", var = "tipBorderColor", label = "提示边框颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end, x = 160 },
			{ type = "Check", var = "gradientTip", label = "显示渐变提示", tip = "在提示顶部显示一个小的渐变区域，以增加轻微的3D效果。如果您有像Skinner这样的插件，您可能希望禁用此选项以避免冲突", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") end },
			{ type = "Color", var = "gradientColor", label = "渐变颜色", tip = "选择渐变的基础颜色", enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("gradientTip") end, x = 160 },
			{ type = "Slider", var = "gradientHeight", label = "渐变高度", min = 0, max = 64, step = 0.5, enabled = function(factory) return factory:GetConfigValue("enableBackdrop") and factory:GetConfigValue("gradientTip") end },
		}
	},
	-- 字体设置
	{
		category = "字体设置",
		enabled = { type = "Check", var = "modifyFonts", tip = "为让 " .. PARENT_MOD_NAME .. " 更改游戏提示字体模板，从而更改用户界面中的所有工具提示，您必须启用此选项。\n注意: 如果您有插件，例如clearfont，则可能与此选项相抵触。" },
		options = {
			{ type = "DropDown", var = "fontFace", label = "字体名称", media = "font", enabled = function(factory) return factory:GetConfigValue("modifyFonts") end },
			{ type = "DropDown", var = "fontFlags", label = "字体样式", list = DROPDOWN_FONTFLAGS, enabled = function(factory) return factory:GetConfigValue("modifyFonts") end },
			{ type = "Slider", var = "fontSize", label = "字体大小", min = 6, max = 29, step = 1, enabled = function(factory) return factory:GetConfigValue("modifyFonts") end },
			
			{ type = "Slider", var = "fontSizeDeltaHeader", label = "标题字体大小差异", min = -10, max = 10, step = 1, enabled = function(factory) return factory:GetConfigValue("modifyFonts") end, y = 10 },
			{ type = "Slider", var = "fontSizeDeltaSmall", label = "内文字体大小差异", min = -10, max = 10, step = 1, enabled = function(factory) return factory:GetConfigValue("modifyFonts") end },
		}
	},
	-- 单位分类
	{
		category = "单位分类",
		options = {
			{ type = "Text", var = "classification_minus", label = "仆从" },
			{ type = "Text", var = "classification_trivial", label = "小喽啰" },
			{ type = "Text", var = "classification_normal", label = "普通" },
			{ type = "Text", var = "classification_elite", label = "精英" },
			{ type = "Text", var = "classification_worldboss", label = "首领" },
			{ type = "Text", var = "classification_rare", label = "稀有" },
			{ type = "Text", var = "classification_rareelite", label = "稀有精英" },
		}
	},
	-- 渐隐效果
	{
		category = "渐隐效果",
		options = {
			{ type = "Header", label = "单位提示渐隐淡出" },
			
			{ type = "Check", var = "overrideFade", label = "启用覆盖默认单位提示单位提示渐隐淡出", tip = "覆盖GameTooltip的默认淡出功能。如果您看到有关淡出的任何问题，请禁用。" },
			
			{ type = "Slider", var = "preFadeTime", label = "退出时间", min = 0, max = 5, step = 0.05, enabled = function(factory) return factory:GetConfigValue("overrideFade") end, y = 10 },
			{ type = "Slider", var = "fadeTime", label = "淡出时间", min = 0, max = 5, step = 0.05, enabled = function(factory) return factory:GetConfigValue("overrideFade") end },
			
			{ type = "Header", label = "其他" },
			
			{ type = "Check", var = "hideWorldTips", label = "立即隐藏世界框架提示", tip = "此选项将使大多数从世界中的对象出现的提示在您将鼠标移开对象时立即消失。例如邮箱、草药或箱子。\n注意：并非所有世界对象都有效。" },
		}
	},
	-- 条列设置
	{
		category = "条列设置",
		enabled = { type = "Check", var = "enableBars", tip = "启用单位提示的条列" },
		options = {
			{ type = "Header", label = "单位提示生命条", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			
			{ type = "Check", var = "healthBar", label = "显示生命条", tip = "将显示单位的生命条。", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			{ type = "DropDown", var = "healthBarText", label = "生命条文字", list = DROPDOWN_BARTEXTFORMAT, enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("healthBar") end },
			{ type = "Color", var = "healthBarColor", label = "生命条颜色", tip = "生命条的颜色。对启用上述选项的玩家没有效果", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("healthBar") end },
			{ type = "Check", var = "healthBarClassColor", label = "生命条按职业着色", tip = "此选项将生命条着色为与玩家职业相同的颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("healthBar") end, y = 2, x = 130 },
			{ type = "Check", var = "hideDefaultBar", label = "隐藏默认生命条", tip = "勾选此项以隐藏默认生命条", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			
			{ type = "Header", label = "单位提示法力条", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			
			{ type = "Check", var = "manaBar", label = "显示法力条", tip = "如果单位有法力，将显示法力条。", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			{ type = "DropDown", var = "manaBarText", label = "法力条文字", list = DROPDOWN_BARTEXTFORMAT, enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("manaBar") end },
			{ type = "Color", var = "manaBarColor", label = "法力条颜色", tip = "法力条的颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("manaBar") end },
			
			{ type = "Header", label = "其他类型能量条与单位提示", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			
			{ type = "Check", var = "powerBar", label = "显示其他类型能量\n(例如：怒气、符文能量或集中值)", tip = "如果单位使用法力以外的其他能量类型（例如：能量、怒气、符文能量或集中值），将显示该能量的条。", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			{ type = "DropDown", var = "powerBarText", label = "能量条文字", list = DROPDOWN_BARTEXTFORMAT, enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("powerBar") end },
			
			{ type = "Header", label = "单位提示施法条", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			
			{ type = "Check", var = "castBar", label = "显示施法条", tip = "将显示单位的施法条。", enabled = function(factory) return factory:GetConfigValue("enableBars") end },
			{ type = "Check", var = "castBarAlwaysShow", label = "永远显示施法条", tip = "勾选此项以始终显示施法条", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end, x = 130 },
			{ type = "Color", var = "castBarCastingColor", label = "施法条施放颜色", tip = "施法条的施放颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end, y = 10 },
			{ type = "Color", var = "castBarChannelingColor", label = "施法条通道颜色", tip = "施法条的通道颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end },
			{ type = "Color", var = "castBarChargingColor", label = "施法条充能颜色", tip = "施法条的充能颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end },
			{ type = "Color", var = "castBarCompleteColor", label = "施法条完成颜色", tip = "施法条的完成颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end },
			{ type = "Color", var = "castBarFailColor", label = "施法条失败颜色", tip = "施法条的失败颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end },
			{ type = "Color", var = "castBarSparkColor", label = "施法条火花颜色", tip = "施法条的火花颜色", enabled = function(factory) return factory:GetConfigValue("enableBars") and factory:GetConfigValue("castBar") end },
		
			{ type = "Header", label = "其他单位提示", enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end },
		
			{ type = "Check", var = "barsCondenseValues", label = "显示精简的条列数值", tip = "您可以启用此选项以精简条上显示的数值。它会将57254显示为57.3k作为示例", enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end },
			
			{ type = "DropDown", var = "barFontFace", label = "字体名称", media = "font", enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end, y = 10 },
			{ type = "DropDown", var = "barFontFlags", label = "字体样式", list = DROPDOWN_FONTFLAGS, enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end },
			{ type = "Slider", var = "barFontSize", label = "字体大小", min = 6, max = 29, step = 1, enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end },
			
			{ type = "DropDown", var = "barTexture", label = "条列材质", media = "statusbar", enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end, y = 10 },
			{ type = "Slider", var = "barHeight", label = "条列高度", min = 1, max = 50, step = 1, enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end },
			
			{ type = "Check", var = "barEnableTipMinimumWidth", label = "如果显示条列启用提示最小宽度", tip = "勾选此项以启用提示的最小宽度，如果显示条列，以便数字不会被截断。", enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) end, y = 10 },
			{ type = "Slider", var = "barTipMinimumWidth", label = "提示最小宽度", min = 10, max = 500, step = 5, enabled = function(factory) return factory:GetConfigValue("enableBars") and (factory:GetConfigValue("healthBar") or factory:GetConfigValue("manaBar") or factory:GetConfigValue("powerBar") or factory:GetConfigValue("castBar")) and factory:GetConfigValue("barEnableTipMinimumWidth") end },
		}
	},
	-- 光环图示
	{
		category = "光环图示",
		enabled = { type = "Check", var = "enableAuras", tip = "启用单位提示的光环" },
		options = {
			{ type = "Header", label = "单位提示的光环", enabled = function(factory) return factory:GetConfigValue("enableAuras") end },			
			
			{ type = "Check", var = "showBuffs", label = "显示单位增益", tip = "显示单位的增益", enabled = function(factory) return factory:GetConfigValue("enableAuras") end },
			{ type = "Check", var = "showDebuffs", label = "显示单位减益", tip = "显示单位的减益", enabled = function(factory) return factory:GetConfigValue("enableAuras") end },
			
			{ type = "Check", var = "selfAurasOnly", label = "仅显示来自你的光环", tip = "此选项将过滤并仅显示您自己施放的光环", enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end, y = 10 },
			
			{ type = "Check", var = "showAuraCooldown", label = "显示冷却计时模块", tip = "启用此选项后，您将看到增益剩余时间的视觉进度", enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end, y = 10 },
			{ type = "Check", var = "noCooldownCount", label = "无冷却计时文字", tip = "告知冷却增强插件，例如OmniCC，不显示冷却文本", enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end },
			
			{ type = "Slider", var = "auraSize", label = "光环图示尺寸", min = 8, max = 60, step = 1, enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end, y = 10 },
			{ type = "Slider", var = "auraMaxRows", label = "最大光环行数", min = 1, max = 8, step = 1, enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end },
		
			{ type = "Check", var = "aurasAtBottom", label = "放置光环图示在底部而不是顶部", tip = "将光环图标放置在提示的底部，而不是默认的顶部", enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end, y = 10 },
			{ type = "Slider", var = "auraOffset", label = "光环位置偏移", min = 0, max = 200, step = 0.5, enabled = function(factory) return factory:GetConfigValue("enableAuras") and (factory:GetConfigValue("showBuffs") or factory:GetConfigValue("showDebuffs")) end },
		}
	},
	-- 图示设置
	{
		category = "图示设置",
		enabled = { type = "Check", var = "enableIcons", tip = "切换所有提示旁的额外图示" },
		options = {
			{ type = "Header", label = "单位提示的图示", enabled = function(factory) return factory:GetConfigValue("enableIcons") end },
			
			{ type = "Check", var = "iconRaid", label = "显示团队图示", tip = "在提示旁显示团队图标", enabled = function(factory) return factory:GetConfigValue("enableIcons") end },
			{ type = "Check", var = "iconFaction", label = "显示阵营图示", tip = "如果单位被标记为PvP，则在提示旁显示阵营图标", enabled = function(factory) return factory:GetConfigValue("enableIcons") end },
			{ type = "Check", var = "iconCombat", label = "显示战斗图示", tip = "如果单位在战斗中，则在提示旁显示战斗图标", enabled = function(factory) return factory:GetConfigValue("enableIcons") end },
			{ type = "Check", var = "iconClass", label = "显示职业图示", tip = "对于玩家，这将在提示旁显示职业图标", enabled = function(factory) return factory:GetConfigValue("enableIcons") end },
			
			{ type = "Slider", var = "iconSize", label = "图示尺寸", min = 8, max = 100, step = 1, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) end },
			{ type = "Slider", var = "iconMaxIcons", label = "最大图示", min = 1, max = 4, step = 1, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) end },
			{ type = "DropDown", var = "iconAnchor", label = "图示位置", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) end, y = 10 },
			{ type = "DropDown", var = "iconAnchorHorizontalAlign", label = "水平对齐", list = DROPDOWN_ANCHORHALIGN, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) and (factory:GetConfigValue("iconAnchor") == "TOP" or factory:GetConfigValue("iconAnchor") == "BOTTOM") end },
			{ type = "DropDown", var = "iconAnchorVerticalAlign", label = "垂直对齐", list = DROPDOWN_ANCHORVALIGN, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) and (factory:GetConfigValue("iconAnchor") == "LEFT" or factory:GetConfigValue("iconAnchor") == "RIGHT") end },
			{ type = "DropDown", var = "iconAnchorGrowDirection", label = "增长方向", list = DROPDOWN_ANCHORGROWDIRECTION, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) end },
			{ type = "Slider", var = "iconOffsetX", label = "图示水平偏移", min = -200, max = 200, step = 0.5, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) end },
			{ type = "Slider", var = "iconOffsetY", label = "图示垂直偏移", min = -200, max = 200, step = 0.5, enabled = function(factory) return factory:GetConfigValue("enableIcons") and (factory:GetConfigValue("iconRaid") or factory:GetConfigValue("iconFaction") or factory:GetConfigValue("iconCombat") or factory:GetConfigValue("iconClass")) end },
		}
	},
	-- 定位设置
	{
		category = "定位设置",
		enabled = { type = "Check", var = "enableAnchor", tip = "切换所有定位的修改" },
		options = ttOptionsAnchors
	},
	-- 隐藏提示
	{
		category = "隐藏提示",
		options = ttOptionsHiding
	},
	-- 超链接
	{
		category = "超链接",
		enabled = { type = "Check", var = "enableChatHoverTips", label = "启用 (公会 & 社群) 聊天框悬停超链接", tip = "当鼠标悬停在 (公会 & 社群) 聊天框中的链接上时，显示提示而无需单击它" }
 	},
	-- 布局风格
	{
		category = "布局风格",
		options = {
			{ type = "DropDown", label = "布局模板", init = TipTacLayouts.LoadLayout_Init },
--			{ type = "Text", label = "保存布局", func = nil },
--			{ type = "DropDown", label = "删除布局", init = TipTacLayouts.DeleteLayout_Init },
		}
	},
};

-- TipTacTalents 支持
local TipTacTalents = _G[PARENT_MOD_NAME .. "Talents"];

if (TipTacTalents) then
	local tttOptions = {
		{ type = "Header", label = "天赋", enabled = function(factory) return factory:GetConfigValue("t_enable") end }
	};
	
	tinsert(tttOptions, { type = "Check", var = "t_talentOnlyInParty", label = "只显示队伍或团队成员\n的天赋以及平均装备等级", tip = "启用此选项后，仅请求并显示您队伍或团队中玩家的天赋和平均装备等级", enabled = function(factory) return factory:GetConfigValue("t_enable") end, y = 5 });
	
	option = { type = "Check", var = "t_showTalents", label = "显示天赋", tip = "此选项使提示显示其他玩家的天赋专精", enabled = function(factory) return factory:GetConfigValue("t_enable") end, y = 10 };
	if (not LibFroznFunctions.hasWoWFlavor.talentsAvailableForInspectedUnit) then
		option.tip = option.tip .. ".\n注意：在经典时代，无法检查其他玩家的天赋。仅显示自己的天赋（在10级时可用）。";
	end
	tinsert(tttOptions, option);
	
	if (LibFroznFunctions.hasWoWFlavor.roleIconAvailable) then
		tinsert(tttOptions, { type = "Check", var = "t_showRoleIcon", label = "显示角色类型图标", tip = "此选项使提示显示角色图标（坦克、输出、治疗）", enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showTalents") end });
	end
	if (LibFroznFunctions.hasWoWFlavor.talentIconAvailable) then
		tinsert(tttOptions, { type = "Check", var = "t_showTalentIcon", label = "显示天赋图标", tip = "此选项使提示显示天赋图标", enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showTalents") end });
	end
	
	tinsert(tttOptions, { type = "Check", var = "t_showTalentText", label = "显示天赋文字", tip = "此选项使提示显示天赋文字", enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showTalents") end, y = 10 });
	tinsert(tttOptions, { type = "Check", var = "t_colorTalentTextByClass", label = "根据职业着色天赋文字", tip = "启用此选项后，天赋文字将按职业颜色着色", enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showTalents") and factory:GetConfigValue("t_showTalentText") end });
	
	if (LibFroznFunctions.hasWoWFlavor.numTalentTrees > 0) then
		if (LibFroznFunctions.hasWoWFlavor.numTalentTrees == 2) then
			tinsert(tttOptions, { type = "DropDown", var = "t_talentFormat", label = "天赋文字格式", list = { ["Elemental (31/30)"] = 1, ["Elemental"] = 2, ["31/30"] = 3,}, enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showTalents") and factory:GetConfigValue("t_showTalentText") end }); -- 不支持MoP更改
		else
			tinsert(tttOptions, { type = "DropDown", var = "t_talentFormat", label = "天赋文字格式", list = { ["Elemental (57/14/0)"] = 1, ["Elemental"] = 2, ["57/14/0"] = 3,}, enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showTalents") and factory:GetConfigValue("t_showTalentText") end }); -- 不支持MoP更改
		end
	end
	
	tinsert(tttOptions, { type = "Header", label = "平均装备等级", enabled = function(factory) return factory:GetConfigValue("t_enable") end });
	
	tinsert(tttOptions, { type = "Check", var = "t_showAverageItemLevel", label = "显示平均装备等级 (AIL)", tip = "此选项使提示显示其他玩家的平均装备等级 (AIL)", enabled = function(factory) return factory:GetConfigValue("t_enable") end });
	
	tinsert(tttOptions, { type = "Check", var = "t_showGearScore", label = "显示装备分数", tip = "此选项使提示显示其他玩家的装备分数", enabled = function(factory) return factory:GetConfigValue("t_enable") end, y = 10 });
	tinsert(tttOptions, { type = "DropDown", var = "t_gearScoreAlgorithm", label = "装备分数算法", list = { ["TacoTip"] = { value = 1, tip = "来自插件TacoTip的标准算法" }, ["TipTac"] = { value = 2, tip = PARENT_MOD_NAME .. "的自定义实现，简单计算装备分数。此算法是所有物品等级的总和，按当前扩展的第一层套装的基础等级、库存类型和物品质量加权。衬衫、披风和远程物品的库存槽被排除。" },}, tip = "在不同的装备分数实现之间切换", enabled = function(factory) return factory:GetConfigValue("t_enable") and factory:GetConfigValue("t_showGearScore") end });
	
	tinsert(tttOptions, { type = "Check", var = "t_colorAILAndGSTextByQuality", label = "根据品质颜色来着色\n平均装备等级与装备分数文字", tip = "启用此选项后，平均装备等级和装备分数文字将按品质颜色着色", enabled = function(factory) return factory:GetConfigValue("t_enable") and (factory:GetConfigValue("t_showAverageItemLevel") or factory:GetConfigValue("t_showGearScore")) end, y = 10 });
	
	tinsert(options, {
		category = "天赋/装备等级",
		enabled = { type = "Check", var = "t_enable", tip = "切换TipTacTalents插件的功能" },
		options = tttOptions
	});
end

-- TipTacItemRef 支持
local TipTacItemRef = _G[PARENT_MOD_NAME .. "ItemRef"];

if (TipTacItemRef) then
	local ttifOptions = {
		{ type = "Color", var = "if_infoColor", label = "信息颜色", tip = "这些选项添加的各种工具提示行的颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end },

		{ type = "Check", var = "if_itemQualityBorder", label = "显示按品质对边框进行着色的物品提示", tip = "启用后，当提示显示物品时，提示边框将具有物品品质的颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 },
		{ type = "Check", var = "if_showItemLevel", label = "显示物品等级", tip = "对于物品工具提示，显示其物品等级（与物品编号结合）。\n注意：这将删除工具提示所显示的默认物品等级文字", enabled = function(factory) return factory:GetConfigValue("if_enable") end },
		{ type = "Check", var = "if_showItemId", label = "显示物品编号", tip = "对于物品工具提示，显示其物品编号（与物品等级结合）", enabled = function(factory) return factory:GetConfigValue("if_enable") end, x = 160 }
	};
	
	if (LibFroznFunctions.hasWoWFlavor.relatedExpansionForItemAvailable) then
		tinsert(ttifOptions, { type = "Check", var = "if_showExpansionIcon", label = "显示资料片图标", tip = "对于物品工具提示，显示其资料片图标", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
		tinsert(ttifOptions, { type = "Check", var = "if_showExpansionName", label = "显示资料片名称", tip = "对于物品工具提示，显示其资料片名称", enabled = function(factory) return factory:GetConfigValue("if_enable") end, x = 160 });
	end
	
	tinsert(ttifOptions, { type = "Check", var = "if_showKeystoneRewardLevel", label = "显示钥石 (每周) 奖励等级", tip = "对于钥石工具提示，显示其奖励等级和每周奖励等级", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showKeystoneTimeLimit", label = "显示钥石时间限制", tip = "对于钥石工具提示，显示实例时间限制", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_showKeystoneAffixInfo", label = "显示钥石词缀信息", tip = "对于钥石工具提示，显示词缀信息", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_modifyKeystoneTips", label = "更改钥石提示", tip = "更改钥石的工具提示以显示更多信息\n注意：可能与其他钥石插件冲突", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_spellColoredBorder", label = "显示法术提示包含边框着色", tip = "启用后，当提示显示法术时，提示边框将具有标准法术颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showSpellIdAndRank", label = "显示法术编号 & 等级", tip = "对于法术工具提示，显示其法术ID和法术等级/子文本", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_auraSpellColoredBorder", label = "显示光环提示包含边框着色", tip = "启用后，当提示显示增益或减益时，提示边框将具有标准法术颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_showAuraSpellIdAndRank", label = "显示光环法术编号 & 等级", tip = "对于增益和减益工具提示，显示其法术ID和法术等级/子文本", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_showMawPowerId", label = "显示渊喉能量编号", tip = "对于法术和光环工具提示，显示其mawPowerID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_showAuraCaster", label = "光环提示显示施法者", tip = "当显示增益和减益工具提示时，将添加一行，显示谁施放了特定光环", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_colorAuraCasterByReaction", label = "根据阵营着色光环提示的施法者", tip = "光环工具提示施法者颜色将与反应颜色相同\n注意：此选项被玩家的职业颜色覆盖", enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showAuraCaster") end });
	tinsert(ttifOptions, { type = "Check", var = "if_colorAuraCasterByClass", label = "根据玩家职业颜色来着色光环提示施法者", tip = "启用此选项后，玩家的光环工具提示施法者将按其职业颜色着色\n注意：此选项覆盖玩家的反应颜色光环工具提示施法者", enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showAuraCaster") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_showNpcId", label = "显示NPC编号", tip = "对于NPC或战斗宠物工具提示，显示其npcID", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showMountId", label = "显示坐骑编号", tip = "对于物品、法术和光环工具提示，显示其mountID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_questDifficultyBorder", label = "显示任务提示包含难度边框着色", tip = "启用后，当提示显示任务时，提示边框将具有任务的难度颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showQuestLevel", label = "显示任务等级", tip = "对于任务工具提示，显示其任务等级（与任务ID结合）", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_showQuestId", label = "显示任务编号", tip = "对于任务工具提示，显示其任务ID（与任务等级结合）", enabled = function(factory) return factory:GetConfigValue("if_enable") end, x = 160 });
	
	tinsert(ttifOptions, { type = "Check", var = "if_currencyQualityBorder", label = "显示货币提示包含品质边框着色", tip = "启用后，当提示显示货币时，提示边框将具有货币的品质颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showCurrencyId", label = "显示货币编号", tip = "货币物品将显示其ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_achievmentColoredBorder", label = "显示成就提示包含边框着色", tip = "启用后，当提示显示成就时，提示边框将具有标准成就颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showAchievementIdAndCategoryId", label = "显示成就编号 & 类别", tip = "在成就工具提示上，显示成就ID以及类别", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_modifyAchievementTips", label = "修改成就提示", tip = "更改成就工具提示以显示更多信息\n警告：可能与其他成就插件冲突", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_battlePetQualityBorder", label = "显示战宠提示包含品质边框着色", tip = "启用后，当提示显示战宠时，提示边框将具有战宠的品质颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showBattlePetLevel", label = "显示战宠等级", tip = "对于战宠工具提示，显示其宠物等级（与npcID结合）", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_battlePetAbilityColoredBorder", label = "显示战宠技能提示包含边框着色", tip = "启用后，当提示显示战宠技能时，提示边框将具有标准战宠技能颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showBattlePetAbilityId", label = "显示战宠技能编号", tip = "对于战宠技能工具提示，显示其技能ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_transmogAppearanceItemQualityBorder", label = "显示塑形外观物品提示包含品质边框着色", tip = "启用后，当提示显示塑形外观物品时，提示边框将具有塑形外观物品的品质颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showTransmogAppearanceItemId", label = "显示塑形外观物品编号", tip = "对于塑形外观物品工具提示，显示其物品ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_transmogIllusionColoredBorder", label = "显示塑形幻象提示包含边框着色", tip = "启用后，当提示显示塑形幻象时，提示边框将具有标准塑形幻象颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showTransmogIllusionId", label = "显示塑形幻象编号", tip = "对于塑形幻象工具提示，显示其幻象ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_transmogSetQualityBorder", label = "显示塑形外观套装提示包含品质边框着色", tip = "启用后，当提示显示塑形外观套装时，提示边框将具有塑形外观套装的品质颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showTransmogSetId", label = "显示塑形套装编号", tip = "对于塑形套装工具提示，显示其套装ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_conduitQualityBorder", label = "显示传导器提示包含品质边框着色", tip = "启用后，当提示显示传导器时，提示边框将具有传导器的品质颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showConduitItemLevel", label = "显示传导器物品等级", tip = "对于传导器工具提示，显示其物品等级（与传导器ID结合）", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_showConduitId", label = "显示传导器编号", tip = "对于传导器工具提示，显示其传导器ID（与传导器物品等级结合）", enabled = function(factory) return factory:GetConfigValue("if_enable") end, x = 160 });
	
	tinsert(ttifOptions, { type = "Check", var = "if_azeriteEssenceQualityBorder", label = "显示艾泽拉斯精华提示包含品质边框着色", tip = "启用后，当提示显示艾泽拉斯精华时，提示边框将具有艾泽拉斯精华的品质颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showAzeriteEssenceId", label = "显示艾泽拉斯精华编号", tip = "对于艾泽拉斯精华工具提示，显示其精华ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_runeforgePowerColoredBorder", label = "显示符文锻造能量提示包含品质边框着色", tip = "启用后，当提示显示符文锻造能量时，提示边框将具有标准符文锻造能量颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showRuneforgePowerId", label = "显示符文锻造能量编号", tip = "对于符文锻造能量工具提示，显示其符文锻造能量ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_flyoutColoredBorder", label = "显示弹出提示包含边框着色", tip = "启用后，当提示显示弹出时，提示边框将具有标准法术颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showFlyoutId", label = "显示弹出编号", tip = "对于弹出工具提示，显示其弹出ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_petActionColoredBorder", label = "显示宠物动作提示包含边框着色", tip = "启用后，当提示显示宠物动作时，提示边框将具有标准法术颜色", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	tinsert(ttifOptions, { type = "Check", var = "if_showPetActionId", label = "显示宠物动作编号", tip = "对于弹出工具提示，显示其宠物动作ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_showInstanceLockDifficulty", label = "显示副本锁定难度", tip = "对于副本锁定工具提示，显示其难度", enabled = function(factory) return factory:GetConfigValue("if_enable") end, y = 10 });
	
	tinsert(ttifOptions, { type = "Header", label = "图标", tip = "关于提示图标的设置", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	
	tinsert(ttifOptions, { type = "Check", var = "if_showIcon", label = "显示图标材质及计数 (当可用时)", tip = "在工具提示旁边显示一个图标。对于物品，堆叠计数也将显示", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_smartIcons", label = "智能显示图标", tip = "启用后，TipTacItemRef将根据提示显示的位置确定是否需要图标。例如，它不会在动作条或背包槽上显示，因为它们已经显示了图标", enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	tinsert(ttifOptions, { type = "DropDown", var = "if_stackCountToTooltip", label = "显示堆叠计数于\n工具提示", list = { ["|cffffa0a0不显示"] = "none", ["永远显示"] = "always", ["只有图标不显示时"] = "noicon" }, enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_showIconId", label = "显示图标编号", tip = "对于带有图标的工具提示，显示其图标ID", enabled = function(factory) return factory:GetConfigValue("if_enable") end });
	tinsert(ttifOptions, { type = "Check", var = "if_borderlessIcons", label = "无边框图标", tip = "关闭图标的边框", enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	tinsert(ttifOptions, { type = "Slider", var = "if_iconSize", label = "图标尺寸", min = 16, max = 128, step = 1, enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	tinsert(ttifOptions, { type = "DropDown", var = "if_iconAnchor", label = "图标定位", tip = "图标的锚点", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	tinsert(ttifOptions, { type = "DropDown", var = "if_iconTooltipAnchor", label = "图标提示定位", tip = "图标应锚定到的工具提示的锚点。", list = DROPDOWN_ANCHORPOS, enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	tinsert(ttifOptions, { type = "Slider", var = "if_iconOffsetX", label = "图标水平位置", min = -200, max = 200, step = 0.5, enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	tinsert(ttifOptions, { type = "Slider", var = "if_iconOffsetY", label = "图标垂直位置", min = -200, max = 200, step = 0.5, enabled = function(factory) return factory:GetConfigValue("if_enable") and factory:GetConfigValue("if_showIcon") end });
	
	tinsert(options, {
		category = "物品参考",
		enabled = { type = "Check", var = "if_enable", tip = "切换TipTacItemRef插件的功能" },
		options = ttifOptions
	});
end

--------------------------------------------------------------------------------------------------------
--                                          初始化框架                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame",MOD_NAME,UIParent,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: 使用 BackdropTemplate

tinsert(UISpecialFrames, f:GetName()); -- 希望没有污染

f.options = options;

f:SetSize(360 + TT_OPTIONS_CATEGORY_LIST_WIDTH,378);
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(true);
f:SetMovable(true);
f:SetFrameStrata("DIALOG");
f:SetToplevel(true);
f:SetClampedToScreen(true);
f:SetScript("OnShow",function(self) self:BuildCategoryList(); self:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: 使用 BackdropTemplate
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetPoint("BOTTOMLEFT",12,12);
f.outline:SetWidth(TT_OPTIONS_CATEGORY_LIST_WIDTH);

f:SetScript("OnMouseDown",f.StartMoving);
f:SetScript("OnMouseUp",function(self) self:StopMovingOrSizing(); cfg.optionsLeft = self:GetLeft(); cfg.optionsBottom = self:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","GameFontHighlight");
f.header:SetFont(GameFontNormal:GetFont(),22,"THICKOUTLINE");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",9,-4);
f.header:SetText(CreateTextureMarkup("Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\tiptac_logo", 256, 256, nil, nil, 0, 1, 0, 1) .. " " .. PARENT_MOD_NAME.." 选项");

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
f.vers:SetPoint("TOPRIGHT",-15,-15);
local versionTipTac = C_AddOns.GetAddOnMetadata(PARENT_MOD_NAME, "Version");
local versionWoW, build = GetBuildInfo();
f.vers:SetText(PARENT_MOD_NAME .. ": " .. versionTipTac .. "\nWoW: " .. versionWoW);
f.vers:SetTextColor(1,1,0.5);

local function Anchor_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:AddLine("Anchor", 1, 1, 1);
	GameTooltip:AddLine("点击来切换 " .. PARENT_MOD_NAME .. "的可见性以及定位，来设置默认提示定位的位置。", nil, nil, nil, 1);
	GameTooltip:Show();
end

local function Anchor_OnLeave(self)
	GameTooltip:Hide();
end

f.btnAnchor = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnAnchor:SetSize(75,24);
f.btnAnchor:SetPoint("BOTTOMLEFT",f.outline,"BOTTOMRIGHT",9,1);
local TipTac = _G[PARENT_MOD_NAME];
f.btnAnchor:SetScript("OnClick",function() TipTac:SetShown(not TipTac:IsShown()) end);
f.btnAnchor:SetScript("OnEnter", Anchor_OnEnter);
f.btnAnchor:SetScript("OnLeave", Anchor_OnLeave);
f.btnAnchor:SetText("定位点");

local function Reset_OnClick(self)
	for index, option in ipairs(f.options[activePage].options or {}) do
		if (option.var) then
			cfg[option.var] = nil;	-- 清除后，它们将从元表中读取默认值
		end
	end
	TipTac:ApplyConfig();
	f:BuildCategoryPage();
	f:BuildCategoryList();
end

local function Reset_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:AddLine("Defaults", 1, 1, 1);
	GameTooltip:AddLine("重置当前页面的选项回到默认值。", nil, nil, nil, 1);
	GameTooltip:Show();
end

local function Reset_OnLeave(self)
	GameTooltip:Hide();
end

f.btnMisc = CreateFrame("Button", nil, f, "UIPanelButtonTemplate");
f.btnMisc:SetSize(75, 24);
f.btnMisc:SetPoint("LEFT", f.btnAnchor, "RIGHT", 9, 0);
f.btnMisc:SetScript("OnClick", Reset_OnClick);
f.btnMisc:SetScript("OnEnter", Reset_OnEnter);
f.btnMisc:SetScript("OnLeave", Reset_OnLeave);
f.btnMisc:SetText("默认值");

local function Misc_OnClick(self)
	ToggleDropDownMenu(1, nil, f.btnReport.dropDownMenu, f.btnReport, 0, 0);
end

local function Misc_SettingsDropDownOnClick(dropDownMenuButton, arg1, arg2)
	if (arg1 == "settingsImport") then
		-- 打开弹出窗口以获取导入字符串的新配置
		LibFroznFunctions:ShowPopupWithText({
			prompt = "粘贴新配置的导出字符串：",
			iconFile = "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\Talents",
			iconTexCoord = { 0.924316, 0.944824, 0.0380859, 0.0771484 },
			acceptButtonText = "导入",
			cancelButtonText = "取消",
			onShowHandler = function(self, data)
				-- 修复图标位置
				local alertIcon = _G[self:GetName() .. "AlertIcon"];
				
				if (not alertIcon) then
					return;
				end
				
				alertIcon:ClearAllPoints();
				alertIcon:SetPoint("LEFT", 24, 4);
			end,
			onAcceptHandler = function(self, data)
				-- 导入新配置的导出字符串
				local encodedConfig = self.editBox:GetText();
				local compressedConfig = LibDeflate:DecodeForPrint(encodedConfig);
				
				local function addFailedMessageToChatFrame()
					TipTac:AddMessageToChatFrame("{caption:" .. PARENT_MOD_NAME .. "}: {错误：无法导入新配置。导出字符串可能已损坏。}");
				end
				
				if (not compressedConfig) then
					addFailedMessageToChatFrame();
					return;
				end
				
				local serializedConfig = LibDeflate:DecompressDeflate(compressedConfig);
				
				if (not serializedConfig) then
					addFailedMessageToChatFrame();
					return;
				end
				
				local success, newCfg = LibSerialize:Deserialize(serializedConfig);
				
				if (not success) or (type(newCfg) ~= "table") then
					addFailedMessageToChatFrame();
					return;
				end
				
				-- 应用新配置
				LibFroznFunctions:MixinWholeObjects(cfg, newCfg);
				
				-- 通知组配置已加载
				-- LibFroznFunctions:FireGroupEvent(PARENT_MOD_NAME, "OnConfigLoaded", TT_CacheForFrames, cfg, TT_ExtendedConfig);
				
				-- 应用配置
				TipTac:ApplyConfig();
				f:BuildCategoryPage();
				f:BuildCategoryList();
				
				TipTac:AddMessageToChatFrame("{caption:" .. PARENT_MOD_NAME .. "}: 成功导入新的配置。");
			end
		});
	elseif (arg1 == "settingsExport") then
		-- 构建当前配置的导出字符串
		local serializedConfig = LibSerialize:Serialize(cfg);
		local compressedConfig = LibDeflate:CompressDeflate(serializedConfig);
		local encodedConfig = LibDeflate:EncodeForPrint(compressedConfig);
		
		-- 打开弹出窗口显示当前配置的导出字符串
		if (encodedConfig) then
			LibFroznFunctions:ShowPopupWithText({
				prompt = "复制当前配置的导出字符串：",
				lockedText = encodedConfig,
				iconFile = "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\Talents",
				iconTexCoord = { 0.924316, 0.942871, 0.000976562, 0.0361328 },
				acceptButtonText = "关闭",
				onShowHandler = function(self, data)
					-- 修复图标位置
					local alertIcon = _G[self:GetName() .. "AlertIcon"];
					
					if (not alertIcon) then
						return;
					end
					
					alertIcon:ClearAllPoints();
					alertIcon:SetPoint("LEFT", 24, 3);
				end
			});
		end
	end
	
	-- 关闭下拉菜单
	CloseDropDownMenus();
end

local function Misc_ReportDropDownOnClick(dropDownMenuButton, arg1, arg2)
	-- 构建URL
	local url;
	
	if (arg1 == "reportBug") then
		if (arg2 == "onGitHub") then
			url = LibFroznFunctions:ReplaceText("https://github.com/frozn/TipTac/issues/new?template=1_bug_report.yml&labels=1_bug&version-tiptac={versionTipTac}&version-wow={versionWoW}", {
				["{versionTipTac}"] = versionTipTac,
				["{versionWoW}"] = versionWoW
			});
		elseif (arg2 == "onCurseForge") then
			url = "https://www.curseforge.com/wow/addons/tiptac-reborn/comments";
		end
	elseif (arg1 == "requestFeature") then
		if (arg2 == "onGitHub") then
			url = "https://github.com/frozn/TipTac/issues/new?template=2_feature_request.yml&labels=1_enhancement";
		elseif (arg2 == "onCurseForge") then
			url = "https://www.curseforge.com/wow/addons/tiptac-reborn/comments";
		end
	end
	
	-- 设置图标
	local iconFile;
	
	if (arg2 == "onGitHub") then
		iconFile = "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\github";
	elseif (arg2 == "onCurseForge") then
		iconFile = "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\curseforge";
	end
	
	-- 打开弹出窗口显示URL
	if (url) then
		LibFroznFunctions:ShowPopupWithText({
			prompt = "在您的网络浏览器中打开此链接：",
			lockedText = url,
			iconFile = iconFile,
			acceptButtonText = "关闭",
			onShowHandler = function(self, data)
				-- 修复图标位置
				local alertIcon = _G[self:GetName() .. "AlertIcon"];
				
				if (not alertIcon) then
					return;
				end
				
				alertIcon:ClearAllPoints();
				alertIcon:SetPoint("LEFT", 24, 5);
			end
		});
	end
	
	-- 关闭下拉菜单
	CloseDropDownMenus();
end

local function Misc_DropDownOnInitialize(dropDownMenu, level, menuList)
	local list = LibFroznFunctions:CreatePushArray();
	
	if (level == 1) then
		list:Push({
			iconText = { "Interface\\HelpFrame\\HelpIcon-CharacterStuck", 64, 64, nil, nil, 0.1875, 0.796875, 0.203125, 0.796875 },
			text = "设置",
			menuList = "settings"
		});
		list:Push({
			iconText = { "Interface\\HelpFrame\\ReportLagIcon-Mail", 64, 64, nil, nil, 0.171875, 0.828125, 0.21875, 0.78125 },
			text = "报告",
			menuList = "report"
		});
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\CommonIcons", 64, 64, nil, nil, 0.126465, 0.251465, 0.504883, 0.754883 },
			text = "取消",
			func = Misc_SettingsDropDownOnClick,
			arg1 = "cancel"
		});
	elseif (menuList == "settings") then
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\Talents", 2048, 1024, nil, nil, 0.924316, 0.944824, 0.0380859, 0.0771484 },
			text = "导入",
			func = Misc_SettingsDropDownOnClick,
			arg1 = "settingsImport"
		});
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\Talents", 2048, 1024, nil, nil, 0.924316, 0.942871, 0.000976562, 0.0361328 },
			text = "导出",
			func = Misc_SettingsDropDownOnClick,
			arg1 = "settingsExport"
		});
	elseif (menuList == "report") then
		list:Push({
			iconText = { "Interface\\HelpFrame\\HelpIcon-Bug", 64, 64, nil, nil, 0.1875, 0.78125, 0.1875, 0.78125 },
			text = "报告bug",
			menuList = "reportBug"
		});
		list:Push({
			iconText = { "Interface\\HelpFrame\\HelpIcon-Suggestion", 64, 64, nil, nil, 0.21875, 0.765625, 0.234375, 0.78125 },
			text = "需求功能",
			menuList = "requestFeature"
		});
	elseif (menuList == "reportBug") then
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\github", 32, 32, nil, nil, 0, 1, 0, 1 },
			text = "在GitHub (推荐)",
			func = Misc_ReportDropDownOnClick,
			arg1 = "reportBug",
			arg2 = "onGitHub"
		});
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\curseforge", 32, 32, nil, nil, 0, 1, 0, 1 },
			text = "在CurseForge",
			func = Misc_ReportDropDownOnClick,
			arg1 = "reportBug",
			arg2 = "onCurseForge"
		});
	elseif (menuList == "requestFeature") then
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\github", 32, 32, nil, nil, 0, 1, 0, 1 },
			text = "在GitHub (推荐)",
			func = Misc_ReportDropDownOnClick,
			arg1 = "requestFeature",
			arg2 = "onGitHub"
		});
		list:Push({
			iconText = { "Interface\\AddOns\\" .. PARENT_MOD_NAME .. "\\media\\curseforge", 32, 32, nil, nil, 0, 1, 0, 1 },
			text = "在CurseForge",
			func = Misc_ReportDropDownOnClick,
			arg1 = "requestFeature",
			arg2 = "onCurseForge"
		});
	end
	
	if (list:GetCount() > 0) then
		for _, item in ipairs(list) do
			local info = UIDropDownMenu_CreateInfo();
			
			info.text = (item.iconText and (CreateTextureMarkup(unpack(item.iconText)) .. " ") or "") .. item.text;
			
			if (item.menuList) then
				info.hasArrow = true;
				info.menuList = item.menuList;
				info.keepShownOnClick = true;
			else
				info.func = item.func;
				info.arg1 = item.arg1;
				info.arg2 = item.arg2;
			end
			
			info.notCheckable = true;
			
			UIDropDownMenu_AddButton(info, level);
		end
	end
end

local function Misc_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:AddLine("杂项", 1, 1, 1);
	GameTooltip:AddLine("导入/导出设置，报告bugs或需求功能。", nil, nil, nil, 1);
	GameTooltip:Show();
end

local function Misc_OnLeave(self)
	GameTooltip:Hide();
end

f.btnReport = CreateFrame("Button", nil, f, "UIPanelButtonTemplate");
f.btnReport:SetSize(75, 24);
f.btnReport:SetPoint("LEFT", f.btnMisc, "RIGHT", 9, 0);
f.btnReport:SetScript("OnClick", Misc_OnClick);
f.btnReport:SetScript("OnEnter", Misc_OnEnter);
f.btnReport:SetScript("OnLeave", Misc_OnLeave);
f.btnReport:SetText("杂项");

f.btnReport.dropDownMenu = CreateFrame("Frame", nil, f.btnReport, "UIDropDownMenuTemplate");
UIDropDownMenu_Initialize(f.btnReport.dropDownMenu, Misc_DropDownOnInitialize, "MENU");

f.btnClose = CreateFrame("Button", nil, f, "UIPanelButtonTemplate");
f.btnClose:SetSize(75, 24);
f.btnClose:SetPoint("LEFT", f.btnReport, "RIGHT", 10, 0);
f.btnClose:SetScript("OnClick", function() f:Hide(); end);
f.btnClose:SetText("关闭");

local function SetScroll(value)
	local status = f.scrollFrame.status or f.scrollFrame.localstatus;
	local viewheight = f.scrollFrame:GetHeight();
	local height = f.content:GetHeight();
	local offset;

	if viewheight > height then
		offset = 0;
	else
		offset = floor((height - viewheight) / 1000.0 * value);
	end
	f.content:ClearAllPoints();
	f.content:SetPoint("TOPLEFT", 0, offset);
	f.content:SetPoint("TOPRIGHT", 0, offset);
	status.offset = offset;
	status.scrollvalue = value;
end

local function MoveScroll(self, value)
	local status = f.scrollFrame.status or f.scrollFrame.localstatus;
	local height, viewheight = f.scrollFrame:GetHeight(), f.content:GetHeight();

	if self.scrollBarShown then
		local diff = height - viewheight;
		local delta = 1;
		if value < 0 then
			delta = -1;
		end
		f.scrollBar:SetValue(min(max(status.scrollvalue + delta*(1000/(diff/45)),0), 1000));
	end
end

local function FixScroll(self)
	if self.updateLock then return end
	self.updateLock = true;
	local status = f.scrollFrame.status or f.scrollFrame.localstatus;
	local height, viewheight = f.scrollFrame:GetHeight(), f.content:GetHeight();
	local offset = status.offset or 0;
	-- Give us a margin of error of 2 pixels to stop some conditions that i would blame on floating point inaccuracys
	-- No-one is going to miss 2 pixels at the bottom of the frame, anyhow!
	if viewheight < height + 2 then
		if self.scrollBarShown then
			self.scrollBarShown = nil;
			f.scrollBar:Hide();
			f.scrollBar:SetValue(0);
			local scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs = f.scrollFrame:GetPoint(3);
			scrollFrameBottomRightXOfs = -13;
			f.scrollFrame:SetPoint(scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs);
			if f.content.original_width then
				f.content:SetWidth(f.content.original_width);
			end
		end
	else
		if not self.scrollBarShown then
			self.scrollBarShown = true;
			f.scrollBar:Show();
			local scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs = f.scrollFrame:GetPoint(3);
			scrollFrameBottomRightXOfs = -33;
			f.scrollFrame:SetPoint(scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs);
			if f.content.original_width then
				f.content:SetWidth(f.content.original_width - 20);
			end
		end
		local value = (offset / (viewheight - height) * 1000);
		if value > 1000 then value = 1000 end
		f.scrollBar:SetValue(value);
		SetScroll(value);
		if value < 1000 then
			f.content:ClearAllPoints();
			f.content:SetPoint("TOPLEFT", 0, offset);
			f.content:SetPoint("TOPRIGHT", 0, offset);
			status.offset = offset;
		end
	end
	self.updateLock = nil;
end

local function FixScrollOnUpdate(frame)
	frame:SetScript("OnUpdate", nil);
	FixScroll(frame);
end

local function ScrollFrame_OnMouseWheel(frame, value)
	MoveScroll(frame, value);
end

local function ScrollFrame_OnSizeChanged(frame)
	frame:SetScript("OnUpdate", FixScrollOnUpdate);
end

f.scrollFrame = CreateFrame("ScrollFrame", nil, f);
f.scrollFrame.status = {};
f.scrollFrame:SetPoint("TOP", f.header, "BOTTOM", 0, -12);
f.scrollFrame:SetPoint("LEFT", f.outline, "RIGHT", 0, 9);
f.scrollFrame:SetPoint("BOTTOM", f.btnClose, "TOP", 0, 9);
f.scrollFrame:SetPoint("RIGHT", f, "RIGHT", -13, 0);
f.scrollFrame:EnableMouseWheel(true);
f.scrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
f.scrollFrame:SetScript("OnSizeChanged", ScrollFrame_OnSizeChanged);

local function ScrollBar_OnScrollValueChanged(frame, value)
	SetScroll(value);
end

f.scrollBar = CreateFrame("Slider", nil, f.scrollFrame, "UIPanelScrollBarTemplate");
f.scrollBar:SetPoint("TOPLEFT", f.scrollFrame, "TOPRIGHT", 4, -16);
f.scrollBar:SetPoint("BOTTOMLEFT", f.scrollFrame, "BOTTOMRIGHT", 4, 16);
f.scrollBar:SetMinMaxValues(0, 1000);
f.scrollBar:SetValueStep(1);
f.scrollBar:SetValue(0);
f.scrollBar:SetWidth(16);
f.scrollBar:Hide();
-- set the script as the last step, so it doesn't fire yet
f.scrollBar:SetScript("OnValueChanged", ScrollBar_OnScrollValueChanged);

f.scrollBg = f.scrollBar:CreateTexture(nil, "BACKGROUND");
f.scrollBg:SetAllPoints(f.scrollBar);
f.scrollBg:SetColorTexture(0, 0, 0, 0.4);

--Container Support
f.content = CreateFrame("Frame", nil, f.scrollFrame)
f.content:SetHeight(400);
f.content:SetScript("OnSizeChanged", function(self, ...)
	ScrollFrame_OnSizeChanged(f.scrollFrame, ...);
end);
f.scrollFrame:SetScrollChild(f.content);
f.content:SetPoint("TOPLEFT");
f.content:SetPoint("TOPRIGHT");

--------------------------------------------------------------------------------------------------------
--                                        Build Option Category                                       --
--------------------------------------------------------------------------------------------------------

-- Get Setting
local function GetConfigValue(self,var)
	return cfg[var];
end

-- called when a setting is changed, do not allow
local function SetConfigValue(self,var,value,noBuildCategoryPage)
	if (not self.isBuildingOptions) then
		cfg[var] = value;
		local TipTac = _G[PARENT_MOD_NAME];
		TipTac:ApplyConfig();
		if (not noBuildCategoryPage) then
			f:BuildCategoryPage(true);
			f:BuildCategoryList();
		end
	end
end

-- create new factory instance
local factory = AzOptionsFactory:New(f.content,GetConfigValue,SetConfigValue);
f.factory = factory; 

-- Build Page
function f:BuildCategoryPage(noUpdateScrollFrame)
	-- update scroll frame
	if (not noUpdateScrollFrame) then
		f.scrollBar:SetValue(0);
	end
	
	-- build page
	factory:BuildOptionsPage(f.options[activePage].options, f.content, 0, 0);
	
	-- set new content height
	local contentChildren = { f.content:GetChildren() };
	local newContentHeight = nil;
	local contentChildMostBottom = nil;
	
	for index, contentChild in ipairs(contentChildren) do
		local contentChildTopLeftPoint, contentChildTopLeftRelativeTo, contentChildTopLeftRelativePoint, contentChildTopLeftXOfs, contentChildTopLeftYOfs = contentChild:GetPoint();
		if (contentChild:IsShown()) and ((not newContentHeight) or (-contentChildTopLeftYOfs >= newContentHeight)) then
			newContentHeight = -contentChildTopLeftYOfs;
			contentChildMostBottom = contentChild;
		end
	end
	
	local finalContentHeight = (newContentHeight or 0) + (contentChildMostBottom and contentChildMostBottom:GetHeight() or 0);
	
	f.content:SetHeight(finalContentHeight > 0 and finalContentHeight or 1);
end

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

local listButtons = {};

local function CategoryButton_OnClick(self,button)
	if (not listButtons[activePage].check.option) or (GetConfigValue(f.factory, listButtons[activePage].check.option.var)) then
		listButtons[activePage].text:SetTextColor(1, 0.82, 0);
	else
		listButtons[activePage].text:SetTextColor(0.5, 0.5, 0.5);
	end
	listButtons[activePage]:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight");
	listButtons[activePage]:GetHighlightTexture():SetAlpha(0.3);
	listButtons[activePage]:UnlockHighlight();
	activePage = self.index;
	if (not self.check.option) or (GetConfigValue(f.factory, self.check.option.var)) then
		self.text:SetTextColor(1, 1, 1);
	else
		self.text:SetTextColor(0.5, 0.5, 0.5);
	end
	self:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	self:GetHighlightTexture():SetAlpha(0.7);
	self:LockHighlight();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);	-- "igMainMenuOptionCheckBoxOn"
	f:BuildCategoryPage();
end

local function CheckButton_OnClick(self, button)
	local checked = (self:GetChecked() and true or false); -- WoD patch made GetChecked() return bool instead of 1/nil
	local b = self:GetParent();
	
	SetConfigValue(f.factory, self.option.var, checked);
	
	CategoryButton_OnClick(b, button);
	
	if (checked) then
		b.text:SetTextColor(1, 1, 1);
	else
		b.text:SetTextColor(0.5, 0.5, 0.5);
	end
end

local function CheckButton_OnEnter(self)
	if (self.option.tip) then
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
		GameTooltip:AddLine(self.option.label,1,1,1);
		GameTooltip:AddLine(self.option.tip,nil,nil,nil,1);
		GameTooltip:Show();
	end
end

local function CheckButton_OnLeave(self)
	GameTooltip:Hide();
end

local buttonWidth = (f.outline:GetWidth() - 8);
local function CreateCategoryButtonEntry(parent)
	local b = CreateFrame("Button",nil,parent);
	b:SetSize(buttonWidth,18);
	b:SetScript("OnClick",CategoryButton_OnClick);
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight");
	b:GetHighlightTexture():SetAlpha(0.3);
	b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
	b.text:SetPoint("LEFT",3,0);
	b.check = CreateFrame("CheckButton", nil, b);
	b.check:SetPoint("TOPLEFT", buttonWidth - 22, 2);
	b.check:SetPoint("BOTTOMRIGHT", 0, -2);
	b.check:SetScript("OnClick", CheckButton_OnClick);
	b.check:SetScript("OnEnter", CheckButton_OnEnter);
	b.check:SetScript("OnLeave", CheckButton_OnLeave);
	b.check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up");
	b.check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down");
	b.check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight");
	b.check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled");
	b.check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check");
	b.check:Hide();
	tinsert(listButtons, b);
	return b;
end

-- Build Category List
function f:BuildCategoryList()
	for index, table in ipairs(f.options) do
		local button = listButtons[index] or CreateCategoryButtonEntry(f.outline);
		button.text:SetText(table.category);
		button.text:SetTextColor(1,0.82,0);
		if (table.enabled) then
			local option = table.enabled;
			local cfgValue = GetConfigValue(f.factory, option.var);
			button.check.option = option;
			if (not option.label) then
				option.label = table.category;
			end
			button.check:SetChecked(cfgValue);
			local enabled = (not option.enabled) or (not not option.enabled(f.factory, button.check, option, cfgValue));
			button.check:SetEnabled(enabled);
			if (not cfgValue) or (not enabled) then
				button.text:SetTextColor(0.5, 0.5, 0.5);
			end
			button.check:Show();
		end
		button.index = index;
		if (index == 1) then
			button:SetPoint("TOPLEFT",f.outline,"TOPLEFT",5,-6);
		else
			button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
		end
		if (index == activePage) then
			if (not button.check.option) or (GetConfigValue(f.factory, button.check.option.var)) then
				button.text:SetTextColor(1, 1, 1);
			else
				button.text:SetTextColor(0.5, 0.5, 0.5);
			end
			button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
			button:GetHighlightTexture():SetAlpha(0.7);
			button:LockHighlight();
		end
	end
end
