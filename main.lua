antibirthmusicplusplus = RegisterMod("Antibirth Music++", 1)

-- Unique intros for bosses

-- .. concatenates string/numbers into one string
-- Entity + name of the stage -> Boss Music to play
local EntityToMusicName = {
    [EntityType.ENTITY_ISAAC .. "Cathedral"]         = "Isaac Fight",
    [EntityType.ENTITY_ISAAC .. "The Void"]          = "Isaac Fight",
    
    [EntityType.ENTITY_MOM .. "Depths"]              = "Mom",
    [EntityType.ENTITY_MOM .. "Necropolis"]          = "Mom",
    [EntityType.ENTITY_MOM .. "Dank Depths"]         = "Mom",
    [EntityType.ENTITY_MOM .. "Mausoleum"]           = "Mom",
    [EntityType.ENTITY_MOM .. "Gehenna"]             = "Mom",
    
    [EntityType.ENTITY_MOMS_HEART .. "Womb"]         = "Mom's Heart",
    [EntityType.ENTITY_MOMS_HEART .. "Utero"]        = "Mom's Heart",
    [EntityType.ENTITY_MOMS_HEART .. "Scarred Womb"] = "Mom's Heart",
    [EntityType.ENTITY_MOMS_HEART .. "Mausoleum"]    = "Mom's Heart",
    [EntityType.ENTITY_MOMS_HEART .. "Gehenna"]      = "Mom's Heart",
    [EntityType.ENTITY_MOMS_HEART .. "The Void"]     = "Mom's Heart",
    
    [EntityType.ENTITY_MOTHER .. "Corpse"]           = "Mother",
}

local function GetStageId(level)
  return level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_DEFAULT,nil,RNG())).Data.StageID
end

local StageIdToName = {
    [6] = "The Void",
    [7] = "Depths",
    [8] = "Necropolis",
    [9] = "Dank Depths",
    [10] = "Womb",
    [11] = "Utero",
    [12] = "Scarred Womb",
    [15] = "Cathedral",
    [31] = "Mausoleum",
    [32] = "Gehenna",
    [33] = "Corpse",
}

local function CrossfadeFunc(TrackId)
  MusicManager():Crossfade(TrackId)
end

local function QueueFunc(TrackId)
  MusicManager():Queue(TrackId, 0)
end


function antibirthmusicplusplus:intros()
  local currentMusic = MusicManager():GetCurrentMusicID()
  local room = Game():GetRoom()
  local stageId = GetStageId(Game():GetLevel())
  local stageName = StageIdToName[stageId]
  
  -- TrackMode == 1 -> main mode, play full version
  -- TrackMode == 2 -> queue the music after loading the game from main menu
  if currentMusic == Music.MUSIC_JINGLE_BOSS then
    TrackMode = 1
    playFunc = CrossfadeFunc
  elseif room:GetType() == RoomType.ROOM_BOSS 
      and (currentMusic == Music.MUSIC_JINGLE_GAME_START or currentMusic == Music.MUSIC_JINGLE_GAME_START_ALT) then
    TrackMode = 2
    playFunc = QueueFunc
  end
  
  if TrackMode then
    for i,v in ipairs(Isaac.GetRoomEntities()) do
      trackName = EntityToMusicName[v.Type .. stageName]
      trackToPlay = trackName
      
      if trackName and TrackMode == 1 then
        trackToPlay = Isaac.GetMusicIdByName("True " .. trackName)
      elseif trackName and TrackMode == 2 then
        trackToPlay = Isaac.GetMusicIdByName(trackName)
      end
      
      if trackToPlay and currentMusic ~= trackToPlay then
        playFunc(trackToPlay)
      end
      
    end
  end
  
end








-----------------------------------------------------------------------------------------------------------------------
function antibirthmusicplusplus:megasatan()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  local GetStage = Game():GetLevel():GetStage()
  
  --unique Mega Satan music
  if GetStage == LevelStage.STAGE6 and currentMusic == Music.MUSIC_SATAN_BOSS then
    if math.random(1,2) == 1 then
      MusicM:Play(Isaac.GetMusicIdByName("Mega Satan"),0)
      MusicM:UpdateVolume()
    else
      MusicM:Play(Isaac.GetMusicIdByName("Satan"),0)
      MusicM:UpdateVolume()
    end
  end
end









-----------------------------------------------------------------------------------------------------------------------
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
  
  
  if Game():GetLevel():GetStage() == LevelStage.STAGE7 
  and Game():GetRoom():GetType() == RoomType.ROOM_DEFAULT 
  and not has_value(VoidMusic, currentMusic)
  and currentMusic ~= Music.MUSIC_JINGLE_GAME_OVER 
  and currentMusic ~= Music.MUSIC_GAME_OVER then
    if currentMusic == Music.MUSIC_JINGLE_GAME_START
    or currentMusic == Music.MUSIC_JINGLE_GAME_START_ALT then
      MusicM:Queue(VoidMusic[1])
    elseif Game():GetRoom():IsFirstVisit() then
      MusicM:Play(VoidMusic[1],0)
      MusicM:UpdateVolume()
    else
      MusicM:Play(VoidMusic[math.random(2,8)],0)
      MusicM:UpdateVolume()
    end
  end
end


















-----------------------------------------------------------------------------------------------------------------------
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


















-----------------------------------------------------------------------------------------------------------------------
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


















-----------------------------------------------------------------------------------------------------------------------
-- Alt start time for story bosses music
local BossToRandom = {
  ["Satan"] = math.random(1,2),
  ["Blue Baby"] = math.random(1,2),
  ["Arcade"] = math.random(1,5),
}
function antibirthmusicplusplus:storyboss()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  
  if Game():GetRoom():IsFirstVisit() and Game():GetRoom():GetType() == RoomType.ROOM_DEFAULT then
    BossToRandom = {
      ["Satan"] = math.random(1,2),
      ["Blue Baby"] = math.random(1,2),
      ["Arcade"] = math.random(1,5),
    }
  end
  
  if Game():GetLevel():GetStage() == LevelStage.STAGE5 and currentMusic == Music.MUSIC_SATAN_BOSS 
  and BossToRandom["Satan"] == 1 then
    MusicM:Play(Isaac.GetMusicIdByName("Satan Alt"), 0)
    MusicM:UpdateVolume()
  end
  if currentMusic == Music.MUSIC_BLUEBABY_BOSS 
  and BossToRandom["Blue Baby"] == 1 then
    MusicM:Play(Isaac.GetMusicIdByName("Blue Baby Alt"), 0)
    MusicM:UpdateVolume()
  end
  if currentMusic == Music.MUSIC_ARCADE_ROOM
  and BossToRandom["Arcade"] == 5 then
    MusicM:Play(Isaac.GetMusicIdByName("Arcade Alt"), 0)
    MusicM:UpdateVolume()
  end
end








  --Isaac.RenderText(,100,100,255,0,0,255)
  --Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ANGEL, -1)
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.intros)
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_UPDATE, antibirthmusicplusplus.megasatan)
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.void)
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_UPDATE, antibirthmusicplusplus.greedlastwave) 
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.miniboss)
antibirthmusicplusplus:AddCallback(ModCallbacks.MC_POST_RENDER, antibirthmusicplusplus.storyboss)
 