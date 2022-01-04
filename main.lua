antibirthmusicplusplus = RegisterMod("Antibirth Music++", 1)

-- Unique intros for bosses
-- .. concatenates string/numbers into one string
-- made to differentiate between base mom/mom's heart and antibirth one
-- Entity + name of the stage -> Boss Music to play
local EntityToMusic = {
    [EntityType.ENTITY_ISAAC .. "Cathedral"]         = Isaac.GetMusicIdByName("True Isaac Fight"),
    [EntityType.ENTITY_ISAAC .. "The Void"]          = Isaac.GetMusicIdByName("True Isaac Fight"),
    [EntityType.ENTITY_MOM .. "Mausoleum II"]        = Isaac.GetMusicIdByName("True Mom"),
    [EntityType.ENTITY_MOM .. "Mausoleum XL"]        = Isaac.GetMusicIdByName("True Mom"),
    [EntityType.ENTITY_MOM .. "Gehenna II"]          = Isaac.GetMusicIdByName("True Mom"),
    [EntityType.ENTITY_MOM .. "Gehenna XL"]          = Isaac.GetMusicIdByName("True Mom"),
    [EntityType.ENTITY_MOMS_HEART .. "Mausoleum II"] = Isaac.GetMusicIdByName("True Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Mausoleum XL"] = Isaac.GetMusicIdByName("True Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Gehenna II"]   = Isaac.GetMusicIdByName("True Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Gehenna XL"]   = Isaac.GetMusicIdByName("True Mom's Heart"),
    [EntityType.ENTITY_MOTHER .. "Corpse II"]        = Isaac.GetMusicIdByName("True Mother"),
    [EntityType.ENTITY_MOTHER .. "Corpse XL"]        = Isaac.GetMusicIdByName("True Mother"),
}
local EntityToMusicNoIntro = {
    [EntityType.ENTITY_ISAAC .. "Cathedral"]         = Isaac.GetMusicIdByName("Isaac Fight"),
    [EntityType.ENTITY_ISAAC .. "The Void"]          = Isaac.GetMusicIdByName("Isaac Fight"),
    [EntityType.ENTITY_MOM .. "Mausoleum II"]        = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Mausoleum XL"]        = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Gehenna II"]          = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Gehenna XL"]          = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOMS_HEART .. "Mausoleum II"] = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Mausoleum XL"] = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Gehenna II"]   = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Gehenna XL"]   = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOTHER .. "Corpse II"]        = Isaac.GetMusicIdByName("Mother"),
    [EntityType.ENTITY_MOTHER .. "Corpse XL"]        = Isaac.GetMusicIdByName("Mother"),
}
-- to queue base mom and moms heart music
local EntityToMusicQueue = {
    [EntityType.ENTITY_MOM .. "Depths II"]              = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Necropolis II"]          = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Dank Depths II"]         = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Depths XL"]              = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Necropolis XL"]          = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "Dank Depths XL"]         = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOM .. "The Void"]               = Isaac.GetMusicIdByName("Mom"),
    [EntityType.ENTITY_MOMS_HEART .. "Womb II"]         = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Utero II"]        = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Scarred Womb II"] = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Womb XL"]         = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Utero XL"]        = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "Scarred Womb XL"] = Isaac.GetMusicIdByName("Mom's Heart"),
    [EntityType.ENTITY_MOMS_HEART .. "The Void"]        = Isaac.GetMusicIdByName("Mom's Heart"),
}

function antibirthmusicplusplus:intros()
  local MusicM = MusicManager()
  local currentMusic = MusicM:GetCurrentMusicID()
  local room = Game():GetRoom()
  local stage = Game():GetLevel():GetStage()
  local stageName = Game():GetLevel():GetName()
  
  if currentMusic == Music.MUSIC_JINGLE_BOSS then
    for i,v in ipairs(Isaac.GetRoomEntities()) do
      trackToPlay = EntityToMusic[v.Type .. stageName]
      trackToQueue = EntityToMusicQueue[v.Type .. stageName]
      
      if trackToPlay and currentMusic ~= trackToPlay then
        MusicM:Crossfade(trackToPlay)
      -- Play the music when intro screen is closed
      -- Roomshape defined to evade Delirium boss room
      elseif trackToQueue and Game():GetHUD():IsVisible() and Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then
        MusicManager():Crossfade(trackToQueue)
      end
    end
  end
    
  if room:GetType() == RoomType.ROOM_BOSS 
  and (currentMusic == Music.MUSIC_JINGLE_GAME_START or currentMusic == Music.MUSIC_JINGLE_GAME_START_ALT) then
    
    for i,v in ipairs(Isaac.GetRoomEntities()) do
      trackToQueue = (EntityToMusicNoIntro[v.Type .. stageName] or EntityToMusicQueue[v.Type .. stageName])
      if trackToQueue and currentMusic ~= trackToQueue then
        MusicM:Queue(trackToQueue, 0)
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
 