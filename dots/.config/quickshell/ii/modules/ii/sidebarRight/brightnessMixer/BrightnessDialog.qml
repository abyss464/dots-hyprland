pragma ComponentBehavior: Bound
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

WindowDialog {
    id: root
    // Adapt height to monitor count (per-monitor brightness rows + gamma section)
    backgroundHeight: 360 + Math.max(1, Brightness.monitors.length) * 48

    WindowDialogTitle {
        text: Translation.tr("Brightness")
    }

    WindowDialogSeparator {
        Layout.topMargin: -22
        Layout.leftMargin: 0
        Layout.rightMargin: 0
    }

    BrightnessDialogContent {}

    WindowDialogButtonRow {
        Item {
            Layout.fillWidth: true
        }

        DialogButton {
            buttonText: Translation.tr("Done")
            onClicked: root.dismiss()
        }
    }
}
