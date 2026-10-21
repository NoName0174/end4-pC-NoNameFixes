import QtQuick
import Quickshell

import qs.modules.common

Loader {
    id: root

    property bool extraCondition: true
    // Path of the panel QML file, relative to the config root, e.g.
    // "modules/ii/bar/Bar.qml". It is resolved through quickshell's qs: scheme,
    // which defers QML compilation until activation AND keeps module-internal
    // (pragma Internal) sibling types resolvable.
    property string panelSource: ""
    property int delay: 0

    readonly property string panelUrl: "qs:@/qs/" + panelSource

    active: Config.ready && root.extraCondition && root.delay <= 0 && root.panelSource.length > 0
    source: root.active ? root.panelUrl : ""

    Timer {
        interval: root.delay
        running: root.delay > 0 && Config.ready && root.extraCondition
        onTriggered: root.delay = 0
    }
}
