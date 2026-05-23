import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings ?? ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings ?? ({})

  property real    valueScale:        cfg.scale         ?? defaults.scale         ?? 1.0
  property bool    valueUseBackground: cfg.useBackground ?? defaults.useBackground ?? false
  property bool    valueUseTheme:      cfg.useThemeColor ?? defaults.useThemeColor ?? false
  property string  valueAccent:       cfg.accentColor   ?? defaults.accentColor   ?? "#f08a28"
  property string  valueHot:          cfg.hotColor      ?? defaults.hotColor      ?? "#ff5a3c"
  property string  valueBg:           cfg.bgColor       ?? defaults.bgColor       ?? "#0d0d0d"
  property int     valueUpdateMs:     cfg.updateMs      ?? defaults.updateMs      ?? 1000
  property string  valueDisks:        cfg.disksToShow   ?? defaults.disksToShow   ?? "/,/home"
  property string  valueNetIface:     cfg.netInterface  ?? defaults.netInterface  ?? ""
  property string  valueNetMode:      cfg.netMode       ?? defaults.netMode       ?? "sum"
  property int     valueCpuMax:       cfg.cpuMaxTemp    ?? defaults.cpuMaxTemp    ?? 90
  property int     valueGpuMax:       cfg.gpuMaxTemp    ?? defaults.gpuMaxTemp    ?? 85
  property int     valueSsdMax:       cfg.ssdMaxTemp    ?? defaults.ssdMaxTemp    ?? 65
  property bool    valueShowScope:    cfg.showScope     ?? defaults.showScope     ?? true
  property int     valueStarCount:    cfg.starCount     ?? defaults.starCount     ?? 30
  property string  valueGpuScript:    cfg.gpuScriptPath ?? defaults.gpuScriptPath ?? "~/.local/bin/gpuinfo.sh"

  spacing: Style.marginL

  // ── Appearance ───────────────────────────────────────────────────────
  NToggle {
    label: pluginApi?.tr("settings.useBackground.label") || "Show widget background"
    description: pluginApi?.tr("settings.useBackground.desc") || "Off = wallpaper shows through; on = solid color behind the widget."
    checked: root.valueUseBackground
    onToggled: function(c) { root.valueUseBackground = c }
  }

  NToggle {
    label: pluginApi?.tr("settings.useThemeColor.label") || "Use Noctalia theme color"
    description: pluginApi?.tr("settings.useThemeColor.desc") || "Off = the orange default below; on = recolor with your current Noctalia accent."
    checked: root.valueUseTheme
    onToggled: function(c) { root.valueUseTheme = c }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.scale.label") || "Widget scale"
    description: pluginApi?.tr("settings.scale.desc") || "Multiplier for the base 1180×600 layout. 0.5–2.0 is sensible."
    text: String(root.valueScale)
    onTextChanged: {
      var n = parseFloat(text)
      if (!isNaN(n) && n > 0.2 && n <= 4.0) root.valueScale = n
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.accent.label") || "Accent color (hex, used when theme color is off)"
    text: root.valueAccent
    onTextChanged: if (/^#?[0-9a-fA-F]{6}$/.test(text)) root.valueAccent = text.startsWith("#") ? text : "#" + text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.hot.label") || "Alert / hot color (hex)"
    text: root.valueHot
    onTextChanged: if (/^#?[0-9a-fA-F]{6}$/.test(text)) root.valueHot = text.startsWith("#") ? text : "#" + text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.bg.label") || "Background color (hex, used when background is on)"
    text: root.valueBg
    onTextChanged: if (/^#?[0-9a-fA-F]{6}$/.test(text)) root.valueBg = text.startsWith("#") ? text : "#" + text
  }

  // ── Data sources ─────────────────────────────────────────────────────
  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.updateMs.label") || "Update interval (ms)"
    description: pluginApi?.tr("settings.updateMs.desc") || "How often to re-poll /proc and /sys."
    text: String(root.valueUpdateMs)
    onTextChanged: {
      var n = parseInt(text)
      if (!isNaN(n) && n >= 200 && n <= 60000) root.valueUpdateMs = n
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.disks.label") || "Disks (comma-separated mount points)"
    text: root.valueDisks
    onTextChanged: root.valueDisks = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.iface.label") || "Network interface (blank = mode below)"
    text: root.valueNetIface
    onTextChanged: root.valueNetIface = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.netMode.label") || "Network mode (sum | auto)"
    description: pluginApi?.tr("settings.netMode.desc") || "sum = add all non-loopback interfaces; auto = pick busiest"
    text: root.valueNetMode
    onTextChanged: {
      var v = text.trim().toLowerCase()
      if (v === "sum" || v === "auto") root.valueNetMode = v
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.gpuScript.label") || "GPU info script (JSON output)"
    description: pluginApi?.tr("settings.gpuScript.desc") || "Path to a script printing JSON with a 'tooltip' field containing 'Temperature: NN°C' and optionally 'Utilization: NN%'."
    text: root.valueGpuScript
    onTextChanged: root.valueGpuScript = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.cpuMax.label") || "CPU max safe temp (°C)"
    text: String(root.valueCpuMax)
    onTextChanged: { var n = parseInt(text); if (!isNaN(n) && n > 30 && n < 200) root.valueCpuMax = n }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.gpuMax.label") || "GPU max safe temp (°C)"
    text: String(root.valueGpuMax)
    onTextChanged: { var n = parseInt(text); if (!isNaN(n) && n > 30 && n < 200) root.valueGpuMax = n }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.ssdMax.label") || "SSD max safe temp (°C)"
    text: String(root.valueSsdMax)
    onTextChanged: { var n = parseInt(text); if (!isNaN(n) && n > 30 && n < 200) root.valueSsdMax = n }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.starCount.label") || "Scope star count"
    text: String(root.valueStarCount)
    onTextChanged: { var n = parseInt(text); if (!isNaN(n) && n >= 0 && n <= 200) root.valueStarCount = n }
  }

  function saveSettings() {
    if (!pluginApi) return
    pluginApi.pluginSettings.scale         = root.valueScale
    pluginApi.pluginSettings.useBackground = root.valueUseBackground
    pluginApi.pluginSettings.useThemeColor = root.valueUseTheme
    pluginApi.pluginSettings.accentColor   = root.valueAccent
    pluginApi.pluginSettings.hotColor      = root.valueHot
    pluginApi.pluginSettings.bgColor       = root.valueBg
    pluginApi.pluginSettings.updateMs      = root.valueUpdateMs
    pluginApi.pluginSettings.disksToShow   = root.valueDisks
    pluginApi.pluginSettings.netInterface  = root.valueNetIface
    pluginApi.pluginSettings.netMode       = root.valueNetMode
    pluginApi.pluginSettings.cpuMaxTemp    = root.valueCpuMax
    pluginApi.pluginSettings.gpuMaxTemp    = root.valueGpuMax
    pluginApi.pluginSettings.ssdMaxTemp    = root.valueSsdMax
    pluginApi.pluginSettings.showScope     = root.valueShowScope
    pluginApi.pluginSettings.starCount     = root.valueStarCount
    pluginApi.pluginSettings.gpuScriptPath = root.valueGpuScript
    pluginApi.saveSettings()
  }
}
