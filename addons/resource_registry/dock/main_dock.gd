extends VBoxContainer

var plugin: EditorPlugin;

@onready var container: VBoxContainer;
@onready var add_button: Button;
@onready var scan_button: Button;

func _enter_tree() -> void:
	self.name = "Resource Registry";
	self.size_flags_vertical = Control.SIZE_EXPAND_FILL;
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
	
	container = VBoxContainer.new();
	
	var row = HBoxContainer.new();
	
	var main_label = Label.new();
	main_label.text = "Resource Types";
	
	var secondary_label = Label.new();
	secondary_label.text = "To get started, add a file path where those resources are saved.\n(i.e. \"res://resources/items\" -> Item.gd).\nAfter that, click \"Scan\".";
	var secondary_label_settings = LabelSettings.new();
	secondary_label_settings.font_size = 12;
	secondary_label.label_settings = secondary_label_settings;
	secondary_label.autowrap_mode = TextServer.AUTOWRAP_WORD;
	
	add_button = Button.new();
	add_button.custom_minimum_size = Vector2(32, 32);
	add_button.text = "+";
	
	scan_button = Button.new();
	scan_button.custom_minimum_size = Vector2(32, 32);
	scan_button.text = "Scan";
	
	add_button.pressed.connect(_on_add_pressed);
	scan_button.pressed.connect(_on_scan_pressed);
	
	row.add_child(main_label);
	row.add_child(add_button);
	row.add_child(scan_button);
	
	self.add_child(row);
	self.add_child(secondary_label);
	self.add_child(HSeparator.new())
	self.add_child(container);
	
	_refresh_list()

func _on_add_pressed() -> void:
	ResourceRegistryMapper.add_resource("", "") # placeholder
	_refresh_list()
	
func _on_scan_pressed() -> void:
	for i in range(container.get_children().size()):
		var row = container.get_children()[i];
		var path = (row.get_children()[1] as LineEdit).text;
		var classname = RegistryDirectoryScanner.scan_dir(path);
		ResourceRegistryMapper.data.resources[i] = classname;
		ResourceRegistryMapper.data.paths[i] = path;
		ResourceRegistryMapper.map_in_dir(path);
	var err = ResourceSaver.save(ResourceRegistryMapper.data, ResourceRegistryMapper.DATA_PATH);
	if err != OK:
		push_error("Failed to save Resource Registry data to %s" % ResourceRegistryMapper.DATA_PATH);
	_refresh_list();
	
func _refresh_list() -> void:
	for child in container.get_children():
		child.queue_free();
		
	ResourceRegistryMapper.data = load(ResourceRegistryMapper.DATA_PATH);
	for i in range(ResourceRegistryMapper.data.resources.size()):
		var classname = ResourceRegistryMapper.data.resources[i];
		var path = ResourceRegistryMapper.data.paths[i];
		
		var row = HBoxContainer.new();
		
		row.size_flags_vertical = Control.SIZE_EXPAND_FILL;
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
		
		var label = Label.new();
		label.text = classname.capitalize() if classname else "<empty>" + ": ";
		row.add_child(label);
		
		var field = LineEdit.new();
		field.size_flags_vertical = Control.SIZE_EXPAND_FILL;
		field.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
		field.text = path;
		
		row.add_child(field);
		
		container.add_child(row);
	
#func _on_resource_changed(res: Resource, index: int):
	#ResourceRegistry.resources[index] = res;
	#print("Resource at index %d changed to %s" % [index, res]);
