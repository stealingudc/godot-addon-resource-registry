@tool
extends Node
	
func same_class(resources: Array[Resource]) -> bool:
	var error = false;
	for resource in resources:
		var classname = ResourceClass.get_class_name(resource);
		print(ResourceRegistryMapper.data.resources);
		if not ResourceRegistryMapper.data.resources.has(classname):
			push_error("Resource \"" + classname + "\" not found. Try re-scanning your resources' classpaths (Resource Registry -> Add Path -> Scan)");
			error = true;
	if error: return false;
	return true;
	
# TODO: same ID (create mapping system)
func same_type(resources: Array[Resource]) -> bool:
	var id = resources[0].get_meta('id');
	if not same_class(resources): return false;
	for resource in resources:
		if resource.get_meta('id') != id:
			return false;
	return true;
		
