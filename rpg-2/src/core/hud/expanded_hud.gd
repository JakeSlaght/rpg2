extends PanelContainer
class_name ExpandedHUD

@onready var party_manager: PartyManager = %PartyManager
@onready var character_profiles: TabContainer = %CharacterProfiles

func _ready() -> void:
	Bus.current_party_changed.connect(_setup_tabs)
	
func _setup_tabs(party: Array[CharacterData]) -> void:
	for character in party:
		var tab := Control.new()
		tab.name = character.character_name
		
		character_profiles.add_child(tab)
		character_profiles.set_tab_title(
			character_profiles.get_tab_count() - 1,
			character.character_name
			)

func _on_quit_pressed() -> void:
	get_tree().quit()
