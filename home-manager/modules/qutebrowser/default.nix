{ config, pkgs, ... }:
let
  # from httpa://github.com/dracula/qutebrowser
  palette = {
    background = "#282a36";
    background-alt = "#282a36";
    background-attention = "#181920";
    border = "#282a36";
    current-line = "#44475a";
    selection = "#44475a";
    foreground = "#f8f8f2";
    foreground-alt = "#e0e0e0";
    foreground-attention = "#ffffff";
    comment = "#6272a4";
    cyan = "#8be9fd";
    green = "#50fa7b";
    orange = "#ffb86c";
    pink = "#ff79c6";
    purple = "#bd93f9";
    red = "#ff5555";
    yellow = "#f1fa8c";
  };
  spacing = 5;
  padding = {
    top = spacing;
    right = spacing;
    left = spacing;
    bottom = spacing;
  };
in
{
  programs.qutebrowser = {
    enable = true;
    settings = {
      ## Background color of the completion widget category headers.
      colors.completion.category.bg = palette.background;

      ## Bottom border color of the completion widget category headers.
      colors.completion.category.border.bottom = palette.border;

      ## Top border color of the completion widget category headers.
      colors.completion.category.border.top = palette.border;

      ## Foreground color of completion widget category headers.
      colors.completion.category.fg = palette.foreground;

      ## Background color of the completion widget for even rows.
      colors.completion.even.bg = palette.background;

      ## Background color of the completion widget for odd rows.
      colors.completion.odd.bg = palette.background-alt;

      ## Text color of the completion widget.
      colors.completion.fg = palette.foreground;

      ## Background color of the selected completion item.
      colors.completion.item.selected.bg = palette.selection;

      ## Bottom border color of the selected completion item.
      colors.completion.item.selected.border.bottom = palette.selection;

      ## Top border color of the completion widget category headers.
      colors.completion.item.selected.border.top = palette.selection;

      ## Foreground color of the selected completion item.
      colors.completion.item.selected.fg = palette.foreground;

      ## Foreground color of the matched text in the completion.
      colors.completion.match.fg = palette.orange;

      ## Color of the scrollbar in completion view
      colors.completion.scrollbar.bg = palette.background;

      ## Color of the scrollbar handle in completion view.
      colors.completion.scrollbar.fg = palette.foreground;

      ## Background color for the download bar.
      colors.downloads.bar.bg = palette.background;

      ## Background color for downloads with errors.
      colors.downloads.error.bg = palette.background;

      ## Foreground color for downloads with errors.
      colors.downloads.error.fg = palette.red;

      ## Color gradient stop for download backgrounds.
      colors.downloads.stop.bg = palette.background;

      ## Color gradient interpolation system for download backgrounds.
      ## Type: ColorSystem
      ## Valid values:
      ##   - rgb: Interpolate in the RGB color system.
      ##   - hsv: Interpolate in the HSV color system.
      ##   - hsl: Interpolate in the HSL color system.
      ##   - none: Don't show a gradient.
      colors.downloads.system.bg = "none";

      ## Background color for hints. Note that you can use a `rgba(...)` value
      ## for transparency.
      colors.hints.bg = palette.background;

      ## Font color for hints.
      colors.hints.fg = palette.purple;

      ## Hints
      hints.border = "1 px solid " + palette.background-alt;

      ## Font color for the matched part of hints.
      colors.hints.match.fg = palette.foreground-alt;

      ## Background color of the keyhint widget.
      colors.keyhint.bg = palette.background;

      ## Text color for the keyhint widget.
      colors.keyhint.fg = palette.purple;

      ## Highlight color for keys to complete the current keychain.
      colors.keyhint.suffix.fg = palette.selection;

      ## Background color of an error message.
      colors.messages.error.bg = palette.background;

      ## Border color of an error message.
      colors.messages.error.border = palette.background-alt;

      ## Foreground color of an error message.
      colors.messages.error.fg = palette.red;

      ## Background color of an info message.
      colors.messages.info.bg = palette.background;

      ## Border color of an info message.
      colors.messages.info.border = palette.background-alt;

      ## Foreground color an info message.
      colors.messages.info.fg = palette.comment;

      ## Background color of a warning message.
      colors.messages.warning.bg = palette.background;

      ## Border color of a warning message.
      colors.messages.warning.border = palette.background-alt;

      ## Foreground color a warning message.
      colors.messages.warning.fg = palette.red;

      ## Background color for prompts.
      colors.prompts.bg = palette.background;

      # ## Border used around UI elements in prompts.
      colors.prompts.border = "1 px solid " + palette.background-alt;

      ## Foreground color for prompts.
      colors.prompts.fg = palette.cyan;

      ## Background color for the selected item in filename prompts.
      colors.prompts.selected.bg = palette.selection;

      ## Background color of the statusbar in caret mode.
      colors.statusbar.caret.bg = palette.background;

      ## Foreground color of the statusbar in caret mode.
      colors.statusbar.caret.fg = palette.orange;

      ## Background color of the statusbar in caret mode with a selection.
      colors.statusbar.caret.selection.bg = palette.background;

      ## Foreground color of the statusbar in caret mode with a selection.
      colors.statusbar.caret.selection.fg = palette.orange;

      ## Background color of the statusbar in command mode.
      colors.statusbar.command.bg = palette.background;

      ## Foreground color of the statusbar in command mode.
      colors.statusbar.command.fg = palette.pink;

      ## Background color of the statusbar in private browsing + command mode.
      colors.statusbar.command.private.bg = palette.background;

      ## Foreground color of the statusbar in private browsing + command mode.
      colors.statusbar.command.private.fg = palette.foreground-alt;

      ## Background color of the statusbar in insert mode.
      colors.statusbar.insert.bg = palette.background-attention;

      ## Foreground color of the statusbar in insert mode.
      colors.statusbar.insert.fg = palette.foreground-attention;

      ## Background color of the statusbar.
      colors.statusbar.normal.bg = palette.background;

      ## Foreground color of the statusbar.
      colors.statusbar.normal.fg = palette.foreground;

      ## Background color of the statusbar in passthrough mode.
      colors.statusbar.passthrough.bg = palette.background;

      ## Foreground color of the statusbar in passthrough mode.
      colors.statusbar.passthrough.fg = palette.orange;

      ## Background color of the statusbar in private browsing mode.
      colors.statusbar.private.bg = palette.background-alt;

      ## Foreground color of the statusbar in private browsing mode.
      colors.statusbar.private.fg = palette.foreground-alt;

      ## Background color of the progress bar.
      colors.statusbar.progress.bg = palette.background;

      ## Foreground color of the URL in the statusbar on error.
      colors.statusbar.url.error.fg = palette.red;

      ## Default foreground color of the URL in the statusbar.
      colors.statusbar.url.fg = palette.foreground;

      ## Foreground color of the URL in the statusbar for hovered links.
      colors.statusbar.url.hover.fg = palette.cyan;

      ## Foreground color of the URL in the statusbar on successful load
      colors.statusbar.url.success.http.fg = palette.green;

      ## Foreground color of the URL in the statusbar on successful load
      colors.statusbar.url.success.https.fg = palette.green;

      ## Foreground color of the URL in the statusbar when there's a warning.
      colors.statusbar.url.warn.fg = palette.yellow;

      ## Background color of the tab bar.
      ## Type: QtColor
      colors.tabs.bar.bg = palette.selection;

      ## Background color of unselected even tabs.
      ## Type: QtColor
      colors.tabs.even.bg = palette.selection;

      ## Foreground color of unselected even tabs.
      ## Type: QtColor
      colors.tabs.even.fg = palette.foreground;

      ## Color for the tab indicator on errors.
      ## Type: QtColor
      colors.tabs.indicator.error = palette.red;

      ## Color gradient start for the tab indicator.
      ## Type: QtColor
      colors.tabs.indicator.start = palette.orange;

      ## Color gradient end for the tab indicator.
      ## Type: QtColor
      colors.tabs.indicator.stop = palette.green;

      ## Color gradient interpolation system for the tab indicator.
      ## Type: ColorSystem
      ## Valid values:
      ##   - rgb: Interpolate in the RGB color system.
      ##   - hsv: Interpolate in the HSV color system.
      ##   - hsl: Interpolate in the HSL color system.
      ##   - none: Don't show a gradient.
      colors.tabs.indicator.system = "none";

      ## Background color of unselected odd tabs.
      ## Type: QtColor
      colors.tabs.odd.bg = palette.selection;

      ## Foreground color of unselected odd tabs.
      ## Type: QtColor
      colors.tabs.odd.fg = palette.foreground;

      # ## Background color of selected even tabs.
      # ## Type: QtColor
      colors.tabs.selected.even.bg = palette.background;

      # ## Foreground color of selected even tabs.
      # ## Type: QtColor
      colors.tabs.selected.even.fg = palette.foreground;

      # ## Background color of selected odd tabs.
      # ## Type: QtColor
      colors.tabs.selected.odd.bg = palette.background;

      # ## Foreground color of selected odd tabs.
      # ## Type: QtColor
      colors.tabs.selected.odd.fg = palette.foreground;

      tabs.indicator.width = 1;
      tabs.favicons.scale = 1;

      tabs.show = "multiple";
      tabs.title.format = "{audio}{private} {current_title}";
      tabs.background = true;

      colors.webpage.prefers_color_scheme_dark = true;
    };
    extraConfig = ''
      c.tabs.padding['top'] = ${toString padding.top}
      c.tabs.padding['bottom'] = ${toString padding.bottom}
      c.tabs.padding['right'] = ${toString padding.right}
      c.tabs.padding['left'] = ${toString padding.left}
      c.statusbar.padding['top'] = ${toString padding.top}
      c.statusbar.padding['bottom'] = ${toString padding.bottom}
      c.statusbar.padding['right'] = ${toString padding.right}
      c.statusbar.padding['left'] = ${toString padding.left}
    '';
  };
}
