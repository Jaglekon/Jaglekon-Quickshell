pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io;

Singleton {
  
  id: root

  property bool backlightExists: false

  function backlight() {
  }

  Timer {
    interval: 10
    running: true
    repeat: true
    onTriggered: {
      backlight()
    }
  }

  Process {
    id: backlightThere
    command: ["sh", "-c", "brightnessctl -lm | grep -q 'backlight' && echo 1 || echo 0"] 
    running: true 
    stdout: SplitParser {
      onRead: data => {
        root.backlightExists = (parseInt(data) === 1)
      }
    }
  }
}

