import QtQuick
import "../Themes"

Rectangle {
    id: bar
    default property alias content: column.data
    color: Theme.background_var
    radius: Theme.rounding

    Behavior on width {
      NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
    }

    height: column.implicitHeight
    width: column.implicitWidth

    Column {
      id: column
      spacing: 0
    }
}