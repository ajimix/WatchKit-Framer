clickAnimation = "spring(500,30,0)"
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

		titleLayer.style = _.extend defaultFont,
			backgroundColor: "transparent"
			color: "#FF9501"

		if options.back
			backArrowLayer = new Layer
				x:0, y:13, width:backArrowLayerWidth, height:17, image:"images/backArrow.png", superLayer: @
			titleLayer.x = 15

		if options.time
			timeWidth = 80
			timeLayer = new Layer x: Screen.width - timeWidth, html: "10:09", width: timeWidth, height: statusBarHeight, superLayer: @
			timeLayer.style = _.extend defaultFont,
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

		@style = _.extend defaultFont,
			textAlign: "center"
			paddingTop: "20px"

		if !options.disabled
			@on Events.TouchStart, ->
				@animate
					properties: scale: .98, opacity: .5
					curve: clickAnimation
			@on Events.TouchEnd, ->
				@animate
					properties: scale: 1, opacity: 1
					curve: clickAnimation

class exports.ActionButton extends exports.Button
	constructor: (title, options = {}) ->
		options.backgroundColor ?= "rgba(255, 255, 255, 0.14)"

		super title, options

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
					curve: clickAnimation
			dismissLayer.on Events.TouchEnd, ->
				dismissLayer.animate
					properties: opacity: 1, scale: 1
					curve: clickAnimation
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
