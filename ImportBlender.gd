@tool
extends EditorScript

func scene_to_mesh(scene: Node3D) -> ArrayMesh:
	var new_mesh := ArrayMesh.new()
	for obj in scene.get_children():
		if not obj is MeshInstance3D:
			continue
		var adjusted_transform = obj.transform
		adjusted_transform.origin *= Vector3(-1, -1, 1)
		var mesh: Mesh = obj.mesh
		for surface_idx in range(mesh.get_surface_count()):
			var arrays = mesh.surface_get_arrays(surface_idx)
			arrays[Mesh.ARRAY_VERTEX] *= adjusted_transform
			new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	return new_mesh
	

func _run():
	var filesystem := EditorInterface.get_resource_filesystem()
	var import_path := filesystem.get_filesystem_path("Blender")
	var export_path := filesystem.get_filesystem_path("Blender/Export")
	
	for i in range(import_path.get_file_count()):
		var scene = load(import_path.get_file_path(i)).instantiate()
		var mesh = scene_to_mesh(scene)
		var filename = import_path.get_file(i).trim_suffix(".blend") + ".tres"
		ResourceSaver.save(mesh, export_path.get_path() + "/" + filename)
