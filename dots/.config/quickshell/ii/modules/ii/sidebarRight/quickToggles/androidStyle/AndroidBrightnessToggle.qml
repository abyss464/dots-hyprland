import qs.modules.common
import qs.modules.common.models.quickToggles
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell

AndroidQuickToggleButton {
    id: button
    toggleModel: BrightnessToggle {}
    // Brightness has no on/off state, so a normal left-click opens the panel too.
    mainAction: () => button.openMenu()
}
