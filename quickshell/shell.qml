//@ pragma Env QS_NO_RELOAD\_POPUP=1

import Quickshell;
import Quickshell.Io;
import QtQuick;
import "./Widgets";
import "./Modules";
import "./Themes";
import "./Panels";
import "./notifications"


Scope {
  id: root
  property string time
  property var openPowerMenu: []
  property var openRightPanel: []
  
  property int panelHeight: 0
  property int widgetHeight: 0

  property int powerWidth: 0
  property int powerHeight: 0


  Variants {
    model: Quickshell.screens

    Item {
      required property var modelData

      BarrierTop {id: barrier}
      TopBar {id: topBar}
      PowerMenu {id: powerMenu}
      BarrierPower {id: barrierPower}
      Wallpaper {id: wallpaper}
      WallpaperMenu {id: wallpaperMenu}
    }
  }
  NotificationOverlay {}
  AudioPanel{}
}
