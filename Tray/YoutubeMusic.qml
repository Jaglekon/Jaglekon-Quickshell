import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../Modules"
import "../Themes"
import "../Services"

Item {
  implicitWidth: youtubeIcon.implicitWidth
  implicitHeight: youtubeIcon.implicitHeight
  id: youtubeTray

  function isYoutubeTrayPresent() {
    for (let i = 0; i < SystemTray.items.values.length; ++i) {
      let item = SystemTray.items.values[i]
      if (item.tooltipTitle && item.tooltipTitle.indexOf("YouTube Music") !== -1)
      {
        return true
      }
    }
    return false
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      youtubeTray.visible = youtubeTray.isYoutubeTrayPresent()
    }
  }

  Process {
    id: youtubeProc
    command: ["youtube-music"]
    running: false
  }
  

  Process {
    id: youtubeKill
    command: ["sh", "-c", "pkill -f youtube-music"]
    running: false
  }
  
  Click {
    anchors.fill: parent
    onLeftClicked: youtubeProc.running = true
    onRightClicked: youtubeKill.running = true
  }

  ModuleText {
    id: youtubeIcon
    label: "  "
    hovered: moduleRoot.hovered
  }

}