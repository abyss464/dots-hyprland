import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("Brightness")
    statusText: {
        const mons = Brightness.monitors;
        if (!mons || mons.length === 0)
            return "";
        let sum = 0;
        for (let i = 0; i < mons.length; i++)
            sum += (mons[i]?.brightness ?? 0);
        return `${Math.round(sum / mons.length * 100)}%`;
    }

    toggled: false
    icon: "brightness_medium"
    hasMenu: true

    // The Android delegate overrides mainAction to open the per-monitor panel,
    // so this is just a required-property placeholder.
    mainAction: () => {}

    tooltipText: Translation.tr("Brightness | Click to adjust per monitor")
}
