/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2021 MasterEric
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * CustomControls.hx
 * The handler which provides an easy interface for querying advanced and custom rebindable keyboard binds.
 */
package funkin.behavior.options;

import flixel.FlxG;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.FlxInput;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

/**
 * This class handles ONLY custom keybinds.
 * Putting it in a separate class makes it easier to modify and keep track of.
 * 
 * TODO: Watch for changes to Controls.hx and port them here.
 */
enum abstract CustomAction(String) to String from String
{
	var LEFT_9K = "left-9k";
	var LEFT_9K_P = "left-9k-press";
	var LEFT_9K_R = "left-9k-release";
	var DOWN_9K = "down-9k";
	var DOWN_9K_P = "down-9k-press";
	var DOWN_9K_R = "down-9k-release";
	var UP_9K = "up-9k";
	var UP_9K_P = "up-9k-press";
	var UP_9K_R = "up-9k-release";
	var RIGHT_9K = "right-9k";
	var RIGHT_9K_P = "right-9k-press";
	var RIGHT_9K_R = "right-9k-release";
	var CENTER_9K = "center-9k";
	var CENTER_9K_P = "center-9k-press";
	var CENTER_9K_R = "center-9k-release";
	var LEFT_ALT_9K = "left-9k";
	var LEFT_ALT_9K_P = "left-9k-press";
	var LEFT_ALT_9K_R = "left-9k-release";
	var DOWN_ALT_9K = "down-9k";
	var DOWN_ALT_9K_P = "down-9k-press";
	var DOWN_ALT_9K_R = "down-9k-release";
	var UP_ALT_9K = "up-alt-9k";
	var UP_ALT_9K_P = "up-alt-9k-press";
	var UP_ALT_9K_R = "up-alt-9k-release";
	var RIGHT_ALT_9K = "right-alt-9k";
	var RIGHT_ALT_9K_P = "right-alt-9k-press";
	var RIGHT_ALT_9K_R = "right-alt-9k-release";
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum CustomControl
{
	LEFT_9K;
	DOWN_9K;
	UP_9K;
	RIGHT_9K;
	CENTER_9K;
	LEFT_ALT_9K;
	DOWN_ALT_9K;
	UP_ALT_9K;
	RIGHT_ALT_9K;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class CustomControls extends Controls
{
	public static var gamepad:Bool = false;

	var _left9K = new FlxActionDigital(CustomAction.LEFT_9K);
	var _left9KP = new FlxActionDigital(CustomAction.LEFT_9K_P);
	var _left9KR = new FlxActionDigital(CustomAction.LEFT_9K_R);
	var _down9K = new FlxActionDigital(CustomAction.DOWN_9K);
	var _down9KP = new FlxActionDigital(CustomAction.DOWN_9K_P);
	var _down9KR = new FlxActionDigital(CustomAction.DOWN_9K_R);
	var _up9K = new FlxActionDigital(CustomAction.UP_9K);
	var _up9KP = new FlxActionDigital(CustomAction.UP_9K_P);
	var _up9KR = new FlxActionDigital(CustomAction.UP_9K_R);
	var _right9K = new FlxActionDigital(CustomAction.RIGHT_9K);
	var _right9KP = new FlxActionDigital(CustomAction.RIGHT_9K_P);
	var _right9KR = new FlxActionDigital(CustomAction.RIGHT_9K_R);

	var _center9K = new FlxActionDigital(CustomAction.CENTER_9K);
	var _center9KP = new FlxActionDigital(CustomAction.CENTER_9K_P);
	var _center9KR = new FlxActionDigital(CustomAction.CENTER_9K_R);

	var _leftAlt9K = new FlxActionDigital(CustomAction.LEFT_ALT_9K);
	var _leftAlt9KP = new FlxActionDigital(CustomAction.LEFT_ALT_9K_P);
	var _leftAlt9KR = new FlxActionDigital(CustomAction.LEFT_ALT_9K_R);
	var _downAlt9K = new FlxActionDigital(CustomAction.DOWN_ALT_9K);
	var _downAlt9KP = new FlxActionDigital(CustomAction.DOWN_ALT_9K_P);
	var _downAlt9KR = new FlxActionDigital(CustomAction.DOWN_ALT_9K_R);
	var _upAlt9K = new FlxActionDigital(CustomAction.UP_ALT_9K);
	var _upAlt9KP = new FlxActionDigital(CustomAction.UP_ALT_9K_P);
	var _upAlt9KR = new FlxActionDigital(CustomAction.UP_ALT_9K_R);
	var _rightAlt9K = new FlxActionDigital(CustomAction.RIGHT_ALT_9K);
	var _rightAlt9KP = new FlxActionDigital(CustomAction.RIGHT_ALT_9K_P);
	var _rightAlt9KR = new FlxActionDigital(CustomAction.RIGHT_ALT_9K_R);

	public var LEFT_9K(get, never):Bool;

	inline function get_LEFT_9K()
		return _left9K.check();

	public var DOWN_9K(get, never):Bool;

	inline function get_DOWN_9K()
		return _down9K.check();

	public var UP_9K(get, never):Bool;

	inline function get_UP_9K()
		return _up9K.check();

	public var RIGHT_9K(get, never):Bool;

	inline function get_RIGHT_9K()
		return _right9K.check();

	public var CENTER_9K(get, never):Bool;

	inline function get_CENTER_9K()
		return _center9K.check();

	public var LEFT_ALT_9K(get, never):Bool;

	inline function get_LEFT_ALT_9K()
		return _leftAlt9K.check();

	public var DOWN_ALT_9K(get, never):Bool;

	inline function get_DOWN_ALT_9K()
		return _downAlt9K.check();

	public var UP_ALT_9K(get, never):Bool;

	inline function get_UP_ALT_9K()
		return _upAlt9K.check();

	public var RIGHT_ALT_9K(get, never):Bool;

	inline function get_RIGHT_ALT_9K()
		return _rightAlt9K.check();

	public function new(name, scheme = Controls.KeyboardScheme.None)
	{
		// Call the base Controls constructor.
		super(name, scheme);

		add(_left9K);
		add(_left9KP);
		add(_left9KR);
		add(_down9K);
		add(_down9KP);
		add(_down9KR);
		add(_up9K);
		add(_up9KP);
		add(_up9KR);
		add(_right9K);
		add(_right9KP);
		add(_right9KR);

		add(_center9K);
		add(_center9KP);
		add(_center9KR);

		add(_leftAlt9K);
		add(_leftAlt9KP);
		add(_leftAlt9KR);
		add(_downAlt9K);
		add(_downAlt9KP);
		add(_downAlt9KR);
		add(_upAlt9K);
		add(_upAlt9KP);
		add(_upAlt9KR);
		add(_rightAlt9K);
		add(_rightAlt9KP);
		add(_rightAlt9KR);

		for (action in digitalActions)
			byName[action.name] = action;

		loadKeyBinds();
	}

	public static function resetBinds():Void
	{
		Controls.resetBinds();
		FlxG.save.data.binds.fullscreenBind = "F11";

		FlxG.save.data.binds.left9KBind = "S";
		FlxG.save.data.binds.down9KBind = "";
		FlxG.save.data.binds.up9KBind = "D";
		FlxG.save.data.binds.right9KBind = "F";
		FlxG.save.data.binds.altLeftBind = "J";
		FlxG.save.data.binds.altDownBind = "";
		FlxG.save.data.binds.altUpBind = "K";
		FlxG.save.data.binds.altRightBind = "L";
		FlxG.save.data.binds.centerBind = "SPACE";

		// TODO: Fix these.
		FlxG.save.data.binds.gpleft9KBind = "";
		FlxG.save.data.binds.gpdown9KBind = "";
		FlxG.save.data.binds.gpup9KBind = "";
		FlxG.save.data.binds.gpright9KBind = "";
		FlxG.save.data.binds.gpcenterBind = "";
		FlxG.save.data.binds.gpaltLeftBind = "";
		FlxG.save.data.binds.gpaltDownBind = "";
		FlxG.save.data.binds.gpaltUpBind = "";
		FlxG.save.data.binds.gpaltRightBind = "";

		PlayerSettings.player1.controls.loadKeyBinds();
	}

	public static function keyCheck():Void
	{
		if (FlxG.save.data.binds.left9KBind == null)
		{
			trace("No LEFT9K");
			FlxG.save.data.binds.left9KBind = "S";
		}
		if (FlxG.save.data.binds.down9KBind == null)
		{
			trace("No DOWN9K");
			FlxG.save.data.binds.down9KBind = "";
		}
		if (FlxG.save.data.binds.up9KBind == null)
		{
			trace("No UP9K");
			FlxG.save.data.binds.up9KBind = "D";
		}
		if (FlxG.save.data.binds.right9KBind == null)
		{
			trace("No RIGHT9K");
			FlxG.save.data.binds.right9KBind = "F";
		}
		if (FlxG.save.data.binds.centerBind == null)
		{
			trace("No CENTER");
			FlxG.save.data.binds.centerBind = "SPACE";
		}
		if (FlxG.save.data.binds.altLeftBind == null)
		{
			trace("No ALTLEFT");
			FlxG.save.data.binds.altLeftBind = "J";
		}
		if (FlxG.save.data.binds.altDownBind == null)
		{
			trace("No ALTDOWN");
			FlxG.save.data.binds.altDownBind = "";
		}
		if (FlxG.save.data.binds.altUpBind == null)
		{
			trace("No ALTUP");
			FlxG.save.data.binds.altUpBind = "K";
		}
		if (FlxG.save.data.binds.altRightBind == null)
		{
			trace("No ALTRIGHT");
			FlxG.save.data.binds.altRightBind = "L";
		}

		if (FlxG.save.data.binds.gpleft9KBind == null)
		{
			trace("No gpLEFT9K");
			FlxG.save.data.binds.gpleft9KBind = "";
		}
		if (FlxG.save.data.binds.gpdown9KBind == null)
		{
			trace("No gpDOWN9K");
			FlxG.save.data.binds.gpdown9KBind = "";
		}
		if (FlxG.save.data.binds.gpup9KBind == null)
		{
			trace("No gpUP9K");
			FlxG.save.data.binds.gpup9KBind = "";
		}
		if (FlxG.save.data.binds.gpright9KBind == null)
		{
			trace("No gpRIGHT9K");
			FlxG.save.data.binds.gpright9KBind = "";
		}
		if (FlxG.save.data.binds.gpcenterBind == null)
		{
			trace("No gpCENTER");
			FlxG.save.data.binds.gpcenterBind = "";
		}
		if (FlxG.save.data.binds.gpaltLeftBind == null)
		{
			trace("No gpALTLEFT");
			FlxG.save.data.binds.gpaltLeftBind = "";
		}
		if (FlxG.save.data.binds.gpaltDownBind == null)
		{
			trace("No gpALTDOWN");
			FlxG.save.data.binds.gpaltDownBind = "";
		}
		if (FlxG.save.data.binds.gpaltUpBind == null)
		{
			trace("No gpALTUP");
			FlxG.save.data.binds.gpaltUpBind = "";
		}
		if (FlxG.save.data.binds.gpaltRightBind == null)
		{
			trace("No gpALTRIGHT");
			FlxG.save.data.binds.gpaltRightBind = "";
		}
	}

	override function update()
	{
		super.update();
	}

	function getActionFromCustomControl(control:CustomControl):FlxActionDigital
	{
		return switch (control)
		{
			case LEFT_9K: _left9K;
			case DOWN_9K: _down9K;
			case UP_9K: _up9K;
			case RIGHT_9K: _right9K;
			case CENTER_9K: _center9K;
			case LEFT_ALT_9K: _leftAlt9K;
			case DOWN_ALT_9K: _downAlt9K;
			case UP_ALT_9K: _upAlt9K;
			case RIGHT_ALT_9K: _rightAlt9K;
		}
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachCustomBound(control:CustomControl, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case LEFT_9K:
				func(_left9K, PRESSED);
				func(_left9KP, JUST_PRESSED);
				func(_left9KR, JUST_RELEASED);
			case DOWN_9K:
				func(_down9K, PRESSED);
				func(_down9KP, JUST_PRESSED);
				func(_down9KR, JUST_RELEASED);
			case UP_9K:
				func(_up9K, PRESSED);
				func(_up9KP, JUST_PRESSED);
				func(_up9KR, JUST_RELEASED);
			case RIGHT_9K:
				func(_right9K, PRESSED);
				func(_right9KP, JUST_PRESSED);
				func(_right9KR, JUST_RELEASED);
			case CENTER_9K:
				func(_center9K, PRESSED);
				func(_center9KP, JUST_PRESSED);
				func(_center9KR, JUST_RELEASED);
			case LEFT_ALT_9K:
				func(_leftAlt9K, PRESSED);
				func(_leftAlt9KP, JUST_PRESSED);
				func(_leftAlt9KR, JUST_RELEASED);
			case DOWN_ALT_9K:
				func(_downAlt9K, PRESSED);
				func(_downAlt9KP, JUST_PRESSED);
				func(_downAlt9KR, JUST_RELEASED);
			case UP_ALT_9K:
				func(_upAlt9K, PRESSED);
				func(_upAlt9KP, JUST_PRESSED);
				func(_upAlt9KR, JUST_RELEASED);
			case RIGHT_ALT_9K:
				func(_rightAlt9K, PRESSED);
				func(_rightAlt9KP, JUST_PRESSED);
				func(_rightAlt9KR, JUST_RELEASED);
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindCustomKeys(control:CustomControl, keys:Array<FlxKey>)
	{
		inline forEachCustomBound(control, (action, state) -> addCustomKeys(action, keys, state));
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindCustomKeys(control:CustomControl, keys:Array<FlxKey>)
	{
		inline forEachCustomBound(control, (action, _) -> removeCustomKeys(action, keys));
	}

	static function addCustomKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
		{
			action.addKey(key, state);
		}
	}

	static function removeCustomKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
			{
				action.remove(input);
			}
		}
	}

	public override function loadKeyBinds()
	{
		super.loadKeyBinds();

		trace('Double-checking advanced keybinds...');

		CustomControls.keyCheck();

		trace('Mapping advanced keybinds...');

		var buttons = new Map<CustomControl, Array<FlxGamepadInputID>>();

		// Gamepad bindings.
		buttons.set(CustomControl.LEFT_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpleft9KBind)]);
		buttons.set(CustomControl.DOWN_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpdown9KBind)]);
		buttons.set(CustomControl.UP_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpup9KBind)]);
		buttons.set(CustomControl.RIGHT_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpright9KBind)]);
		buttons.set(CustomControl.CENTER_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpcenterBind)]);
		buttons.set(CustomControl.LEFT_ALT_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpaltLeftBind)]);
		buttons.set(CustomControl.DOWN_ALT_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpaltDownBind)]);
		buttons.set(CustomControl.UP_ALT_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpaltUpBind)]);
		buttons.set(CustomControl.RIGHT_ALT_9K, [FlxGamepadInputID.fromString(FlxG.save.data.binds.gpaltRightBind)]);

		addGamepadCustom(0, buttons);

		// Keyboard bindings.
		inline bindCustomKeys(CustomControl.LEFT_9K, [FlxKey.fromString(FlxG.save.data.binds.left9KBind)]);
		inline bindCustomKeys(CustomControl.DOWN_9K, [FlxKey.fromString(FlxG.save.data.binds.down9KBind)]);
		inline bindCustomKeys(CustomControl.UP_9K, [FlxKey.fromString(FlxG.save.data.binds.up9KBind)]);
		inline bindCustomKeys(CustomControl.RIGHT_9K, [FlxKey.fromString(FlxG.save.data.binds.right9KBind)]);
		inline bindCustomKeys(CustomControl.CENTER_9K, [FlxKey.fromString(FlxG.save.data.binds.centerBind)]);
		inline bindCustomKeys(CustomControl.LEFT_ALT_9K, [FlxKey.fromString(FlxG.save.data.binds.altLeftBind)]);
		inline bindCustomKeys(CustomControl.DOWN_ALT_9K, [FlxKey.fromString(FlxG.save.data.binds.altDownBind)]);
		inline bindCustomKeys(CustomControl.UP_ALT_9K, [FlxKey.fromString(FlxG.save.data.binds.altUpBind)]);
		inline bindCustomKeys(CustomControl.RIGHT_ALT_9K, [FlxKey.fromString(FlxG.save.data.binds.altRightBind)]);
	}

	public function addGamepadCustom(id:Int, ?buttonMap:Map<CustomControl, Array<FlxGamepadInputID>>):Void
	{
		if (gamepadsAdded.contains(id))
			gamepadsAdded.remove(id);

		gamepadsAdded.push(id);

		for (control => buttons in buttonMap)
		{
			inline bindCustomButtons(control, id, buttons);
		}
	}

	inline function addGamepadCustomLiteral(id:Int, ?buttonMap:Map<CustomControl, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		for (control => buttons in buttonMap)
		{
			inline bindCustomButtons(control, id, buttons);
		}
	}

	public override function addDefaultGamepad(id):Void
	{
		// Call the base class.
		super.addDefaultGamepad(id);

		// Add our own controls.
		addGamepadCustomLiteral(id, [
			CustomControl.LEFT_9K => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			CustomControl.DOWN_9K => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			CustomControl.UP_9K => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			CustomControl.RIGHT_9K => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			CustomControl.CENTER_9K => [LEFT_TRIGGER_BUTTON, RIGHT_TRIGGER_BUTTON],
			CustomControl.LEFT_ALT_9K => [X],
			CustomControl.DOWN_ALT_9K => [A],
			CustomControl.UP_ALT_9K => [Y],
			CustomControl.RIGHT_ALT_9K => [B],
		]);
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindCustomButtons(control:CustomControl, id, buttons)
	{
		inline forEachCustomBound(control, (action, state) -> addCustomButtons(action, buttons, state, id));
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindCustomButtons(control:CustomControl, gamepadID:Int, buttons)
	{
		inline forEachCustomBound(control, (action, _) -> removeCustomButtons(action, gamepadID, buttons));
	}

	static inline function addCustomButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeCustomButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	/**
	 * @param list value is mutated
	 */
	public function getCustomInputsFor(control:CustomControl, device:Controls.Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Controls.Device.Keys:
				for (input in getActionFromCustomControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Controls.Device.Gamepad(id):
				for (input in getActionFromCustomControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	static inline function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}
}
