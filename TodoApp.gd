extends PanelContainer

const TodoItemView = preload("res://TodoItemView.tscn")
const TodoItem = preload("res://TodoItem.gd")

onready var todo_item_vbox = $"VBox/TodoItemsScroll/Margin/TodoItems"
onready var info_label = $"VBox/InfoLabel"
onready var hide_completed_btn = $"VBox/HideCompletedButton"
onready var text_field = $"VBox/TextFieldContainer/TextField"

var todo_items: Array = []

func _ready():
	hide_completed_btn.connect("toggled", self, "_on_hide_completed_btn_toggled")
	text_field.connect("text_entered", self, "_on_text_entered")
	_update_info_label()

func _on_hide_completed_btn_toggled(toggled: bool):
	for view in todo_item_vbox.get_children():
		view.hide_if_done = toggled

func _on_text_entered(text: String):
	if text == "":
		return
	
	var todo_item = TodoItem.new(text)
	todo_item.connect("done_changed", self, "_on_todo_item_done_changed")
	
	var todo_item_view = TodoItemView.instance()
	todo_item_view.todo_item = todo_item
	todo_item_view.hide_if_done = hide_completed_btn.pressed
	todo_item_view.connect("delete_requested", self, \
		"_on_todo_item_view_delete_requested", [todo_item_view])
	
	todo_item_vbox.add_child(todo_item_view)
	todo_items.append(todo_item)
	text_field.clear()
	
	_update_info_label()

func _on_todo_item_view_delete_requested(view):
	var idx: int = todo_items.find(view.todo_item)
	if idx >= 0:
		todo_items.remove(idx)
	
	todo_item_vbox.remove_child(view)
	view.queue_free()
	_update_info_label()

func _on_todo_item_done_changed(_done: bool):
	_update_info_label()

func _update_info_label():
	var done_count: int = 0
	for todo_item in todo_items:
		done_count += 1 if todo_item.done else 0
	
	info_label.text = "%d / %d" % [done_count, todo_items.size()]
