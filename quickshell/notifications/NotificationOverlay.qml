import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../utils"
import "../Themes" as Themes

PanelWindow {
    id: root

    screen: Quickshell.screens.find(m => m.name === Config.preferredMonitor)
    visible: NotificationState.notifOverlayOpen

    WlrLayershell.namespace: "quickshell:notifications:overlay"
    WlrLayershell.layer: WlrLayer.Top

    implicitHeight: notifs.height
    implicitWidth: notifs.width + Themes.Theme.gapOut

    color: "transparent"

    anchors {
        top: true
        right: true
    }

    ColumnLayout {
        id: notifs

        Item {
            implicitHeight: Themes.Theme.gapIn * 2
        }

        Repeater {
            model: NotificationState.popupNotifs

            NotificationBox {
                id: notifBox
                required property int index
                n: NotificationState.popupNotifs[index]
                timestamp: Date.now()
                indexPopup: index

                Timer {
                    running: true
                    property int timeoutMs: (notifBox.n.expireTimeout > 0) ? notifBox.n.expireTimeout : (Config.notificationExpireTimeout * 1000)
                    interval: timeoutMs
                    onTriggered: {
                        NotificationState.notifDismissByNotif(notifBox.n);
                    }
                }
            }
        }
    }
}
