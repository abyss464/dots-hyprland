import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    required property var monitor // Brightness service BrightnessMonitor
    readonly property string screenName: monitor?.screen?.name ?? ""

    implicitHeight: rowLayout.implicitHeight

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 6

        MaterialSymbol {
            property real size: 36
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: size
            Layout.preferredHeight: size
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "monitor"
            iconSize: 24
            color: Appearance.colors.colOnLayer1
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: -4

            StyledText {
                Layout.fillWidth: true
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSubtext
                elide: Text.ElideRight
                text: `${root.screenName} • ${Math.round((root.monitor?.brightness ?? 0) * 100)}%`
            }

            StyledSlider {
                id: slider
                value: root.monitor?.brightness ?? 0
                onMoved: root.monitor?.setBrightness(value)
                configuration: StyledSlider.Configuration.S
            }
        }
    }
}
