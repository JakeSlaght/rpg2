extends Node

# debug toggles
signal room_configuration_changed(
	north: bool,
	east: bool,
	south: bool,
	west: bool
)

# game state
signal game_mode_changed(previous_mode, new_mode)

# Interaction Area registration for NPCs and such
signal register_interaction_area(area: InteractionArea)
signal unregister_interaction_area(area: InteractionArea)

# Dialogue Panel
signal dialogue_display(speaker: String, lines: Array[String])

# setting active character
signal active_character_changed(character: CharacterData)
signal current_party_changed(party: Array[CharacterData])

# main menu triggerings
signal new_game_requested
signal quit_requested
