pragma Singleton

        import QtQuick 2.0

        QtObject {
          property color background: "#1a110f"
          property color background_var: "#322825"
          property color selection_background: "#ffdad2"
          property color blue: "#ffb4a4"
          property color border: "#733426"
          property color red: "#93000a"
          property color purple: "#dbc58c"
          property color purple_border: "#dbc58c"

          property string wallpaper: "/home/jag/Pictures/wallpapers/wp24.png"
          property string logo: "/home/jag/.config/quickshell/test/quickshell/Assets/logo.svg"
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
