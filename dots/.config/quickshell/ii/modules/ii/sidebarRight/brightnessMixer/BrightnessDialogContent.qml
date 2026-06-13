import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

ColumnLayout {
    id: root
    // Brightness.monitors is a typed list<BrightnessMonitor> (QQmlListReference);
    // copy into a plain JS array so it can be used as a Repeater model.
    readonly property var monitorList: {
        const out = [];
        const m = Brightness.monitors;
        for (let i = 0; i < (m?.length ?? 0); i++)
            out.push(m[i]);
        return out;
    }
    spacing: 8

    // Per-monitor hardware brightness
    StyledText {
        Layout.fillWidth: true
        Layout.topMargin: 4
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.colors.colSubtext
        text: Translation.tr("Monitor brightness")
    }

    StyledText {
        Layout.fillWidth: true
        visible: root.monitorList.length === 0
        font.pixelSize: Appearance.font.pixelSize.small
        color: Appearance.colors.colSubtext
        text: Translation.tr("No monitors detected")
    }

    Repeater {
        model: root.monitorList
        delegate: BrightnessMixerEntry {
            required property var modelData
            monitor: modelData
            Layout.fillWidth: true
        }
    }

    // Global gamma (all screens) — hyprsunset only supports a single global gamma
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 6
        implicitHeight: 1
        color: Appearance.colors.colOutlineVariant
    }

    StyledText {
        Layout.fillWidth: true
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.colors.colSubtext
        text: Translation.tr("Gamma (all screens)")
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        MaterialSymbol {
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "exposure"
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
                text: `${Hyprsunset.gamma}%`
            }

            StyledSlider {
                Layout.fillWidth: true
                readonly property real lower: Hyprsunset.gammaLowerLimit
                value: (Hyprsunset.gamma - lower) / (100 - lower)
                onMoved: Hyprsunset.setGamma(lower + value * (100 - lower))
                configuration: StyledSlider.Configuration.S
            }
        }
    }
}
