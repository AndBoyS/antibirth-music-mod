antibirthmusicplusplus = RegisterMod("Antibirth Music++", 1)
local SaveState = {}

-- ModConfig variables
-- Mega satan options: 
-- 0: play both
-- 1: Flagbearer
-- 2: Spectrum of Sin
local ModConfigSettings = {
	["boss intros"] = true,
  ["mega satan"] = 0, 
  ["void stage"] = true,
  ["void bosses"] = true,
  ["alt arcade"] = true,
}
-- setting this to "true" will override ModConfig values
local defaultsChanged = false

-- Unique intros for bosses

local BossIdToName = {
    [6] = "Mom",
    [8] = "Mom's Heart",
    [25] = "Mom's Heart",
    [39] = "Isaac",
--    [24] = "Satan",
    [40] = "Blue Baby",
    [54] = "Lamb",
    [70] = "Delirium",
    [88] = "Mother",
    [62] = "Ultra Greed",
}

-- Play boss intro
local function CrossfadeFunc(trackName, currentMusic)
  trackId = Isaac.GetMusicIdByName("True " .. trackName)
  if trackId and currentMusic ~= trackId then
    MusicManager():Crossfade(trackId)
  end
end

-- Queue boss track (when loading from main menu)
local function QueueFunc(trackName, currentMusic)
  trackId = Isaac.GetMusicIdByName(trackName)
  if trackId and currentMusic ~= trackId then
    MusicManager():Queue(trackId, 0)
  end
end


function antibirthmusicplusplus:intros()
  local currentMusic = MusicManager():GetCurrentMusicID()
  local room = Game():GetRoom()
  local trackMode = nil
  
  -- TrackMode == 1 -> main mode, play full version
  -- TrackMode == 2 -> queue the music after loading the game from main menu
  if currentMusic == Music.MUSIC_JINGLE_BOSS then
    trackMode = 1
    playFunc = CrossfadeFunc
  elseif room:GetType() == RoomType.ROOM_BOSS 
      and (currentMusic == Music.MUSIC_JINGLE_GAME_START or currentMusic == Music.MUSIC_JINGLE_GAME_START_ALT) then
    trackMode = 2
    playFunc = QueueFunc
  end
  
  if trackMode then
    
    trackName = BossIdToName[room:GetBossID()]
    -- if Story Boss Intros are disabled, play the music after the intro screen is finished
    if trackName and (ModConfigSettings["boss intros"] or Game():GetHUD():IsVisible()) then
      playFunc(trackName, currentMusic)
    end
    
  end
  
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.intros)


-- Play BB theme during hush fight manually (because we deleted its music in music.xml to allow unique intros)
function antibirthmusicplusplus:bluebabyhush()
  local stage = Game():GetLevel():GetStage()
  local currentMusic = MusicManager():GetCurrentMusicID()
  local bbTrack = Isaac.GetMusicIdByName("True Blue Baby")
  
  if stage == LevelStage.STAGE4_3 then
    
    for i,v in ipairs(Isaac.GetRoomEntities()) do
      
      if v.Type == EntityType.ENTITY_ISAAC and v.Variant == 2 
      and currentMusic ~= bbTrack and currentMusic ~= Isaac.GetMusicIdByName("Blue Baby Alt")
      and currentMusic ~= Music.MUSIC_HUSH_BOSS then
        MusicManager():Crossfade(bbTrack)
      end
    end
  end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.bluebabyhush)


function antibirthmusicplusplus:megasatan()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  local stage = Game():GetLevel():GetStage()
  
  --unique Mega Satan music
  if stage == LevelStage.STAGE6 and currentMusic == Music.MUSIC_SATAN_BOSS then
    if (math.random(1,2) == 1 or ModConfigSettings["mega satan"] == 1)
    and ModConfigSettings["mega satan"] ~= 2 then
      MusicM:Play(Isaac.GetMusicIdByName("Mega Satan"),0)
      MusicM:UpdateVolume()
    else
      MusicM:Play(Isaac.GetMusicIdByName("Satan"),0)
      MusicM:UpdateVolume()
    end
  end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_UPDATE, antibirthmusicplusplus.megasatan)


-- Tracks for void that play randomly
-- The Void 0 is the original track with intro
-- Other ones are only loops starting from a different point
local VoidMusic = {
  [1] = Isaac.GetMusicIdByName("The Void 0"),
  [2] = Isaac.GetMusicIdByName("The Void 1"),
  [3] = Isaac.GetMusicIdByName("The Void 2"),
  [4] = Isaac.GetMusicIdByName("The Void 3"),
  [5] = Isaac.GetMusicIdByName("The Void 4"),
  [6] = Isaac.GetMusicIdByName("The Void 5"),
  [7] = Isaac.GetMusicIdByName("The Void 6"),
  [8] = Isaac.GetMusicIdByName("The Void 7"),
}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


function antibirthmusicplusplus:void()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  
  -- Stage music
  if Game():GetLevel():GetStage() == LevelStage.STAGE7 
  and Game():GetRoom():GetType() == RoomType.ROOM_DEFAULT 
  and not has_value(VoidMusic, currentMusic)
  and currentMusic ~= Music.MUSIC_JINGLE_GAME_OVER 
  and currentMusic ~= Music.MUSIC_GAME_OVER then
    if currentMusic == Music.MUSIC_JINGLE_GAME_START
    or currentMusic == Music.MUSIC_JINGLE_GAME_START_ALT then
      MusicM:Queue(VoidMusic[1])
    elseif Game():GetRoom():IsFirstVisit()
    or not ModConfigSettings["void stage"] then
      MusicM:Crossfade(VoidMusic[1])
    else
      MusicM:Crossfade(VoidMusic[math.random(2,8)])
    end
  end
  
  -- Ordinary bosses
  if Game():GetLevel():GetStage() == LevelStage.STAGE7 
  and (currentMusic == Music.MUSIC_BOSS or currentMusic == Music.MUSIC_BOSS2)
  and ModConfigSettings["void bosses"] then
    trackId = Isaac.GetMusicIdByName("The Void Boss " .. math.random(1,5))
    --trackId = Isaac.GetMusicIdByName("The Void Boss " .. 5)
    MusicM:Crossfade(trackId)
  end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.void)


function antibirthmusicplusplus:greedlastwave()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  
  if Game():GetRoom():GetType() == RoomType.ROOM_DEFAULT
  and currentMusic == Music.MUSIC_SATAN_BOSS then
    MusicM:Play(Isaac.GetMusicIdByName("Mom"),0)
    MusicM:UpdateVolume()
  end
  if Game():GetRoom():IsClear() and currentMusic == Isaac.GetMusicIdByName("Mom")
  and currentMusic ~= Music.MUSIC_JINGLE_BOSS_OVER then
    MusicM:Play(Music.MUSIC_JINGLE_BOSS_OVER,0)
    MusicM:UpdateVolume()
    MusicM:Queue(Music.MUSIC_BOSS_OVER)
  end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_UPDATE, antibirthmusicplusplus.greedlastwave) 


-- Ambush theme without intro for minibosses
local RoomWithMinibosses = {RoomType.ROOM_MINIBOSS,
			    RoomType.ROOM_SHOP,
			    RoomType.ROOM_SECRET,
			    RoomType.ROOM_DEVIL,
			    RoomType.ROOM_ANGEL}

function antibirthmusicplusplus:miniboss()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  
  if has_value(RoomWithMinibosses, Game():GetRoom():GetType())
  and currentMusic == Music.MUSIC_CHALLENGE_FIGHT then
    MusicM:Play(Isaac.GetMusicIdByName("Ambush No Intro"), 0)
    MusicM:UpdateVolume()
  end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.miniboss)


-- Alt tracks that play randomly
local BossToRandom = nil
-- Executes with MC_POST_NEW_ROOM callback
local function UpdateBossToRandom()
  BossToRandom = {
    ["Satan"] = math.random(1,2),
    ["Blue Baby"] = math.random(1,2),
    ["Arcade"] = math.random(1,10),
  }
end
UpdateBossToRandom()
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, UpdateBossToRandom)

function antibirthmusicplusplus:alttracks()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  
  if Game():GetLevel():GetStage() == LevelStage.STAGE5 and currentMusic == Music.MUSIC_SATAN_BOSS 
  and BossToRandom["Satan"] == 1 then
    MusicM:Play(Isaac.GetMusicIdByName("Satan Alt"), 0)
    MusicM:UpdateVolume()
  end
  if (currentMusic == Isaac.GetMusicIdByName("Blue Baby")
  or currentMusic == Isaac.GetMusicIdByName("True Blue Baby"))
  and BossToRandom["Blue Baby"] == 1 then
    MusicM:Play(Isaac.GetMusicIdByName("Blue Baby Alt"), 0)
    MusicM:UpdateVolume()
  end
  if currentMusic == Music.MUSIC_ARCADE_ROOM
  and BossToRandom["Arcade"] == 1 
  and ModConfigSettings["alt arcade"] then
    MusicM:Play(Isaac.GetMusicIdByName("Arcade Alt"), 0)
    MusicM:UpdateVolume()
  end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.alttracks)


-- ModConfig API
local function AddBoolSetting(category, optionName, shortDescription, description)
  
  local BoolValues = {
    [true] = "On",
    [false] = "Off"
  }
  
  ModConfigMenu.AddSetting(category, {

    Type = ModConfigMenu.OptionType.BOOLEAN,

    CurrentSetting = function() return ModConfigSettings[optionName] end,

    Display = function() return shortDescription .. ": " .. BoolValues[ModConfigSettings[optionName]] end,

    OnChange = function(val) ModConfigSettings[optionName] = val end,

    Info = {description}
  })
end


local resetSettings = false
if ModConfigMenu then
  
  local category = "Antibirth Music++"
  ModConfigMenu.UpdateCategory(category, {
    Info = "Mudeth music mod with tweaks",
  })
  
  AddBoolSetting(category, "boss intros", "Story Boss Intros", "Boss music starts playing during the intro screen")
  
  -- Mega Satan
  local MegaSatanOptionValues = {
    [0] = "Play both versions",
    [1] = "Flagbearer",
    [2] = "Spectrum of Sin",
  }
  ModConfigMenu.AddSetting(category, {

    Type = ModConfigMenu.OptionType.NUMBER,

    CurrentSetting = function() return ModConfigSettings["mega satan"] end,
    
    Minimum = 0,
    Maximum = 2,

    Display = function() return "Mega Satan music: " .. MegaSatanOptionValues[ModConfigSettings["mega satan"]] end,

    OnChange = function(val) ModConfigSettings["mega satan"] = val end,

    Info = {"Mega Satan music option"}
  })

  AddBoolSetting(category, "void stage", "Random stage music in the Void", "Music plays from a random starting position in the Void")
  AddBoolSetting(category, "void bosses", "Random boss music in the Void", "Ordinary bosses in the Void have random music from different Isaac composers")
  AddBoolSetting(category, "alt arcade", "Alt arcade music", "DannyB's arcade theme can be played with 10% probability")

end


local json = require("json")

function antibirthmusicplusplus:SaveGame()
    SaveState.Settings = {}

    for i, v in pairs(ModConfigSettings) do
        SaveState.Settings[tostring(i)] = ModConfigSettings[i]
    end
    antibirthmusicplusplus:SaveData(json.encode(SaveState))
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, antibirthmusicplusplus.SaveGame)


function antibirthmusicplusplus:OnGameStart(isSave)
    if defaultsChanged then
        antibirthmusicplusplus:SaveGame()
    end

    if antibirthmusicplusplus:HasData() then
        SaveState = json.decode(antibirthmusicplusplus:LoadData())

        for i, v in pairs(SaveState.Settings) do
            ModConfigSettings[tostring(i)] = SaveState.Settings[i]
        end
    end
end

antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, antibirthmusicplusplus.OnGameStart)


  --Isaac.RenderText(,100,100,255,0,0,255)
  --Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ANGEL, -1)