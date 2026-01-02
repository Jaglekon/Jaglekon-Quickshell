pragma Singleton

        import QtQuick 2.0

        QtObject {
          property color background: "#19120c"
          property color background_var: "#312822"
          property color selection_background: "#ffdcc2"
          property color blue: "#ffb77c"
          property color border: "#6c3a06"
          property color red: "#93000a"
          property color purple: "#c4cb97"
          property color purple_border: "#c4cb97"

          property string wallpaper: "/home/jag/Pictures/wallpapers/wp10.jpg"
          property string logo: "/home/jag/.config/quickshell/main/Assets/logo.svg"
          property string logo_back: "/home/jag/.config/quickshell/main/Assets/logo_back.svg"

          property string user: "jag"

          property string fontFamily: "Source Sans Pro"
          property int fontPixelSize: 13
          property int fontWeight: Font.DemiBold

          property int gapOut: 15
          property int gapIn: 5
          property int rounding: 8
          property int borderSize: 2
          property real opacity: 0.8
        }
