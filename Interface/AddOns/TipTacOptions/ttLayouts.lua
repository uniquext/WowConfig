local cfg = TipTac_Config;
local MOD_NAME = ...;
local PARENT_MOD_NAME = "TipTac";

TipTacLayouts = {};

--------------------------------------------------------------------------------------------------------
--                                           布局预设                                           --
--------------------------------------------------------------------------------------------------------

local layout_presets = {
	-- TipTac 布局 (新)
	["TipTac 新风格"] = {
		showTarget = "last",
		targetYouText = "<<你>>",

		tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		pixelPerfectBackdrop = false,
		backdropEdgeSize = 14,
		backdropInsets = 2.5,
		tipColor = { 0.1, 0.1, 0.2, 1.0 },
		tipBorderColor = { 0.3, 0.3, 0.4, 1.0 },
		gradientTip = true,
		gradientColor = { 0.8, 0.8, 0.8, 0.15 },

		reactColoredBackdrop = false,

		colorSameGuild = { 1, 0.2, 1, 1 },
		colorRace = { 1, 1, 1, 1},
		colorLevel = { 0.75, 0.75, 0.75, 1},

		colorNameByClass = false,
		classColoredBorder = false,

		barFontFace = STANDARD_TEXT_FONT,
		barFontSize = 10,
		barFontFlags = "OUTLINE",
		barHeight = 6,

		classification_minus = "-%s",
		classification_trivial = "~%s",
		classification_normal = "%s",
		classification_elite = "+%s",
		classification_worldboss = "%s|r (首领)",
		classification_rare = "%s|r (稀有)",
		classification_rareelite = "+%s|r (稀有)",

		overrideFade = true,
		preFadeTime = 0.1,
		fadeTime = 0.1,
		hideWorldTips = true,

		hideDefaultBar = true,
		healthBar = true,
		healthBarClassColor = true,
		healthBarText = "value",
		healthBarColor = { 0.3, 0.9, 0.3, 1 },
		manaBar = false,
		powerBar = false,
	},
	-- TipTac 布局 (旧)
	["TipTac 旧风格"] = {
		showTarget = "belowNameRealm",
		targetYouText = "<<你>>",

		reactColoredBackdrop = false,

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		pixelPerfectBackdrop = false,
		backdropEdgeSize = 16,
		backdropInsets = 4,
		tipColor = { 0.1, 0.1, 0.2, 1.0 },
		tipBorderColor = { 0.3, 0.3, 0.4, 1.0 },
		gradientTip = false,

		colorSameGuild = { 1, 0.2, 1, 1 },
		colorRace = { 1, 1, 1, 1},
		colorLevel = { 0.75, 0.75, 0.75, 1},

		colorNameByClass = false,
		classColoredBorder = false,

		barFontFace = STANDARD_TEXT_FONT,
		barFontSize = 12,
		barFontFlags = "OUTLINE",
		barHeight = 6,

		classification_minus = "-%s",
		classification_trivial = "~%s",
		classification_normal = "%s",
		classification_elite = "+%s",
		classification_worldboss = "%s|r (首领)",
		classification_rare = "%s|r (稀有)",
		classification_rareelite = "+%s|r (稀有)",

		hideDefaultBar = true,
		healthBar = true,
		healthBarClassColor = true,
		healthBarText = "value",
		healthBarColor = { 0.3, 0.9, 0.3, 1 },
		manaBar = false,
		powerBar = false,
	},
	-- TipBuddy 布局
	["TipBuddy"] = {
		showTarget = "afterName",
		targetYouText = "[你]",

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		pixelPerfectBackdrop = false,
		backdropEdgeSize = 16,
		backdropInsets = 4,
		tipColor = { 0.1, 0.1, 0.1, 0.8 },
		tipBorderColor = { 0.8, 0.8, 0.9, 1.0 },

		reactColoredBackdrop = false,

		colorSameGuild = { 1, 0.2, 1, 1 },
		colorRace = { 1, 1, 1, 1},
		colorLevel = { 0.75, 0.75, 0.75, 1},

		colorNameByClass = false,
		classColoredBorder = false,

		barFontFace = STANDARD_TEXT_FONT,
		barFontSize = 12,
		barFontFlags = "OUTLINE",
		barHeight = 6,

		classification_minus = "-%s",
		classification_trivial = "~%s",
		classification_normal = "%s",
		classification_elite = "+%s",
		classification_worldboss = "%s|r (首领)",
		classification_rare = "%s|r (稀有)",
		classification_rareelite = "+%s|r (稀有)",

		hideDefaultBar = false,
		healthBar = false,
		manaBar = false,
		powerBar = false,
	},
	-- TinyTip 布局
	["TinyTip"] = {
		showTarget = "last",
		targetYouText = "<<你>>",

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		pixelPerfectBackdrop = false,
		backdropEdgeSize = 16,
		backdropInsets = 4,
		tipColor = { 0, 0, 0, 1 },
		tipBorderColor = { 0, 0, 0, 1 },

		reactColoredBackdrop = true,

		colorRace = { 0.87, 0.93, 1, 0.67},
		colorLevel = { 1, 0.8, 0, 1},

		classification_minus = "等级 -%s",
		classification_trivial = "等级 ~%s",
		classification_normal = "等级 %s",
		classification_elite = "等级 %s|cffffcc00 精英",
		classification_worldboss = "等级 %s|cffff0000 首领",
		classification_rare = "等级 %s|cffff66ff 稀有",
		classification_rareelite = "等级 %s|cffffaaff 稀有精英",

		hideDefaultBar = false,
		healthBar = false,
		manaBar = false,
		powerBar = false,
	},
	-- 实心边框布局
	["实心边框"] = {
		showTarget = "last",
		targetYouText = "|cffff0000<<你>>",

		tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
		tipBackdropEdge = "Interface\\Buttons\\WHITE8X8",
		pixelPerfectBackdrop = false,
		backdropEdgeSize = 2.5,
		backdropInsets = 0,
		tipColor = { 0.09, 0.09, 0.19, 1.0 },
		tipBorderColor = { 0.6, 0.6, 0.6, 1.0 },

		reactColoredBackdrop = false,

		colorNameByClass = false,
		classColoredBorder = true,
	},
	-- 暴雪布局
	["暴雪"] = {
		colorGuildByReaction = true,
		colorSameGuild = { 1, 0.2, 1, 1 },
		colorRace = { 1, 1, 1, 1},
		colorLevel = { 0.75, 0.75, 0.75, 1},
		colorNameByClass = false,
		classColoredBorder = false,

		reactColoredBackdrop = false,
		reactColoredBorder = false,

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		pixelPerfectBackdrop = false,
		backdropEdgeSize = 16,
		backdropInsets = 5,
		tipColor = { TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1 },
		tipBorderColor = { 1, 1, 1, 1 },
		gradientTip = false,

		fontFace = STANDARD_TEXT_FONT,
		fontSize = 14,
		fontFlags = "",
		fontSizeDelta = 2,

		classification_minus = "|r等级 -%s",
		classification_trivial = "|r等级 ~%s",
		classification_normal = "|r等级 %s",
		classification_elite = "|r等级 %s (精英)",
		classification_worldboss = "|r等级 %s (首领)",
		classification_rare = "|r等级 %s (稀有)",
		classification_rareelite = "|r等级 %s (稀有精英)",

		overrideFade = false,
		hideWorldTips = false,

		hideDefaultBar = false,
		healthBar = false,
		manaBar = false,
		powerBar = false,
	},
};

local function LoadLayout_SelectValue(dropDown,entry,index)
	for name, value in next, layout_presets[entry.value] do
		cfg[name] = value;
	end
	local TipTac = _G[PARENT_MOD_NAME];
	TipTac:ApplyConfig();
	dropDown:SetText("|cff80ff80布局已加载");
end

local function DeleteLayout_SelectValue(dropDown,entry,index)
	layout_presets[entry.value] = nil;
	dropDown:SetText("|cffff8080布局已删除!");
end

function TipTacLayouts.LoadLayout_Init(dropDown,list)
	dropDown.selectValueFunc = LoadLayout_SelectValue;
	for name, cfgTable in next, layout_presets do
		local tbl = list[#list + 1];
		tbl.text = name;
		tbl.value = name;
		local count = 0;
		table.foreach(cfgTable,function() count = count + 1; end);
		tbl.tip = ("%d 个配置变量将被应用"):format(count);
	end
	dropDown:SetText("|cff00ff00选择布局...");
end

function TipTacLayouts.DeleteLayout_Init(dropDown,list)
	dropDown.selectValueFunc = DeleteLayout_SelectValue;
	for name in next, layout_presets do
		local tbl = list[#list + 1];
		tbl.text = name; tbl.value = name;
	end
	dropDown:SetText("|cff00ff00删除布局...");
end  
