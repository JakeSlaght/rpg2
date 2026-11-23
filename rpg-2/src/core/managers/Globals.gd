enum RoomType {
	TavernInn,
	Temple,
	Dungeon,
	Store,
	None # default
}

enum RoomEnvironment {
	Indoor,
	Outdoor
}

enum NPCPurpose {
	StoreOwner,
	QuestGiver,
	TemplePriest,
	TavernKeep
}

enum ClassType {
	Warrior,
	Thief,
	Healer,
	Mage,
	None
}

enum ItemClassification {
	Weapon,
	Armor,
	AllPurpose,
	Quest,
	Storage
}

enum DamageType {
	Basic,
	Light,
	Dark,
	Fire,
	Ice,
	Earth,
	Wind
}

enum ItemState {
	Equipped,
	Broken,
	Stored,
	Inventoried,
	Consumed
}

enum GameMode {
	None,
	Menu,
	Exploration,
	Combat
}
