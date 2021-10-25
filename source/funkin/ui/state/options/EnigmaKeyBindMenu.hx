/*
 * GNU General Public License, Version 3.0
 *
 * Copyright (c) 2021 MasterEric
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * EnigmaKeyBindMenu.hx
 * The substate which overlays the screen when remapping special keybinds,
 * such as 9-key play binds.
 */
package funkin.ui.state.options;

import funkin.const.Enigma;
import funkin.behavior.options.PlayerSettings;
import funkin.util.assets.Paths;
import funkin.behavior.options.CustomControls;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import funkin.behavior.options.Options;
import funkin.behavior.options.Controls;
import funkin.behavior.options.CustomControls;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class EnigmaKeyBindMenu extends FlxSubState
{
	var keyTextDisplay:FlxText;
	var keyWarning:FlxText;
	var warningTween:FlxTween;

	static final keyText:Array<String> = [
		'LEFT',
		'DOWN',
		'UP',
		'RIGHT',
		'CENTER',
		'ALTLEFT',
		'ALTDOWN',
		'ALTUP',
		'ALTRIGHT'
	];
	static final defaultKeys:Array<String> = ['A', 'S', 'D', 'F', 'SPACE', 'J', 'K', 'L', ';'];
	static final defaultGpKeys:Array<String> = ['DPAD_LEFT', 'DPAD_DOWN', 'DPAD_UP', 'DPAD_RIGHT'];

	var curSelected:Int = 0;

	var keys:Array<String> = [
		FlxG.save.data.left9KBind,
		FlxG.save.data.down9KBind,
		FlxG.save.data.up9KBind,
		FlxG.save.data.right9KBind,
		FlxG.save.data.centerBind,
		FlxG.save.data.altLeftBind,
		FlxG.save.data.altDownBind,
		FlxG.save.data.altUpBind,
		FlxG.save.data.altRightBind
	];
	var gpKeys:Array<String> = [
		FlxG.save.data.gpleft9KBind,
		FlxG.save.data.gpdown9KBind,
		FlxG.save.data.gpup9KBind,
		FlxG.save.data.gpright9KBind,
		FlxG.save.data.gpcenterBind,
		FlxG.save.data.gpaltLeftBind,
		FlxG.save.data.gpaltDownBind,
		FlxG.save.data.gpaltUpBind,
		FlxG.save.data.gpaltRightBind
	];
	var tempKey:String = '';
	var blacklist:Array<String> = ['ESCAPE', 'ENTER', 'BACKSPACE', 'TAB'];

	var blackBox:FlxSprite;
	var infoText:FlxText;

	var state:String = 'select';

	/**
	 * This is normally keys9K - 1, but may be lower if some keys are hidden.
	 */
	var lastKeybindIndex = keyText.length;

	override function create()
	{
		while (!Enigma.SHOW_CUSTOM_KEYBINDS[lastKeybindIndex])
		{
			lastKeybindIndex -= 1;
		}

		// Fill in default keybindings.
		for (i in 0...keys.length)
		{
			var k = keys[i];
			if (k == null)
				keys[i] = defaultKeys[i];
		}

		// Fill in default gamepad keybindings.
		for (i in 0...gpKeys.length)
		{
			var k = gpKeys[i];
			if (k == null)
				gpKeys[i] = defaultGpKeys[i];
		}

		persistentUpdate = true;

		keyTextDisplay = new FlxText(-10, 0, 1280, '', 72);
		keyTextDisplay.scrollFactor.set(0, 0);
		keyTextDisplay.setFormat('VCR OSD Mono', 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		keyTextDisplay.borderSize = 2;
		keyTextDisplay.borderQuality = 3;

		blackBox = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackBox);

		infoText = new FlxText(-10, 580, 1280,
			'Current Mode: ${CustomControls.gamepad ? 'GAMEPAD' : 'KEYBOARD'}. Press TAB to switch\n(${CustomControls.gamepad ? 'RIGHT Trigger' : 'Escape'} to save, ${CustomControls.gamepad ? 'LEFT Trigger' : 'Backspace'} to leave without saving. ${CustomControls.gamepad ? 'START To change a keybind' : ''})',
			72);
		infoText.scrollFactor.set(0, 0);
		infoText.setFormat('VCR OSD Mono', 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 2;
		infoText.borderQuality = 3;
		infoText.alpha = 0;
		infoText.screenCenter(FlxAxes.X);
		add(infoText);
		add(keyTextDisplay);

		blackBox.alpha = 0;
		keyTextDisplay.alpha = 0;

		FlxTween.tween(keyTextDisplay, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(infoText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

		OptionsMenu.instance.acceptInput = false;

		textUpdate();

		super.create();
	}

	var frames = 0;

	override function update(elapsed:Float)
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (frames <= 10)
			frames++;

		infoText.text = 'Current Mode: ${CustomControls.gamepad ? 'GAMEPAD' : 'KEYBOARD'}. Press TAB to switch\n(${CustomControls.gamepad ? 'RIGHT Trigger' : 'Escape'} to save, ${CustomControls.gamepad ? 'LEFT Trigger' : 'Backspace'} to leave without saving. ${CustomControls.gamepad ? 'START To change a keybind' : ''})\n${lastKey != "" ? lastKey + " is blacklisted!" : ""}';

		switch (state)
		{
			case 'select':
				if (FlxG.keys.justPressed.UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (FlxG.keys.justPressed.TAB)
				{
					CustomControls.gamepad = !CustomControls.gamepad;
					textUpdate();
				}

				if (FlxG.keys.justPressed.ENTER)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					state = 'input';
				}
				else if (FlxG.keys.justPressed.ESCAPE)
				{
					quit();
				}
				else if (FlxG.keys.justPressed.BACKSPACE)
				{
					reset();
				}
				if (gamepad != null) // GP Logic
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(-1);
						textUpdate();
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(1);
						textUpdate();
					}

					if (gamepad.justPressed.START && frames > 10)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						state = 'input';
					}
					else if (gamepad.justPressed.LEFT_TRIGGER)
					{
						quit();
					}
					else if (gamepad.justPressed.RIGHT_TRIGGER)
					{
						reset();
					}
				}

			case 'input':
				if (CustomControls.gamepad)
				{
					tempKey = gpKeys[curSelected];
					gpKeys[curSelected] = '?';
				}
				else
				{
					tempKey = keys[curSelected];
					keys[curSelected] = '?';
				}
				textUpdate();
				state = 'waiting';

			case 'waiting':
				if (gamepad != null && CustomControls.gamepad) // GP Logic
				{
					if (FlxG.keys.justPressed.ESCAPE)
					{ // just in case you get stuck
						gpKeys[curSelected] = tempKey;
						state = 'select';
						FlxG.sound.play(Paths.sound('confirmMenu'));
					}

					if (gamepad.justPressed.START)
					{
						addKeyGamepad(defaultKeys[curSelected]);
						save();
						state = 'select';
					}

					if (gamepad.justPressed.ANY)
					{
						trace(gamepad.firstJustPressedID());
						addKeyGamepad(gamepad.firstJustPressedID());
						save();
						state = 'select';
						textUpdate();
					}
				}
				else
				{
					if (FlxG.keys.justPressed.ESCAPE)
					{
						keys[curSelected] = tempKey;
						state = 'select';
						FlxG.sound.play(Paths.sound('confirmMenu'));
					}
					else if (FlxG.keys.justPressed.ENTER)
					{
						addKey(defaultKeys[curSelected]);
						save();
						state = 'select';
					}
					else if (FlxG.keys.justPressed.ANY)
					{
						addKey(FlxG.keys.getIsDown()[0].ID.toString());
						save();
						state = 'select';
					}
				}

			case 'exiting':

			default:
				state = 'select';
		}

		if (FlxG.keys.justPressed.ANY)
			textUpdate();

		super.update(elapsed);
	}

	function textUpdate()
	{
		keyTextDisplay.text = '\n\n';

		if (CustomControls.gamepad)
		{
			for (i in 0...gpKeys.length)
			{
				if (!Enigma.SHOW_CUSTOM_KEYBINDS[i])
				{
					// Skip this keybind.
					continue;
				}

				var textStart = (i == curSelected) ? '> ' : '  ';
				keyTextDisplay.text += textStart + keyText[i] + ': ' + gpKeys[i] + '\n';
			}
		}
		else
		{
			for (i in 0...keys.length)
			{
				if (!Enigma.SHOW_CUSTOM_KEYBINDS[i])
				{
					// Skip this keybind.
					continue;
				}

				var textStart = (i == curSelected) ? '> ' : '  ';
				keyTextDisplay.text += textStart + keyText[i] + ': ' + ((keys[i] != keyText[i]) ? (keys[i] + ' / ') : '') + keyText[i] + ' ARROW\n';
			}
		}

		keyTextDisplay.screenCenter();
	}

	function save()
	{
		FlxG.save.data.left9KBind = keys[0];
		FlxG.save.data.down9KBind = keys[1];
		FlxG.save.data.up9KBind = keys[2];
		FlxG.save.data.right9KBind = keys[3];
		FlxG.save.data.centerBind = keys[4];
		FlxG.save.data.altLeftBind = keys[5];
		FlxG.save.data.altDownBind = keys[6];
		FlxG.save.data.altUpBind = keys[7];
		FlxG.save.data.altRightBind = keys[8];

		FlxG.save.data.gpleft9KBind = gpKeys[0];
		FlxG.save.data.gpdown9KBind = gpKeys[1];
		FlxG.save.data.gpup9KBind = gpKeys[2];
		FlxG.save.data.gpright9KBind = gpKeys[3];
		FlxG.save.data.gpcenterBind = gpKeys[4];
		FlxG.save.data.gpaltLeftBind = gpKeys[5];
		FlxG.save.data.gpaltDownBind = gpKeys[6];
		FlxG.save.data.gpaltUpBind = gpKeys[7];
		FlxG.save.data.gpaltRightBind = gpKeys[8];

		FlxG.save.flush();

		PlayerSettings.player1.controls.loadKeyBinds();
	}

	function reset()
	{
		for (i in 0...keys.length)
		{
			keys[i] = defaultKeys[i];
		}
		quit();
	}

	function quit()
	{
		state = 'exiting';

		save();

		OptionsMenu.instance.acceptInput = true;

		FlxTween.tween(keyTextDisplay, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0}, 1.1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween)
			{
				close();
			}
		});
		FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
	}

	function addKeyGamepad(r:String)
	{
		var shouldReturn:Bool = true;

		var notAllowed:Array<String> = ['START'];
		var swapKey:Int = -1;

		for (x in 0...gpKeys.length)
		{
			var oK = gpKeys[x];
			if (oK == r)
			{
				swapKey = x;
				gpKeys[x] = null;
			}
			if (notAllowed.contains(oK))
			{
				gpKeys[x] = null;
				lastKey = r;
				return;
			}
		}

		if (notAllowed.contains(r))
		{
			gpKeys[curSelected] = tempKey;
			lastKey = r;
			return;
		}

		if (shouldReturn)
		{
			if (swapKey != -1)
			{
				gpKeys[swapKey] = tempKey;
			}
			gpKeys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else
		{
			gpKeys[curSelected] = tempKey;
			lastKey = r;
		}
	}

	public var lastKey:String = '';

	function addKey(r:String)
	{
		var shouldReturn:Bool = true;

		var notAllowed:Array<String> = [];
		var swapKey:Int = -1;

		for (x in blacklist)
		{
			notAllowed.push(x);
		}

		trace(notAllowed);

		for (x in 0...keys.length)
		{
			var oK = keys[x];
			if (oK == r)
			{
				swapKey = x;
				keys[x] = null;
			}
			if (notAllowed.contains(oK))
			{
				keys[x] = null;
				lastKey = oK;
				return;
			}
		}

		if (notAllowed.contains(r))
		{
			keys[curSelected] = tempKey;
			lastKey = r;
			return;
		}

		lastKey = '';

		if (shouldReturn)
		{
			// Swap keys instead of setting the other one as null
			if (swapKey != -1)
			{
				keys[swapKey] = tempKey;
			}
			keys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else
		{
			keys[curSelected] = tempKey;
			lastKey = r;
		}
	}

	function changeItem(_amount:Int = 0)
	{
		curSelected += _amount;

		if (curSelected > lastKeybindIndex)
		{
			curSelected = 0;
		}
		if (curSelected < 0)
		{
			curSelected = lastKeybindIndex;
		}

		/**
		 * If this goes before the lastKeybindIndex calls,
		 * you get a stack overflow LOL.
		 */
		if (!Enigma.SHOW_CUSTOM_KEYBINDS[curSelected])
		{
			// Skip this keybind and move to the next one.
			// For example, if we hid the Center key, we'd go straight from index 3 to index 5 internally.
			changeItem(_amount);
		}
	}
}

