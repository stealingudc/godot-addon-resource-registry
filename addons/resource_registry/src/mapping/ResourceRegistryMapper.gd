@tool
extends Node

const DATA_PATH = "res://addons/resource_registry/data/data.res";
var data: ResourceRegistryData;

signal resources_changed;

func _enter_tree() -> void:
	if not ResourceLoader.exists(DATA_PATH):
		ResourceSaver.save(ResourceRegistryData.new(), DATA_PATH);
	data = load(DATA_PATH);

func find_and_add_resource_type(path: String) -> void:
	var classname = RegistryDirectoryScanner.scan_dir(path);
	data.resources.append(classname);
	data.paths.append(path);
	
func add_resource(classname: String, path: String) -> void:
	data.resources.append(classname);
	data.paths.append(path);
	
func map_in_dir(path: String) -> void:
	var files = RegistryDirectoryScanner.scan_dir_files(path);
	for i in range(files.size()):
		var res = ResourceLoader.load(files[i]);
		res.set_meta("id", i);
		ResourceSaver.save(res, path);
	
#func make_map() -> void:
	#for i in range(data.resources.size()):
		#var path = data.paths[i];
		#
