# WatchKit-Framer
Apple Watch Kit for FramerJS to help you easily create Apple Watch interfaces in Framer.

## Add it in your Framer Studio project
- Download the project
- Copy `watchkit.coffee` into `modules/` folder
- Import it in Framer Studio by writing: `WatchKit = require "watchkit"`

## Components

### Status Bar

Creates an Apple Watch status bar.

![Apple Watch Status Bar](img/status-bar.jpg)

```coffeescript
statusBar = new WatchKit.StatusBar
	title: "Some title"
	back: true # Display or not the back button
	time: true # Display or not the time
```

### Buttons

Buttons should have the Y position where you want to place them in the screen.  
Buttons perform an animation when the user clicks them.

**Button for actions**

![Apple Watch Action Button](img/action-button.jpg)

```coffeescript
actionButton = new WatchKit.ActionButton "Button title", y: 50
```

**Button for dismiss**

![Apple Watch Dismiss Button](img/dismiss-button.jpg)

```coffeescript
dismissButton = new WatchKit.DismissButton y: 140
```

**Disable a button**

Buttons can be disabled using the `disabled: true`.

![Apple Watch Disabled Button](img/disabled-button.jpg)

### Page

The basic page for the pagination element.  

```coffeescript
page = new WatchKit.Page
```

Layers can be added inside a page by using the `addLayer` method.

```coffeescript
page = new WatchKit.Page
layer = new Layer

page.addLayer layer
```
	
### Pagination

Creates a framer page component with the apple watch pagination dots.  
Pagination contains a set of pages.

![Apple Watch Pagination](img/pagination.jpg)

```coffeescript
pagination = new WatchKit.Pagination
	showPagination: true # Display or not the pagination dots
```

In order to add pages use the `addPages` method.

```coffeescript
page1 = new WatchKit.Page image: "images/some_image.jpg"
page2 = new WatchKit.Page
someLayer = new Layer

page2.addLayer someLayer

pagination.addPages page1, page2
```
