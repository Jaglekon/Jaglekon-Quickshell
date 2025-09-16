import Quickshell;
import Quickshell.Io;
import QtQuick;
import "./Widgets";
import "./Modules";
import "./Themes";
import "./Panels";

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
      //RightPanel {id: rightPanel}
      Wallpaper {id: wallpaper}
    }
  }
}
