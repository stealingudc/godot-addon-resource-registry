@tool
extends EditorPlugin
var main_dock: Control;

const RESOURCE_REGISTRY_NAME: String = "ResourceRegistry";
const RESOURCE_REGISTRY_PATH: String = "res://addons/resource_registry/ResourceRegistry.gd";

const RESOURCE_REGISTRY_MAPPER_NAME: String = "ResourceRegistryMapper";
const RESOURCE_REGISTRY_MAPPER_PATH: String = "res://addons/resource_registry/src/mapping/ResourceRegistryMapper.gd";

const MAIN_DOCK_PATH: String = "res://addons/resource_registry/dock/main_dock.gd"

func _enter_tree() -> void:
	add_autoload_singleton(RESOURCE_REGISTRY_NAME, RESOURCE_REGISTRY_PATH);
	add_autoload_singleton(RESOURCE_REGISTRY_MAPPER_NAME, RESOURCE_REGISTRY_MAPPER_PATH);
	
	main_dock = ResourceLoader.load(MAIN_DOCK_PATH).new();
	main_dock.name = "Resource Registry";
	add_control_to_dock(DOCK_SLOT_LEFT_BR, main_dock);

func _exit_tree() -> void:
	remove_control_from_docks(main_dock);
	
	remove_autoload_singleton(RESOURCE_REGISTRY_NAME);
	remove_autoload_singleton(RESOURCE_REGISTRY_MAPPER_NAME);
