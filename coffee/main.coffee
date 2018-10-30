import world from './test.js'

class Test
	do: ->
		console.log 'hello'

test = new Test
do test.do

console.log 'hello'
do world
