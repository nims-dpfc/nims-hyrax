export class RequiredFields {
  // Monitors the form and runs the callback if any of the required fields change
  constructor(form, callback) {
    this.form = form
    this.callback = callback
    this.reload()
  }

  get areComplete() {
		this.reload()
    return this.requiredFields.filter((n, elem) => { return this.isValuePresent(elem) } ).length === 0
	}
	
	requiredIf() {
		// this is hard-coded - to do, use erb to grab a list
		let conditions = ['any', 'name']
		var elems = []

		// build the list of elem; cleanup
		$.each(conditions, function(n,value) {
			$(":input.require-if-"+value).each(function(n,elem) {
				// Remove the required class, attribute and box-shadow (they will be reset if needed)
				$(elem).removeClass('required');
				$(elem).attr('required', null);
				$(elem).removeAttr('style');
				elems.push({ value : elem })
			});
		});
		
		$.each(elems, function(n,elem_obj) {
				var required = elem_obj.value
				var id = $(required).attr('id');
				var parents = $(required).closest('div.multi-nested')

				if (elem_obj.key === 'any') {
					var label = $(parents).find('label[for="' + id + '_"]')
				} else {
					var label = $(parents).find('label[for="' + id + '_' + elem_obj.key + '"]')
				}

				// Remove the required class and span (they will be reset if needed)
				$(label).removeClass('required')
				$(label).find('span').remove();
				
				// Find the immediate field-wrapper
				// Gather the inputs
				this.inputs = $(required).closest('li.field-wrapper').find(':input');
				// Skip the current elem, any hidden fields and any buttons, skip operator (role) (pre-filled but should not be required)
				if (this.inputs.filter((n, el) => {
					if ( 
						!el.parentNode.className.includes("hidden") && !el.className.includes('btn') && !el.className.includes('remove-hidden') && el != required && el.value !== 'operator' ) {
						return (el.value !== '');
					}
				} ).length > 0) {
					// Add the required classes, attributes and labels
					if ( $(label).has('span').length === 0 ) {
						$(label).addClass('required control-label')
						$(label).append('<span class="label label-info required-tag">required</span>');
						$(required).addClass('required');
						$(required).attr('required', 'required');
						// Only add the css if the value is empty
						if ( ($(required).val() === null) || ($(required).val().length < 1) ) {
							$(required).css('box-shadow','0px 0px 0px 2px red');
						}
					}
				};
		});

		// Find all inputs in multi-nested blocks (where conditional requirements will be in place)
		this.conditionalRequiredFields = this.form.find('div.multi-nested :input')
		this.conditionalRequiredFields.change(this.callback)
	}

	isValuePresent(elem) {
    return ($(elem).val() === null) || ($(elem).val().length < 1)
	}

  // Reassign requiredFields because fields may have been added or removed.
  reload() {
		// Add any new required flags
		this.requiredIf()
		// ":input" matches all input, select or textarea fields.
		this.requiredFields = this.form.find(':input[required]')
		this.requiredFields.change(this.callback)
  }
}
