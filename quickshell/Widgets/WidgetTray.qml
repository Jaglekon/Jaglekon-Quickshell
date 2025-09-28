import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../Modules"
import "../Themes"
import "../Services"
import "../Tray"

ModuleWidget {
  id: moduleRoot

  property bool anyTrayVisible: discord.visible || steam.visible || whatsApp.visible
  paddingHorizontal: anyTrayVisible ? 10 : 0
  
  onAnyTrayVisibleChanged: {
    if (parent && parent.updateWidgetIndices) {
      Qt.callLater(parent.updateWidgetIndices)
    }
  }

  Discord { id: discord }
  Steam { id: steam }
  WhatsApp { id: whatsApp }
}