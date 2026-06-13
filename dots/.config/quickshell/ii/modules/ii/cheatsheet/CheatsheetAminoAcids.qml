import "amino_acids.js" as AA
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import QtQuick

Item {
    id: root
    readonly property var groups: AA.aminoAcids
    readonly property var catNames: AA.categoryNames
    readonly property var catColors: AA.categoryColors
    property real spacing: 6
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    StyledFlickable {
        id: flickable
        clip: true
        anchors.fill: parent
        anchors.margins: 10
        contentHeight: mainLayout.implicitHeight
        contentWidth: mainLayout.implicitWidth

        Column {
            id: mainLayout
            anchors.centerIn: parent
            spacing: root.spacing * 3

            Repeater {
                model: root.groups

                delegate: Column {
                    id: groupColumn
                    required property var modelData
                    required property int index
                    spacing: root.spacing

                    StyledText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Appearance.font.pixelSize.normal
                        font.weight: Font.Bold
                        color: root.catColors[modelData[0].category] || Appearance.colors.colSecondary
                        text: root.catNames[modelData[0].category]
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: root.spacing

                        Repeater {
                            model: groupColumn.modelData
                            delegate: AATile {
                                required property var modelData
                                aa: modelData
                            }
                        }
                    }
                }
            }
        }
    }

    component AATile: RippleButton {
        id: tile
        required property var aa
        implicitWidth: 70
        implicitHeight: 70
        colBackground: Appearance.colors.colLayer2
        buttonRadius: Appearance.rounding.small

        // 3-letter code (top-right, like atomic weight in ElementTile)
        Rectangle {
            anchors { top: parent.top; right: parent.right; margins: 4 }
            color: ColorUtils.transparentize(Appearance.colors.colLayer2)
            radius: Appearance.rounding.full
            implicitWidth: Math.max(22, code3Label.implicitWidth + 4)
            implicitHeight: Math.max(22, code3Label.implicitHeight + 4)
            width: height

            StyledText {
                id: code3Label
                anchors.centerIn: parent
                font.pixelSize: Appearance.font.pixelSize.smallest
                color: Appearance.colors.colOnLayer2
                text: tile.aa.code3
            }
        }

        // 1-letter code (center, large & colored, like element symbol)
        StyledText {
            anchors.centerIn: parent
            font.pixelSize: Appearance.font.pixelSize.huge
            font.weight: Font.Bold
            color: root.catColors[tile.aa.category] || Appearance.colors.colSecondary
            text: tile.aa.code1
        }

        // Full name (bottom, like element name)
        StyledText {
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 4 }
            font.pixelSize: Appearance.font.pixelSize.smallest
            color: Appearance.colors.colOnLayer2
            text: tile.aa.name
        }
    }
}
