pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {

  function playerTypeName(player){
    if (!player) return "";
    let id = (player.identity ? player.identity : "") + " " + (player.name ? player.name : "");
    id = id.toLowerCase();
    let desktop = player.desktopEntry ? player.desktopEntry.toLowerCase() : "";
    let service = player.service ? player.service.toLowerCase() : "";
    if (id.indexOf("youtube_music") !== -1) return "yt-music";
    if (id.indexOf("firefox") !== -1 || service.indexOf("firefox") !== -1 || id.indexOf("librewolf") !== -1 || service.indexOf("librewolf") !== -1) return "firefox";
    if (id.indexOf("spotify") !== -1 || service.indexOf("spotify") !== -1) return "spotify";
    if (id.indexOf("mpv") !== -1 || service.indexOf("mpv") !== -1) return "mpv";
    return "unknown";
  }

  function playerTypeIcon(name) {
    if (name == "yt-music") return " ";
    if (name == "firefox") return " ";
    if (name == "spotify") return "󰓇 ";
    if (name == "mpv") return " ";
    return "\uf059 ";
  }
}