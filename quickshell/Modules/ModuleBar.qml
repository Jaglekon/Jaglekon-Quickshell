import QtQuick
import "../Themes"

Rectangle {
    id: bar
    default property alias content: row.data
    anchors.verticalCenter: parent.verticalCenter
    color: Theme.background_var
    radius: Theme.rounding


    Behavior on width {
      NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
    }

    height: row.implicitHeight
    width: row.implicitWidth

    Row {
        id: row
        spacing: 0
    }
}