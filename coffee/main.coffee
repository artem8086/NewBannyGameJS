svgCanvas = Snap '.mainCanvas'

bannyPath = 'svg/banny.svg'
bannyData = null

Snap.load bannyPath, (data) ->
	bannyData = data.select '.root'

$window = $ window

do resizeCanvas = ->
	svgCanvas.attr
		width: do $window.width
		height: do $window.height

$window.on 'resize', resizeCanvas

bannyCounter = 0
$('.js-banny').text bannyCounter

svgCanvas.click (e) ->
	if bannyData
		$('.js-banny').text ++bannyCounter
		newBanny = bannyData
			.clone()
			.transform "t#{e.offsetX},#{e.offsetY}"
		svgCanvas
			.append(newBanny)


window.countFPS = do ->
	lastLoop = do (new Date).getMilliseconds
	count = 1
	fps = 0

	->
		currentLoop = do (new Date).getMilliseconds
		if lastLoop > currentLoop
			fps = count
			count = 1
		else
			count += 1
		lastLoop = currentLoop
		fps

fpsCounter = $ '.js-fps'
do cycle = ->
	requestAnimationFrame ->
		fpsCounter.text do countFPS
		do cycle