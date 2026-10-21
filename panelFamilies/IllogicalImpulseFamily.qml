import QtQuick
import Quickshell

import qs.modules.common
import qs.modules.ii.background
import qs.modules.ii.bar
import qs.modules.ii.dock
import qs.modules.ii.equalizer
import qs.modules.ii.lock
import qs.modules.ii.mediaControls
import qs.modules.ii.notificationPopup
import qs.modules.ii.onScreenDisplay
import qs.modules.ii.onScreenKeyboard
import qs.modules.ii.overview
import qs.modules.ii.polkit
import qs.modules.ii.settings
import qs.modules.ii.regionSelector
import qs.modules.ii.screenCorners
import qs.modules.ii.screenTranslator
import qs.modules.ii.sessionScreen
import qs.modules.ii.sidebarLeft
import qs.modules.ii.sidebarRight
import qs.modules.ii.overlay
import qs.modules.ii.verticalBar
import qs.modules.ii.wallpaperSelector
import qs.modules.ii.desktopMenu
import qs.modules.ii.dropover
import qs.modules.ii.frame

Scope {
    // Essential: visible immediately or needed for basic operation
    PanelLoader { delay: 0; extraCondition: !Config.options.bar.vertical; panelSource: "panelFamilies/loaders/BarLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/BackgroundLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/LockLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/PolkitLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/SessionScreenLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/NotificationPopupLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/ScreenCornersLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/OnScreenDisplayLoader.qml" }
    PanelLoader { delay: 0; panelSource: "panelFamilies/loaders/MediaControlsLoader.qml" }

    // Wave 1: plausibly touched in the first seconds
    PanelLoader { delay: 1000; extraCondition: Config.options.dock.enable; panelSource: "panelFamilies/loaders/DockLoader.qml" }
    PanelLoader { delay: 1000; panelSource: "panelFamilies/loaders/OnScreenKeyboardLoader.qml" }
    PanelLoader { delay: 1300; panelSource: "panelFamilies/loaders/SidebarLeftLoader.qml" }
    PanelLoader { delay: 1300; panelSource: "panelFamilies/loaders/SidebarRightLoader.qml" }
    PanelLoader { delay: 1600; panelSource: "panelFamilies/loaders/EqualizerPopupLoader.qml" }
    PanelLoader { delay: 1600; panelSource: "panelFamilies/loaders/RegionSelectorLoader.qml" }

    // Wave 2: rarely needed / heavyweight
    PanelLoader { delay: 3200; panelSource: "panelFamilies/loaders/ScreenTranslatorLoader.qml" }
    PanelLoader { delay: 3200; panelSource: "panelFamilies/loaders/OverlayLoader.qml" }
    PanelLoader { delay: 3500; panelSource: "panelFamilies/loaders/OverviewLoader.qml" }
    PanelLoader { delay: 3500; panelSource: "panelFamilies/loaders/WallpaperSelectorLoader.qml" }
    PanelLoader { delay: 3800; panelSource: "panelFamilies/loaders/SettingsLoader.qml" }
    PanelLoader { delay: 4100; panelSource: "panelFamilies/loaders/DesktopMenuLoader.qml" }
    PanelLoader { delay: 4100; panelSource: "panelFamilies/loaders/DropShelfPanelLoader.qml" }
    PanelLoader { delay: 4300; panelSource: "panelFamilies/loaders/NiriBackdropLoader.qml" }
    PanelLoader { delay: 4300; extraCondition: Config.options.bar.vertical; panelSource: "panelFamilies/loaders/VerticalBarLoader.qml" }
    PanelLoader { delay: 4600; panelSource: "panelFamilies/loaders/ScreenFrameLoader.qml" }
}
