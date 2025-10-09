pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import org.kde.kirigami
import "../components"
import "../Modules"
import "../Themes" as Themes
import "../utils"

WrapperMouseArea {
    id: rootNotif

    acceptedButtons: Qt.AllButtons
    hoverEnabled: true

    property Notification n
    property real timestamp
    property real elapsed: Date.now()
    property string image: (n.image == "" && n.appIcon != "") ? n.appIcon : n.image
    property bool hasAppIcon: !(n.image == "" && n.appIcon != "")
    property int indexPopup: -1
    property int indexAll: -1
    property real iconSize: Themes.Theme.fontPixelSize * 4

    property bool showTime: false
    property bool expanded: false

    opacity: Themes.Theme.opacity

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton && rootNotif.n.actions != []) {
            rootNotif.n.actions[0].invoke();
        } else if (mouse.button == Qt.RightButton) {
            if (indexAll != -1)
                NotificationState.notifDismissByAll(indexAll);
            else if (indexPopup != -1)
                NotificationState.notifDismissByPopup(indexPopup);
        } else if (mouse.button == Qt.MiddleButton) {
            NotificationState.dismissAll();
        }
    }

    ElapsedTimer {
        id: elapsedTimer
    }

    Timer {
        running: rootNotif.showTime
        interval: 1000
        repeat: true
        onTriggered: rootNotif.elapsed = elapsedTimer.elapsed()
    }

    Rectangle {
        id: mainRect
        implicitWidth: Themes.Theme.fontPixelSize * 26
        implicitHeight: mainLayout.implicitHeight
        radius: Themes.Theme.rounding
        color: Themes.Theme.background

        property int panelMargin: 8

        Rectangle {

          property int widthModifier:  rootNotif.containsMouse ?  Themes.Theme.fontPixelSize * 1.5  + buttonLayout.width : (Themes.Theme.fontPixelSize * 0.5 * 2)
          
          width: rootNotif.image != "" ? parent.width - widthModifier - Themes.Theme.fontPixelSize * 0.5 - coverItem.width : parent.width - widthModifier
          
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.bottom: parent.bottom
          anchors.leftMargin: coverItem.visible ? coverItem.width + Themes.Theme.fontPixelSize * 0.5 * 2 : Themes.Theme.fontPixelSize * 0.5
          anchors.topMargin: Themes.Theme.fontPixelSize * 0.5
          anchors.bottomMargin: Themes.Theme.fontPixelSize * 0.5

          color: Themes.Theme.background_var
          radius: Themes.Theme.rounding

          Behavior on width {
           NumberAnimation { 
              duration: 150
              easing.type: Easing.InOutQuad
            }
          }
        }

        RowLayout {
          id: mainLayout

          spacing: 8

          anchors {
            top: parent.top
            left: parent.left
            right: parent.right
          }


          Item {
            id: coverItem

            visible: rootNotif.image != ""

            Layout.alignment: Qt.AlignTop
            implicitWidth: rootNotif.iconSize + Themes.Theme.fontPixelSize
            implicitHeight: rootNotif.iconSize + Themes.Theme.fontPixelSize
            Layout.margins: Themes.Theme.fontPixelSize * 0.5
            Layout.rightMargin: 0

            Rectangle {

              anchors.fill: parent
              color: Themes.Theme.background_var
              radius: Themes.Theme.rounding

              ClippingWrapperRectangle {
                anchors.centerIn: parent
                radius: Themes.Theme.rounding
                color: "transparent"

                IconImage {
                  id: image
                  anchors.fill: parent
                  implicitSize: rootNotif.iconSize
                  source: Utils.getImage(rootNotif.image)
                }
              }
            }

            ClippingWrapperRectangle {
              visible: rootNotif.hasAppIcon

              anchors {
                horizontalCenter: coverItem.right
                verticalCenter: coverItem.bottom
                horizontalCenterOffset: - Themes.Theme.fontPixelSize
                verticalCenterOffset: - Themes.Theme.fontPixelSize
              }

              radius: 2
              color: "transparent"

              IconImage {
                implicitSize: image.implicitSize / 3
                source: Utils.getImage(rootNotif.n.appIcon)
              }
            }
          }

          ColumnLayout {
            id: contentLayout

            Layout.fillWidth: true
            Layout.margins: Themes.Theme.fontPixelSize * 0.5 + mainRect.panelMargin
            Layout.leftMargin: coverItem.visible ? 6 + mainRect.panelMargin : Themes.Theme.fontPixelSize * 0.5 + mainRect.panelMargin
            Layout.rightMargin: buttonLayout.visible ? Themes.Theme.fontPixelSize * 1.2 + Themes.Theme.fontPixelSize + mainRect.panelMargin : mainRect.panelMargin + Themes.Theme.fontPixelSize * 0.5
            spacing: 4


            SystemClock {
              id: clock
              precision: SystemClock.Seconds
              enabled: false
            }

            ModuleText {
              id: bodyTime
              Layout.fillWidth: true
              elide: Text.ElideRight
              wrapMode: Text.Wrap
              maximumLineCount: rootNotif.expanded ? 5 : (rootNotif.n.actions.length > 1 ? 1 : 2)
              text: Qt.formatDateTime(clock.date, "hh:mm")
              font.pixelSize: Themes.Theme.fontPixelSize * 0.7
            }

            ModuleText {
              id: headText
              Layout.fillWidth: true
              elide: Text.ElideRight
              wrapMode: Text.Wrap
              maximumLineCount: rootNotif.expanded ? 5 : (rootNotif.n.actions.length > 1 ? 1 : 2)
              text: rootNotif.n.summary
              font.weight: Font.Bold
            }

            ModuleText {
              id: bodyText
              Layout.fillWidth: true
              elide: Text.ElideRight
              wrapMode: Text.Wrap
              maximumLineCount: rootNotif.expanded ? 5 : (rootNotif.n.actions.length > 1 ? 1 : 2)
              text: rootNotif.n.body
            }
          }
        }

        ColumnLayout {
            id: buttonLayout
            visible: rootNotif.containsMouse

            anchors {
                top: parent.top
                right: parent.right
                topMargin: Themes.Theme.fontPixelSize * 0.5
                rightMargin: Themes.Theme.fontPixelSize * 0.5
            }

            WrapperMouseArea {
                id: closeButton

                hoverEnabled: true
                implicitWidth: Themes.Theme.fontPixelSize * 1.2
                implicitHeight: Themes.Theme.fontPixelSize * 1.2

                cursorShape: Qt.PointingHandCursor

                onPressed: () => {
                    if (rootNotif.indexAll != -1)
                        NotificationState.notifCloseByAll(rootNotif.indexAll);
                    else if (rootNotif.indexPopup != -1)
                        NotificationState.notifCloseByPopup(rootNotif.indexPopup);
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Themes.Theme.rounding * 0.5
                    color: closeButton.containsMouse ? Themes.Theme.blue : Themes.Theme.background_var


                    ModuleText {
                        label: ""
                        anchors.centerIn: parent
                        color: closeButton.containsMouse ? Themes.Theme.background_var : Themes.Theme.blue
                    }
                }
            }
            WrapperMouseArea {
                id: expandButton

                visible: bodyText.text.length > (rootNotif.n.actions.length > 1 ? 50 : 100)

                hoverEnabled: true
                implicitWidth: Themes.Theme.fontPixelSize * 1.2
                implicitHeight: Themes.Theme.fontPixelSize * 1.2

                cursorShape: Qt.PointingHandCursor

                onPressed: () => {
                  rootNotif.expanded = !rootNotif.expanded;
                  pressed = !pressed;
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Themes.Theme.rounding * 0.5
                    color: expandButton.containsMouse ? Themes.Theme.blue : Themes.Theme.background_var
      
                    ModuleText {
                        label: rootNotif.expanded ? "" : ""
                        anchors.centerIn: parent
                        color: expandButton.containsMouse ? Themes.Theme.background_var : Themes.Theme.blue
                    }
                }
            }
        }
    }
}