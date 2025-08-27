class_name RegistryDirectoryScanner extends Object

static func scan_dir(path: String) -> String:
	var classname = null;
	
	if not Engine.is_editor_hint():
		return "";
		
	var dir = DirAccess.open(path);
	if dir == null:
		return "";
		
	dir.list_dir_begin();
	var file_name = dir.get_next();
	while file_name != "":
		
		if !dir.current_is_dir() and file_name.ends_with(".tres") or file_name.ends_with(".res"):
			classname = ResourceClass.get_class_name(ResourceLoader.load(path + "/" + file_name));
		elif dir.current_is_dir() and file_name != "." and file_name != "..":
			scan_dir(path + "/" + file_name);
		file_name = dir.get_next();
	dir.list_dir_end();
	
	return classname;

static func scan_dir_files(path: String) -> Array[String]:
	var files: Array[String] = [];
	
	if not Engine.is_editor_hint():
		return [];
	
	var dir: DirAccess = DirAccess.open(path);
	if dir == null:
		return [];
	
	dir.list_dir_begin();
	var file_name: String = dir.get_next();
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".tres") or file_name.ends_with(".res"):
			files.append(path + "/" + file_name);
		elif dir.current_is_dir() and file_name != "." and file_name != "..":
			scan_dir(path + "/" + file_name);
		file_name = dir.get_next();
	dir.list_dir_end();
	
	return files;
