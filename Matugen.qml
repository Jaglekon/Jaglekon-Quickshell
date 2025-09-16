pragma Singleton

        import QtQuick 2.0

        QtObject {
          property color background: "{{colors.surface.default.hex}}"
          property color background_var: "{{colors.surface_container_low.default.hex}}"
          property color selection_background: "{{colors.on_surface_variant.default.hex}}"
          property color blue: "{{colors.primary.default.hex}}"
          property color border: "{{colors.primary_container.default.hex}}"
          property color red: "{{colors.error.default.hex}}"
          property color purple: "{{colors.tertiary.default.hex}}"
          property color purple_border: "{{colors.tertiary.default.hex}}"

          property string wallpaper: "{{image}}"
          property string logo: "/home/jag/.config/quickshell/test/Assets/logo.svg"
          
          property string fontFamily: "Source Sans Pro"
          property int fontPixelSize: 13
          property int fontWeight: Font.DemiBold

          property int gapOut: 15
          property int gapIn: 5
          property int rounding: 8
          property int borderSize: 2
        }
