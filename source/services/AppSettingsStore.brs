' Local (device-only) app preferences that have no KinoPub API counterpart.
' Includes the hide-anime filter and next-episode playback mode. Persisted
' via roRegistrySection, same pattern as TokenStore.brs/SearchHistoryStore.brs.
' Hide anime defaults to enabled; the next-episode mode defaults to the
' existing early prompt behavior.

function AppSettingsStore() as Object
    return {
        sectionName: "kinoappsettings"
        loadHideAnime: appSettingsLoadHideAnime
        saveHideAnime: appSettingsSaveHideAnime
        loadNextEpisodeMode: appSettingsLoadNextEpisodeMode
        saveNextEpisodeMode: appSettingsSaveNextEpisodeMode
    }
end function

function appSettingsLoadHideAnime() as Boolean
    section = CreateObject("roRegistrySection", m.sectionName)
    if section.Exists("hideAnime") <> true then return true
    return section.Read("hideAnime") = "1"
end function

sub appSettingsSaveHideAnime(value as Boolean)
    section = CreateObject("roRegistrySection", m.sectionName)
    text = "0"
    if value = true then text = "1"
    section.Write("hideAnime", text)
    section.Flush()
end sub

' Keep the previous early-prompt preference when upgrading an existing install.
function appSettingsLoadNextEpisodeMode() as String
    section = CreateObject("roRegistrySection", m.sectionName)
    if section.Exists("nextEpisodeMode")
        if section.Read("nextEpisodeMode") = "afterEnd" then return "afterEnd"
        return "earlyPrompt"
    end if
    if section.Exists("nextEpisodePromptEnabled") and section.Read("nextEpisodePromptEnabled") = "0" then return "afterEnd"
    return "earlyPrompt"
end function

sub appSettingsSaveNextEpisodeMode(value as String)
    section = CreateObject("roRegistrySection", m.sectionName)
    mode = "earlyPrompt"
    if value = "afterEnd" then mode = "afterEnd"
    section.Write("nextEpisodeMode", mode)
    section.Flush()
end sub
