#include "\x\cba\addons\keybinding\script_component.hpp"

disableSerialization;

_display = uiNamespace getVariable "RscDisplayConfigure";
_ctrl = _this select 0;
_idx = _this select 1;

// Get handler tracker index for key stored in listbox
_index = parseNumber (_ctrl lnbData [_idx, 1]);

// Get entry from handler tracker array
_handlerTracker = GVAR(handlers);
_keyConfig = _handlerTracker select _index;
_modName = _keyConfig select 0;
_actionName = _keyConfig select 1;
_oldKeyData = _keyConfig select 2;
_functionName = _keyConfig select 3;

// Clear keypress data.
GVAR(input) = [];

// Mark that we're waiting so that onKeyDown handler blocks input (Esc key)
GVAR(waitingForInput) = true;

// Update box content to indicate that we're waiting for input.
_ctrl lnbSetText [[_idx, 1], "Press key or Esc to clear"];
_ctrl lnbSetColor [[_idx, 1], [1,0,0,1]];

// Wait for input.
waitUntil {count GVAR(input) > 0};

// Tell the onKeyDown handler that we're not waiting anymore, so it stops blocking input.
GVAR(waitingForInput) = false;

if (!isNull _display) then { // Make sure user hasn't exited dialog before continuing.
	// Get stored keypress data.
	_keyPressData = GVAR(input);

	// If Esc was pressed, update the key to be blank.
	if (_keyPressData select 0 == 1) then {
		_keyPressData = [-1, false, false, false];
	};

	// Re-register the handler, overwriting old keypressdata.
	player sidechat format ["%1", [_modName, _actionName, _functionName, _keyPressData, true]];
	[_modName, _actionName, _functionName, _keyPressData, true] call cba_fnc_registerKeybind;

	// Update the main dialog.
	[] call FUNC(updateGUI);
};


