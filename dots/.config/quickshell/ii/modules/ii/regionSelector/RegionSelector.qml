pragma ComponentBehavior: Bound
import qs
import qs.modules.common
import qs.modules.common.utils
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: root

    function dismiss() {
        GlobalStates.regionSelectorOpen = false
    }

    property var action: RegionSelection.SnipAction.Copy
    property var selectionMode: RegionSelection.SelectionMode.RectCorners

    // ===== Cross-screen support =====
    // Whole-layout frozen capture, used when a selection spans multiple monitors.
    // Coordinate model (verified): pixel = (logical - layoutOrigin) * captureScale
    readonly property var allMonitors: Quickshell.screens.map(s => Hyprland.monitorFor(s))
    readonly property real layoutOriginX: allMonitors.length ? Math.min(...allMonitors.map(m => m.x)) : 0
    readonly property real layoutOriginY: allMonitors.length ? Math.min(...allMonitors.map(m => m.y)) : 0
    readonly property real captureScale: allMonitors.length ? Math.max(...allMonitors.map(m => m.scale)) : 1
    // Dim-overlay border must be big enough to cover any monitor even when the
    // selection sits on a different one (the overlay is a hole-punching border).
    readonly property real overlayExtent: {
        let span = 0;
        for (const m of allMonitors) {
            span = Math.max(span, Math.abs(m.x) + m.width, Math.abs(m.y) + m.height);
        }
        return span * 2 + 1000;
    }
    property string fullLayoutPath: `${Directories.screenshotTemp}/image-fullLayout`
    property bool fullLayoutReady: false

    // Live (global, logical) selection rectangle, so every monitor can draw its
    // portion of a selection that crosses screen boundaries.
    property bool liveActive: false
    property real liveGX: 0
    property real liveGY: 0
    property real liveGW: 0
    property real liveGH: 0

    Process {
        id: fullLayoutProc
        command: ["bash", "-c", `mkdir -p '${StringUtils.shellSingleQuoteEscape(Directories.screenshotTemp)}' && grim '${StringUtils.shellSingleQuoteEscape(root.fullLayoutPath)}'`]
        onExited: root.fullLayoutReady = true
    }
    Connections {
        target: GlobalStates
        function onRegionSelectorOpenChanged() {
            if (GlobalStates.regionSelectorOpen) {
                root.fullLayoutReady = false;
                root.liveActive = false;
                fullLayoutProc.running = true;
            }
        }
    }

    function crossScreenAction(snipAction) {
        switch (snipAction) {
            case RegionSelection.SnipAction.Copy: return ScreenshotAction.Action.Copy;
            case RegionSelection.SnipAction.Edit: return ScreenshotAction.Action.Edit;
            case RegionSelection.SnipAction.Search: return ScreenshotAction.Action.Search;
            case RegionSelection.SnipAction.CharRecognition: return ScreenshotAction.Action.CharRecognition;
            default: return ScreenshotAction.Action.Copy;
        }
    }
    // gx, gy, gw, gh are in global logical coordinates
    function commitCrossScreen(gx, gy, gw, gh, snipAction) {
        if (gw <= 0 || gh <= 0) return;
        const sx = (gx - root.layoutOriginX) * root.captureScale;
        const sy = (gy - root.layoutOriginY) * root.captureScale;
        const sw = gw * root.captureScale;
        const sh = gh * root.captureScale;
        const saveDir = Config.options.screenSnip.savePath !== "" ? Config.options.screenSnip.savePath : "";
        const command = ScreenshotAction.getCommand(sx, sy, sw, sh, root.fullLayoutPath, root.crossScreenAction(snipAction), saveDir);
        Quickshell.execDetached(command);
    }

    Variants {
        model: Quickshell.screens
        delegate: Loader {
            id: regionSelectorLoader
            required property var modelData
            active: GlobalStates.regionSelectorOpen

            sourceComponent: RegionSelection {
                screen: regionSelectorLoader.modelData
                selector: root
                onDismiss: root.dismiss()
                action: root.action
                selectionMode: root.selectionMode
            }
        }
    }

    function screenshot() {
        root.action = RegionSelection.SnipAction.Copy
        root.selectionMode = RegionSelection.SelectionMode.RectCorners
        GlobalStates.regionSelectorOpen = true
    }

    function search() {
        root.action = RegionSelection.SnipAction.Search
        if (Config.options.search.imageSearch.useCircleSelection) {
            root.selectionMode = RegionSelection.SelectionMode.Circle
        } else {
            root.selectionMode = RegionSelection.SelectionMode.RectCorners
        }
        GlobalStates.regionSelectorOpen = true
    }

    function ocr() {
        root.action = RegionSelection.SnipAction.CharRecognition
        root.selectionMode = RegionSelection.SelectionMode.RectCorners
        GlobalStates.regionSelectorOpen = true
    }

    function record() {
        root.action = RegionSelection.SnipAction.Record
        root.selectionMode = RegionSelection.SelectionMode.RectCorners
        // If already open then re-trigger to stop recording
        if (GlobalStates.regionSelectorOpen) GlobalStates.regionSelectorOpen = false
        GlobalStates.regionSelectorOpen = true
    }

    function recordWithSound() {
        root.action = RegionSelection.SnipAction.RecordWithSound
        root.selectionMode = RegionSelection.SelectionMode.RectCorners
        // If already open then re-trigger to stop recording
        if (GlobalStates.regionSelectorOpen) GlobalStates.regionSelectorOpen = false
        GlobalStates.regionSelectorOpen = true
    }

    IpcHandler {
        target: "region"

        function screenshot() {
            root.screenshot()
        }
        function search() {
            root.search()
        }
        function ocr() {
            root.ocr()
        }
        function record() {
            root.record()
        }
        function recordWithSound() {
            root.recordWithSound()
        }
    }

    GlobalShortcut {
        name: "regionScreenshot"
        description: "Takes a screenshot of the selected region"
        onPressed: root.screenshot()
    }
    GlobalShortcut {
        name: "regionSearch"
        description: "Searches the selected region"
        onPressed: root.search()
    }
    GlobalShortcut {
        name: "regionOcr"
        description: "Recognizes text in the selected region"
        onPressed: root.ocr()
    }
    GlobalShortcut {
        name: "regionRecord"
        description: "Records the selected region"
        onPressed: root.record()
    }
    GlobalShortcut {
        name: "regionRecordWithSound"
        description: "Records the selected region with sound"
        onPressed: root.recordWithSound()
    }
}
