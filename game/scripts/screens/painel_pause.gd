extends Control


func _draw():
    var r = Rect2( Vector2(), get_size() )
    draw_rect(r, Color(0,0,1) )


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
