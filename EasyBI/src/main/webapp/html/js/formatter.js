
	function format(mask, number) {
		var s = '' + number, r = '';
		for (var im = 0, is = 0; im < mask.length && is < s.length; im++) {
			r += mask.charAt(im) == 'X' ? s.charAt(is++) : mask.charAt(im);
		}
		return r;
	}

	var dateTimeFormatter = function(value, row) {
		var icon = row.id % 2 === 0 ? 'glyphicon-star' : 'glyphicon-star-empty'
		return value != null ? format('XX-XX XX:XX', value.substring(4,14)) : "";
	}
	
	var dateFormatter = function(value, row) {
		var icon = row.id % 2 === 0 ? 'glyphicon-star' : 'glyphicon-star-empty'
			return value != null ? format('XX-XX-XX', value.substring(2,8)) : "";
	}
	
	String.prototype.replaceAll = function(org, dest) {
		return this.split(org).join(dest);
	}