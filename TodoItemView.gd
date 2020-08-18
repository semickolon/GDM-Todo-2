extends HBoxContainer

signal delete_requested()

const TodoItem = preload("res://TodoItem.gd")

onready var check_box = $CheckBox
onready var label = $RichTextLabel
onready var delete_btn = $DeleteButton

var todo_item: TodoItem
var hide_if_done: bool = false setget _set_hide_if_done, _get_hide_if_done

func _ready():
	check_box.connect("toggled", self, "_on_check_box_toggled")
	delete_btn.connect("pressed", self, "_on_delete_btn_pressed")
	todo_item.connect("done_changed", self, "_on_todo_item_done_changed")
	_update_view()

func _update_view():
	visible = not hide_if_done or not todo_item.done
	check_box.pressed = todo_item.done
	
	if todo_item.done:
		label.bbcode_text = "[color=gray][s]%s[/s][/color]" % todo_item.text
	else:
		label.bbcode_text = todo_item.text

func _on_check_box_toggled(checked: bool):
	todo_item.done = checked

func _on_delete_btn_pressed():
	emit_signal("delete_requested")

func _on_todo_item_done_changed(_done: bool):
	_update_view()

func _set_hide_if_done(value: bool):
	hide_if_done = value
	if check_box:
		_update_view()

func _get_hide_if_done():
	return hide_if_done
