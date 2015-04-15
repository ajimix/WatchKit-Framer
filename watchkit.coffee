exports.clickAnimationCurve = "spring(500,30,0)"
statusBarVisible = false
statusBarHeight = 40

class exports.StatusBar extends Layer
	constructor: (options = {}) ->
		backArrowLayerWidth = 9
		timeLayerWidth = 80
		defaultFont =
			fontFamily: "SanFranciscoText-Regular"
			fontSize: "32px"
			color: "#9BA0AA"
			lineHeight: "38px"

		options.height ?= statusBarHeight
		options.width ?= Screen.width
		options.backgroundColor ?= "transparent"

		super options

		statusBarVisible = true

		titleLayer = new Layer
			html: if options.title? then options.title else ""
			width: Screen.width -
				(if options.time? then timeLayerWidth else 0) -
				(if options.back? then backArrowLayerWidth else 0) - 5
			height: statusBarHeight
			superLayer: @

		titleLayer.style = _.extend {}, defaultFont,
			backgroundColor: "transparent"
			color: "#FF9501"

		if options.back
			backArrowLayer = new Layer
				x:0, y:13, width:backArrowLayerWidth, height:17, image:"images/backArrow.png", superLayer: @
			titleLayer.x = 15

		if options.time
			timeWidth = 80
			timeLayer = new Layer x: Screen.width - timeWidth, html: "10:09", width: timeWidth, height: statusBarHeight, superLayer: @
			timeLayer.style = _.extend {}, defaultFont,
				backgroundColor: "transparent"
				color: "#9BA0AA"

class exports.Button extends Layer
	constructor: (title, options = {}) ->
		defaultFont =
			fontFamily: "SanFranciscoText-Regular"
			fontSize: "30px"
			color: "#FFFFFF"
			lineHeight: "35px"

		options.width ?= Screen.width
		options.height ?= 75
		options.backgroundColor ?= "rgba(255, 255, 255, 0.2)"
		options.borderRadius ?= 10
		options.html = title

		if options.disabled
			options.backgroundColor = "rgba(255, 255, 255, .1)"

		super options

		@style = _.extend {}, defaultFont,
			textAlign: "center"
			paddingTop: "20px"

		if !options.disabled
			@on Events.TouchStart, ->
				@animate
					properties: scale: .98, opacity: .5
					curve: exports.clickAnimationCurve
			@on Events.TouchEnd, ->
				@animate
					properties: scale: 1, opacity: 1
					curve: exports.clickAnimationCurve

class exports.ActionButton extends exports.Button
	constructor: (title, options = {}) ->
		options.backgroundColor ?= "rgba(255, 255, 255, 0.14)"
		if options.image?
			iconImage = options.image
			options.image = null

		super title, options

		if options.image?
			imageLayer = new Layer image: iconImage, width: 50, height: 50, superLayer: @, y: -45, x: 15

class exports.DismissButton extends exports.Button
	constructor: (options = {}) ->
		title = if options.title? then options.title else "Dismiss"

		super title, options

class exports.Pagination extends PageComponent
	constructor: (options = {}) ->
		options.width ?= Screen.width
		options.height ?= Screen.height
		options.scrollVertical ?= false
		options.backgroundColor ?= "transparent"

		super options

		@numberOfPages = 0
		@paginationVisible = false
		@currentPageIndex = 0
		@showPagination = if options.showPagination? then options.showPagination else true

		@.on "change:currentPage", ->
			@pageChanged()

	addPage: (page) ->
		@numberOfPages++
		@updatePageCounter()
		super page

	addPages: (pages...) ->
		_.each pages, (page) =>
			@addPage page

	pageChanged: ->
		@currentPageIndex = @horizontalPageIndex(@currentPage)
		@updatePageCounter()

	updatePageCounter: ->
		@paginationVisible = @showPagination && @numberOfPages > 1
		if @paginationLayer?
			@paginationLayer.destroy()
			@paginationLayer = null

		return if !@paginationVisible

		@paginationLayer = new Layer
			width: Screen.width, height: 6, y: Screen.height - 10, backgroundColor: "transparent"

		ballWidth = 6
		ballPadding = 5
		balls = []
		totalWidth = (@numberOfPages * ballWidth) + (@numberOfPages * ballPadding)
		# Create the balls
		for i in [0..@numberOfPages - 1]
			ball = new Layer
				backgroundColor: "rgba(255, 255, 255, 0.35)", width: ballWidth, height: ballWidth, borderRadius: ballWidth, superLayer: @paginationLayer
			ball.x = ((ballWidth + ballPadding) * i)
			balls.push ball

		@paginationLayer.width = totalWidth - ballPadding
		@paginationLayer.centerX()
		balls[@currentPageIndex].backgroundColor = "white"
		# Make the content shorter just once to accomodate the pagination.
		if @height == Screen.height
			@height = Screen.height - 16

class exports.Page extends Layer
	constructor: (options = {}) ->
		options.width ?= Screen.width
		options.height ?= if statusBarVisible then Screen.height - statusBarHeight else Screen.height
		options.backgroundColor ?= "transparent"

		super options

		if statusBarVisible
			@style.marginTop = "#{statusBarHeight}px"

	addLayer: (layer) ->
		layer.superLayer = @

class exports.ModalSheet extends Layer
	constructor: (options = {}) ->
		options.width ?= Screen.width
		options.height ?= Screen.height
		options.y ?= Screen.height
		options.backgroundColor ?= "black"

		super options

		@animationCurve = "spring(300,30,0)"

		if options.dismissTitle
			dismissLayer = new Layer
				width: Screen.width
				height: 40
				backgroundColor: "transparent"
				html: options.dismissTitle
				superLayer: @
			dismissLayer.style =
				fontFamily: "SanFranciscoText-Regular"
				fontSize: "32px"
				color: "#FFFFFF"
				lineHeight: "38px"
			dismissLayer.on Events.TouchStart, ->
				dismissLayer.animate
					properties: opacity: .5, scale: .95
					curve: exports.clickAnimationCurve
			dismissLayer.on Events.TouchEnd, ->
				dismissLayer.animate
					properties: opacity: 1, scale: 1
					curve: exports.clickAnimationCurve
			dismissLayer.on Events.Click, =>
				@dismiss()

	addLayer: (layer) ->
		layer.superLayer = @

	present: ->
		@bringToFront()
		@animate
			properties: y: 0
			curve: @animationCurve

	dismiss: ->
		@animate
			properties: y: Screen.height
			curve: @animationCurve

class exports.Separator extends Layer
	constructor: (options = {}) ->
		options.height = 4
		options.width ?= Screen.width
		options.borderRadius = 4
		options.backgroundColor ?= "white"

		super options

		@centerX()

class exports.Notification extends Layer
	@contentBodyFont:
		fontFamily: "SanFranciscoText-Regular"
		fontSize: "30px"
		color: "#FFF"
		lineHeight: "35px"

	constructor: (options = {}) ->
		@launchAnimationCurve = "spring(120,18,0)"
		@easeOutAnimationCurve = "spring(320,26,0)"
		defaultFont =
			fontFamily: "SanFranciscoText-Regular"
			color: "#FFF"

		@backgroundFadeLayer = new Layer width: Screen.width, height: Screen.height, backgroundColor: "black", opacity: 0

		iconImage = options.image
		options.image = null
		options.width = Screen.width
		options.height = Screen.height
		options.backgroundColor = "transparent"
		options.y = Screen.height

		super options

		@iconLayer = new Layer y: Screen.height + 40, width: 196, height: 196, image: iconImage, borderRadius: 98
		@iconLayer.backgroundColor = if iconImage? then "transparent" else "#FF2968"
		@iconLayer.centerX()

		if options.title?
			firstTitleLayer = new Layer
				y: 250
				width: Screen.width
				height: 50
				html: options.title
				superLayer: @
				style: _.extend {}, defaultFont,
					textAlign: "center"
					backgroundColor: "transparent"
					fontSize: "38px"
					lineHeight: "45px"
			firstTitleLayer.centerX()

		if options.appName?
			firstAppName = new Layer
				y: 310
				width: Screen.width
				height: 50
				html: options.appName
				superLayer: @
				style: _.extend {}, defaultFont,
					textAlign: "center"
					backgroundColor: "transparent"
					fontSize: "28px"
					color: if options.appNameColor? then options.appNameColor else "#FF2968"
					letterSpacing: "0.21px"
					lineHeight: "34px"
					textTransform: "uppercase"
			firstAppName.centerX()

		@notificationContentLayer = new ScrollComponent width: Screen.width, height: Screen.height, backgroundColor: "transparent", scrollHorizontal: false, mouseWheelEnabled: true, y: Screen.height

		notificationContentBodyLayer = new Layer
			y: 36
			borderRadius: "10px"
			width: Screen.width
			height: if options.contentBodyLayer? then 110 + options.contentBodyLayer.height else 140
			backgroundColor: if options.contentBodyBackgroundColor? then options.contentBodyBackgroundColor else "rgba(255, 255, 255, 0.14)"
			superLayer: @notificationContentLayer.content

		if options.title?
			notificationContentBodyTitleLayer = new Layer
				y: 73
				x: 14
				html: options.title
				width: notificationContentBodyLayer.width - 28
				height: 38
				superLayer: notificationContentBodyLayer
				style: _.extend {}, defaultFont,
					fontFamily: "SanFranciscoText-Semibold"
					fontSize: "30px"
					lineHeight: "36px"
					backgroundColor: "transparent"

		if options.contentBodyLayer?
			options.contentBodyLayer.y = if options.title? then 110 else 73
			options.contentBodyLayer.width = notificationContentBodyLayer.width
			options.contentBodyLayer.superLayer = notificationContentBodyLayer

		notificationContentTitleLayer = new Layer
			height: 54
			superLayer: notificationContentBodyLayer
			backgroundColor: if options.contentTitleBackgroundColor? then options.contentTitleBackgroundColor else "rgba(255, 255, 255, 0.1)"
			width: Screen.width
			borderRadius: "10px 10px 0 0"
			html: options.appName
			style: _.extend {}, defaultFont,
				textAlign: "right"
				fontSize: "24px"
				letterSpacing: "0.6px"
				lineHeight: "29px"
				textTransform: "uppercase"
				padding: "12px 18px 0"

		@lastActionButtonY = notificationContentBodyLayer.height + notificationContentBodyLayer.y
		@notificationContentLayer.updateContent()

	show: ->
		# Add the dismiss on show so we don't have to care about positioning on the last position
		@addActionButton new exports.DismissButton
		@iconLayer.bringToFront()
		@backgroundFadeLayer.animate
			properties: opacity: .8
			curve: @launchAnimationCurve
		@animate
			properties: y: 0
			curve: @launchAnimationCurve
		@iconLayer.animate
			properties: y: 40
			curve: @launchAnimationCurve

		Utils.delay 1, =>
			iconLayerAnimation = @iconLayer.animate
				properties:
					width: 90
					height: 90
					x: 15
					y: 5
				curve: @easeOutAnimationCurve
			@backgroundFadeLayer.animate
				properties: opacity: 0
				curve: @easeOutAnimationCurve
			@animate
				properties: opacity: 0
				curve: @easeOutAnimationCurve
			@notificationContentLayer.animate
				properties: y: 0
				curve: @easeOutAnimationCurve
			iconLayerAnimation.on Events.AnimationEnd, =>
				@iconLayer.superLayer = @notificationContentLayer.content

	addActionButton: (actionButton) ->
		buttonPaddingTop = 8
		actionButton.superLayer = @notificationContentLayer.content
		actionButton.y = @lastActionButtonY + buttonPaddingTop
		@lastActionButtonY += actionButton.height + buttonPaddingTop
		@notificationContentLayer.updateContent()

	addActionButtons: (actionButtons...) ->
		for actionButton in actionButtons
			@addActionButton actionButton
