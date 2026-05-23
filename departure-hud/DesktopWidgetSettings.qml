import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null
  property var widgetSettings: null

  readonly property var cfg: pluginApi?.pluginSettings ?? ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings ?? ({})
  readonly property var widget: widgetSettings?.data ?? ({})

  property real   valueScale:          widget.scale         ?? cfg.scale         ?? defaults.scale         ?? 1.0
  property bool   valueUseBackground:  widget.useBackground ?? cfg.useBackground ?? defaults.useBackground ?? false
  property bool   valueUseTheme:       widget.useThemeColor ?? cfg.useThemeColor ?? defaults.useThemeColor ?? false
  property string valueAccent:         widget.accentColor   ?? cfg.accentColor   ?? defaults.accentColor   ?? "#f08a28"
  property string valueBg:             widget.bgColor       ?? cfg.bgColor       ?? defaults.bgColor       ?? "#0d0d0d"

  spacing: Style.marginM

  NToggle {
    label: pluginApi?.tr("widgetSettings.useBackground.label") || "This widget — show background"
    checked: root.valueUseBackground
    onToggled: function(c) { root.valueUseBackground = c; root.saveSettings() }
  }

  NToggle {
    label: pluginApi?.tr("widgetSettings.useThemeColor.label") || "This widget — use Noctalia theme color"
    checked: root.valueUseTheme
    onToggled: function(c) { root.valueUseTheme = c; root.saveSettings() }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("widgetSettings.scale.label") || "This widget — scale"
    text: String(root.valueScale)
    onTextChanged: {
      var n = parseFloat(text)
      if (!isNaN(n) && n > 0.2 && n <= 4.0) { root.valueScale = n; root.saveSettings() }
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("widgetSettings.accent.label") || "This widget — accent color (hex)"
    text: root.valueAccent
    onTextChanged: {
      if (/^#?[0-9a-fA-F]{6}$/.test(text)) {
        root.valueAccent = text.startsWith("#") ? text : "#" + text
        root.saveSettings()
      }
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("widgetSettings.bg.label") || "This widget — background color (hex)"
    text: root.valueBg
    onTextChanged: {
      if (/^#?[0-9a-fA-F]{6}$/.test(text)) {
        root.valueBg = text.startsWith("#") ? text : "#" + text
        root.saveSettings()
      }
    }
  }

  function saveSettings() {
    if (!widgetSettings) return
    widgetSettings.data.scale         = root.valueScale
    widgetSettings.data.useBackground = root.valueUseBackground
    widgetSettings.data.useThemeColor = root.valueUseTheme
    widgetSettings.data.accentColor   = root.valueAccent
    widgetSettings.data.bgColor       = root.valueBg
    widgetSettings.save()
  }
}
