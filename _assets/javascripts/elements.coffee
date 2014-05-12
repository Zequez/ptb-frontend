window.$ = document.querySelectorAll.bind(document)
window.$$ = document.querySelector.bind(document)
Element.prototype.$ = Element.prototype.querySelectorAll
Element.prototype.$$ = Element.prototype.querySelector

class PTB.DOMElement extends PTB.Eventable
	constructor: ->
		@e = document.querySelector('[' + @name + ']')


class PTB.TemplateElement extends PTB.Eventable
	name: ''
	tmpWrapper: 'div'
	displayValue: 'block'
	display: true
	attributes: {}

	constructor: ->
		template = JST['templates/' + @name.replace(/-/g, '_')](@attributes)
		
		if @e
			@e.innerHTML = template
		else
			wrapper = document.createElement(@tmpWrapper)
			wrapper.innerHTML = template
			@e = wrapper.firstChild

	toggle: (show)->
		return if @display == show
		@display = show
		if show
			@e.style.display = @displayValue
		else
			@e.style.display = 'none'