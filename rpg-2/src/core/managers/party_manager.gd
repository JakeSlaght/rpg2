extends Node
class_name PartyManager

@export var party_data: PartyData

const MAX_PARTY_SIZE: int = 4

func _ready() -> void:
	assert(party_data != null, "PartyManager requires PartyData.")
	

func get_active_character() -> CharacterData:
	return party_data.party_members.get(party_data.active_character_index)

func set_active_character(index: int) -> void:
	if index < 0 or index >= party_data.party_members.size(): return

	party_data.active_character_index = index
	Bus.active_character_changed.emit(get_active_character())

func add_to_active_roster(character: CharacterData) -> void:
	if character == null: return
	if not party_data.characters.has(character): return
	if party_data.party_members.size() >= MAX_PARTY_SIZE: return
	if party_data.party_members.has(character): return
	
	party_data.party_members.append(character)

func remove_from_active_roster(character: CharacterData) -> void:
	if character == null: return
	
	var index := party_data.party_members.find(character)
	if index == -1: return
	if party_data.party_members.size() <= 1: return
	
	party_data.party_members.remove_at(index)
	
	if party_data.active_character_index >= party_data.party_members.size():
		party_data.active_character_index = 0
	elif index < party_data.active_character_index:
		party_data.active_character_index -= 1
	
func add_to_available_character_list(character: CharacterData) -> void:
	if character == null: return
	if party_data.characters.has(character): return
	
	party_data.characters.append(character)
