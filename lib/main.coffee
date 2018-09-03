tinycolor = require("tinycolor2")
root = document.documentElement
themeName = 'one-afterglow-ui'

module.exports =
  activate: (state) ->
    atom.config.observe "#{themeName}.fontSize", (value) ->
      setFontSize(value)

    atom.config.observe "#{themeName}.tabSizing", (value) ->
      setTabSizing(value)

    atom.config.observe "#{themeName}.tabCloseButton", (value) ->
      setTabCloseButton(value)

    atom.config.observe "#{themeName}.hideDockButtons", (value) ->
      setHideDockButtons(value)

    atom.config.observe "#{themeName}.stickyHeaders", (value) ->
      setStickyHeaders(value)

    atom.config.observe "#{themeName}.projectColors", (value) ->
      setProjectColors(value)

    # DEPRECATED: This can be removed at some point (added in Atom 1.17/1.18ish)
    # It removes `layoutMode`
    if atom.config.get("#{themeName}.layoutMode")
      atom.config.unset("#{themeName}.layoutMode")

  deactivate: ->
    unsetFontSize()
    unsetTabSizing()
    unsetTabCloseButton()
    unsetHideDockButtons()
    unsetStickyHeaders()
    unsetProjectColors()


# Font Size -----------------------

setFontSize = (currentFontSize) ->
  root.style.fontSize = "#{currentFontSize}px"

unsetFontSize = ->
  root.style.fontSize = ''


# Tab Sizing -----------------------

setTabSizing = (tabSizing) ->
  root.setAttribute("theme-#{themeName}-tabsizing", tabSizing.toLowerCase())

unsetTabSizing = ->
  root.removeAttribute("theme-#{themeName}-tabsizing")


# Tab Close Button -----------------------

setTabCloseButton = (tabCloseButton) ->
  if tabCloseButton is 'Left'
    root.setAttribute("theme-#{themeName}-tab-close-button", 'left')
  else
    unsetTabCloseButton()

unsetTabCloseButton = ->
  root.removeAttribute("theme-#{themeName}-tab-close-button")


# Dock Buttons -----------------------

setHideDockButtons = (hideDockButtons) ->
  if hideDockButtons
    root.setAttribute("theme-#{themeName}-dock-buttons", 'hidden')
  else
    unsetHideDockButtons()

unsetHideDockButtons = ->
  root.removeAttribute("theme-#{themeName}-dock-buttons")


# Sticky Headers -----------------------

setStickyHeaders = (stickyHeaders) ->
  if stickyHeaders
    root.setAttribute("theme-#{themeName}-sticky-headers", 'sticky')
  else
    unsetStickyHeaders()

unsetStickyHeaders = ->
  root.removeAttribute("theme-#{themeName}-sticky-headers")


# Project Colors -----------------------

setProjectColors = (projectColors) ->
  if projectColors
    # get project name (root project folder name)
    project = atom.project.getPaths().map((path) -> path.split('/')[path.split('/').length - 1])[0]

    for projectColor in projectColors.split(";")
      if projectColor.split(":")[0] is project
        color = projectColor.split(":")[1] # color from configuration
        darkened = tinycolor(color).darken(30).toString() # darkened color for title bar

        # tree-view project title
        document.querySelector("atom-dock .tab-bar .tab").setAttribute("style", "background-color:#{color}; border-left: 0; border-top: 0; border-right: 0; border-bottom: 1px solid #{darkened}")
        document.querySelector("atom-dock .tab-bar .tab .title").setAttribute("style", "font-variant:small-caps; color:#{textColorForBg(color)}")
        document.querySelector("atom-dock .tab-bar .tab .title").innerHTML = project

        # atom window title bar
        document.querySelector("atom-panel.header").setAttribute("style", "border-bottom:0;")
        document.querySelector("atom-panel.header .title-bar").setAttribute("style", "background-color:#{darkened}; border-bottom: 1px solid #{color}; color:#{textColorForBg(darkened)}")
  else
    unsetProjectColors()

unsetProjectColors = ->
  root.removeAttribute("data-projectcolor")

textColorForBg = (color) ->
  if tinycolor(color).isLight()
    tinycolor(color).darken(60).desaturate(5).toString()
  else
    tinycolor(color).lighten(60).saturate(5).toString()
