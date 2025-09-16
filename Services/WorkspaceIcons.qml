pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    function iconsForWorkspace(workspace) {
        let icons = [];
        let hasWindows = false;
        Hyprland.toplevels.values.forEach(function(tl) {
            if (!tl || tl.workspace !== workspace || (!tl.title && !(tl.wayland && tl.wayland.appId))) return;
            hasWindows = true;
            let title = tl.title ? tl.title.toLowerCase() : "";
            let appId = (tl.wayland && tl.wayland.appId) ? tl.wayland.appId.toLowerCase() : "";
            if (appId.indexOf("youtube_music") !== -1) {
                icons.push("\uf166 ");
            } else if (title.indexOf("github") !== -1) {
                icons.push(" ");
            } else if (title.indexOf("minecraft") !== -1) {
                icons.push("󰍳 ");
            } else if (title.indexOf("gimp") !== -1) {
                icons.push(" ");
            } else if ((title.indexOf("nvim") !== -1 || title.indexOf("neovim") !== -1 || title.indexOf("vim") !== -1) && (appId.indexOf("kitty") !== -1)) {
                icons.push("\ue7c5 ");
            } else if (appId.indexOf("altus") !== -1) {
                icons.push("󰖣 ");
            } else if (appId.indexOf("kitty") !== -1) {
                icons.push(" ");
            } else if (appId.indexOf("obs") !== -1) {
                icons.push("󰑋");
            } else if (appId.indexOf("code") !== -1 || appId.indexOf("vscode") !== -1) {
                icons.push("\ue70c ");
            } else if (appId.indexOf("librewolf") !== -1) {
                icons.push("\uf269 ");
            } else if (appId.indexOf("steam") !== -1) {
                icons.push("\uf1b6 ");
            } else if (appId.indexOf("thunar") !== -1) {
                icons.push("  ");
            } else if (appId.indexOf("vesktop") !== -1 || appId.indexOf("discord") !== -1) {
                icons.push("󰙯 ");
            } else {
                icons.push("\uf059 ");
            }
        });
        var result = { icons: icons, hasWindows: hasWindows };
        return result;
    }
}
