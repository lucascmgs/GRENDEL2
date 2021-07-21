extends Node

export var text:String = "teste"

func interact():
	TextBox.visible = true
	TextBox.get_node("NinePatchRect/RichTextLabel").set_bbcode(text)
	TextBox.get_node("Timer").start()
