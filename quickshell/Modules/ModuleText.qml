import QtQuick
import "../Themes"

Text {
    id: moduleText
    property string label: ""
    property bool hovered: false
    text: label
    font.family: Theme.fontFamily
    renderType: Text.NativeRendering
    font.pixelSize: Theme.fontPixelSize
    font.weight: Theme.fontWeight
    color: hovered ? Theme.background_var : Theme.blue
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
}