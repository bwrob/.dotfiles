import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "bwrob.kbd-backlight"
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  property int brightnessPct: 0
  readonly property bool backlightOn: brightnessPct > 0
  readonly property string runtimeStatePath: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/kbd-backlight-state"

  Translations {
    id: strings
    directory: Qt.resolvedUrl("i18n")
  }

  function applyStateText(rawText) {
    const parsed = parseInt((rawText || "").trim(), 10)
    if (!isNaN(parsed)) {
      root.brightnessPct = Math.max(0, Math.min(100, parsed))
    }
  }

  Component.onCompleted: statusProc.running = true

  Process {
    id: statusProc
    command: ["kbd-backlight-toggle", "status"]
    stdout: StdioCollector {
      onStreamFinished: root.applyStateText(text)
    }
  }

  FileView {
    id: stateFile
    path: root.runtimeStatePath
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.applyStateText(text())
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    dimmed: !root.backlightOn
    text: root.backlightOn ? "󰌌" : "󰌐"
    tooltipText: root.backlightOn ? strings.t("tooltip.on").arg(root.brightnessPct) : strings.t("tooltip.off")
    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton) {
        root.bar.run("kbd-backlight-toggle")
      }
    }
  }
}
