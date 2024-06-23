extends GPUParticles2D

func _init(sprite : Texture):
	process_material.set_shader_param("emission_box_extents", Vector3(sprite.get_width() / 2, sprite.get_height() / 2, 1))
	
	process_material.set_shader_param("sprite", sprite)
	
	amount = sprite.get_width() * sprite.get_height()
	
	emitting = true
