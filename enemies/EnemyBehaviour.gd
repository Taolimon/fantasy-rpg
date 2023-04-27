extends Node

enum STATES {
	NORMAL,
	WARY,
	ADVANCING,
	ATTACKING,
	GUARDING,
	DOWNED
}

enum AFFLICTIONS {
	LIGHT_DAMAGE,
	HEAVY_DAMAGE,
	PLAYER_ADVANCE
}

var state = STATES.NORMAL

func setState(new_state):
	state = new_state

func getState():
	return state
	

