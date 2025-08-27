class_name ResourceClass extends Object

static func get_class_name(res: Resource) -> String:
	return (res.get_script().resource_path as String).get_basename().get_file();
