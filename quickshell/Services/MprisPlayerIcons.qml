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
    if (id.indexOf("youtube_music") !== -1) return " ";
    if (id.indexOf("firefox") !== -1 || service.indexOf("firefox") !== -1 || id.indexOf("librewolf") !== -1 || service.indexOf("librewolf") !== -1) return " ";
    if (id.indexOf("spotify") !== -1 || service.indexOf("spotify") !== -1) return "󰓇 ";
    if (id.indexOf("feishin") !== -1 || service.indexOf("feishin") !== -1) return "󰽰 ";
    if (id.indexOf("kdeconnect") !== -1 || service.indexOf("kdeconnect") !== -1 || desktop.indexOf("kdeconnect") !== -1) return " ";
    return "\uf059 ";
  }
}