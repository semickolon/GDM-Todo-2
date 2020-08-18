signal done_changed(done)

var text: String
var done: bool setget _set_done, _get_done

func _init(text: String, done: bool = false):
	self.text = text
	self.done = done

func _set_done(value: bool):
	done = value
	emit_signal("done_changed", done)

func _get_done():
	return done
