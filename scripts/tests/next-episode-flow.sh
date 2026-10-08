#!/usr/bin/env bash
set -euo pipefail

grep -q 'field id="nextPlaybackRequested" type="assocarray" alwaysNotify="true"' components/screens/PlayerScreen.xml
grep -q 'field id="nextPlayback" type="assocarray" alwaysNotify="true"' components/screens/PlayerScreen.xml
grep -q 'id="nextEpisodePromptGroup"' components/screens/PlayerScreen.xml
grep -q 'id="nextEpisodeCountdownTimer"' components/screens/PlayerScreen.xml

grep -q "nextEpisodePromptRemainingSeconds" components/screens/PlayerScreen.brs
grep -q "nextEpisodePromptThresholdSeconds" components/screens/PlayerScreen.brs
grep -q "maybeRequestNextEpisodePrompt" components/screens/PlayerScreen.brs
grep -q "showNextEpisodePrompt" components/screens/PlayerScreen.brs
grep -q "handleNextEpisodePromptKey" components/screens/PlayerScreen.brs
grep -q "chooseNextEpisodePromptOption" components/screens/PlayerScreen.brs
grep -q 'reason: "seasonCarousel"' components/screens/PlayerScreen.brs
grep -q 'm.seasonCarouselRequestPending = true' components/screens/PlayerScreen.brs
grep -q 'if m.seasonCarouselRequestPending = true' components/screens/PlayerScreen.brs
grep -q 'response = invalid or response.reason <> "seasonCarousel"' components/screens/PlayerScreen.brs
grep -q 'm.nextEpisodeRequested = false' components/screens/PlayerScreen.brs
grep -q 'selectFocusedSeasonCarouselEpisode' components/screens/PlayerScreen.brs
grep -q 'm.top.nextPlaybackRequested = {' components/screens/PlayerScreen.brs
grep -q 'maybeRequestNextEpisodePrompt("threshold")' components/screens/PlayerScreen.brs
grep -q 'maybeRequestNextEpisodePrompt("finished")' components/screens/PlayerScreen.brs

grep -q 'field id="nextPlaybackRequested" type="assocarray" alwaysNotify="true"' components/screens/VideoDetailScreen.xml
grep -q 'field id="nextPlayback" type="assocarray" alwaysNotify="true"' components/screens/VideoDetailScreen.xml
grep -q 'm.top.observeField("nextPlaybackRequested", "onNextPlaybackRequested")' components/screens/VideoDetailScreen.brs
grep -q "function videoDetailScreenNextPlayableMediaAfter" components/screens/VideoDetailScreen.brs
grep -q "function videoDetailScreenRequestedPlayableMedia" components/screens/VideoDetailScreen.brs
grep -q 'if reason = "seasonCarousel"' components/screens/VideoDetailScreen.brs
grep -q 'videoDetailScreenNextPlayableMediaAfter(request)' components/screens/VideoDetailScreen.brs
grep -q "sub videoDetailScreenPrepareNextPlaybackPreflight" components/screens/VideoDetailScreen.brs
grep -q 'requestReason = reason' components/screens/VideoDetailScreen.brs
grep -q 'reason = videoDetailScreenNextPlaybackRequestReasonFromPayload(fallbackPayload)' components/screens/VideoDetailScreen.brs
grep -q 'm.top.nextPlayback = { ok: true, playback: videoDetailScreenPlaybackPayloadForMedia(response.media), reason: reason }' components/screens/VideoDetailScreen.brs
grep -q 'm.top.nextPlayback = { ok: true, playback: fallbackPayload, reason: reason }' components/screens/VideoDetailScreen.brs
grep -q 'm.top.nextPlayback = { ok: false, message: message, reason: reason }' components/screens/VideoDetailScreen.brs
grep -q 'm.top.nextPlayback = {' components/screens/VideoDetailScreen.brs
grep -q 'ok: false' components/screens/VideoDetailScreen.brs

grep -q 'playerScreen.observeField("nextPlaybackRequested", "onPlayerNextPlaybackRequested")' components/AppScene.brs
grep -q 'detailScreen.observeField("nextPlayback", "onVideoDetailNextPlayback")' components/AppScene.brs
grep -q "sub onPlayerNextPlaybackRequested" components/AppScene.brs
grep -q "sub onVideoDetailNextPlayback" components/AppScene.brs
grep -q "m.playerScreen.nextPlayback = nextPlayback" components/AppScene.brs

# The mode defaults to the original early prompt and migrates the old setting.
grep -q 'loadNextEpisodeMode: appSettingsLoadNextEpisodeMode' source/services/AppSettingsStore.brs
grep -q 'saveNextEpisodeMode: appSettingsSaveNextEpisodeMode' source/services/AppSettingsStore.brs
grep -q 'section.Read("nextEpisodePromptEnabled") = "0" then return "afterEnd"' source/services/AppSettingsStore.brs
grep -q 'return "earlyPrompt"' source/services/AppSettingsStore.brs
grep -q 'section.Write("nextEpisodeMode", mode)' source/services/AppSettingsStore.brs
grep -q 'section.Flush()' source/services/AppSettingsStore.brs

# Settings exposes both modes; the player refreshes the choice on playback.
grep -q 'Следующая серия: ' components/screens/SettingsScreen.brs
grep -q 'Окно заранее' components/screens/SettingsScreen.brs
grep -q 'Автоматически в конце' components/screens/SettingsScreen.brs
grep -q 'm.appSettingsStore.saveNextEpisodeMode(m.nextEpisodeMode)' components/screens/SettingsScreen.brs
grep -q 'pkg:/source/services/AppSettingsStore.brs' components/screens/PlayerScreen.xml
grep -q 'm.nextEpisodeMode = m.appSettingsStore.loadNextEpisodeMode()' components/screens/PlayerScreen.brs

# The early threshold is skipped in afterEnd mode; finished switches directly.
grep -A 4 'sub maybeRequestNextEpisodePrompt(reason as String)' components/screens/PlayerScreen.brs | grep -q 'if reason = "threshold" and m.nextEpisodeMode <> "earlyPrompt" then return'
grep -q 'maybeRequestNextEpisodePrompt("threshold")' components/screens/PlayerScreen.brs
grep -q 'maybeRequestNextEpisodePrompt("finished")' components/screens/PlayerScreen.brs
grep -q 'response.reason = "finished" and m.nextEpisodeMode = "afterEnd"' components/screens/PlayerScreen.brs
grep -A 3 'response.reason = "finished" and m.nextEpisodeMode = "afterEnd"' components/screens/PlayerScreen.brs | grep -q 'startNextPlayback(response.playback)'
# Explicit next-episode controls still take their existing direct paths.
grep -q 'reason: "manualNext"' components/screens/PlayerScreen.brs
grep -q 'reason: "seasonCarousel"' components/screens/PlayerScreen.brs
grep -q 'm.nextEpisodeCountdownTimer.control = "start"' components/screens/PlayerScreen.brs
