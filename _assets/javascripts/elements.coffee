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
	attributes: {}

	constructor: ->
		template = JST['templates/' + @name.replace(/-/g, '_')](@attributes)
		
		# This only happens on the filters, so is not such a performance issue
		if @e
			@e.innerHTML = template
		# Games are this situation
		else
			wrapper = document.createElement(@tmpWrapper)
			wrapper.innerHTML = template
			@e = wrapper.firstChild