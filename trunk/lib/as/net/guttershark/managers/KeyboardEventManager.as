package net.guttershark.managers 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.guttershark.util.Singleton;	

	/**
	 * The KeyboardEventManager class simplifies working with keyboard events.
	 * 
	 * @see KeyboardEventManager#addMapping() addMapping() method for an example.
	 */
	public class KeyboardEventManager
	{
			
		private static var inst:KeyboardEventManager;
		private var attemptedWordTimeout:Number;
		private var keyMappings:Dictionary;
		private var wordMappings:Dictionary;
		private var sequenceCallbacks:Dictionary;
		private var sequencesByScope:Dictionary;
		private var scopeToWordLookup:Dictionary;
		private var tmpDict:Dictionary;
		private var keysDown:String;
		private var mappingCountByScope:Dictionary;
		
		/**
		 * Singleton Instance.
		 */
		public static function gi():KeyboardEventManager
		{
			if(!inst) inst = Singleton.gi(KeyboardEventManager);
			return inst;
		}
		
		/**
		 * @private
		 * Constructor for KeyboardEventManager instances.
		 */
		public function KeyboardEventManager():void
		{
			Singleton.assertSingle(KeyboardEventManager);
			keyMappings = new Dictionary();
			wordMappings = new Dictionary();
			sequenceCallbacks = new Dictionary();
			scopeToWordLookup = new Dictionary();
			tmpDict = new Dictionary();
			sequencesByScope = new Dictionary();
			mappingCountByScope = new Dictionary();
			keysDown = "";
		}
		
		/**
		 * Add a keyboard event mapping.
		 * 
		 * <p>There are multiple ways you can add a handler. You can add
		 * handler for a single character, a word or sentence, or a sequence.</p>
		 * 
		 * @example Adding mappings of different types.
		 * <listing>	
		 * km = KeyboardEventManager.gi();
		 * km.addMapping(stage,"f", onF);
		 * km.addMapping(stage,"Whatup",onWhatup);
		 * km.addMapping(stage,"CONTROL+SHIFT+M", onM);
		 * km.addMapping(stage,"CONTROL+m",onM);
		 * km.addMapping(myTextField,"ENTER",onEnter);
		 * 
		 * private function onM():void
		 * {
		 *    trace("on control+shift+m");
		 * }
		 * 
		 * private function onF():void
		 * {
		 *    trace("on f");
		 * }
		 * 
		 * private function onWhatup():void
		 * {
		 *    trace("you typed 'Whatup'");
		 * }
		 * 
		 * private function onEnter():void
		 * {
		 *     trace("you pressed enter in the text field");
		 * }
		 * </listing>
		 * 
		 * <p><strong>Supported Key Shortcuts for Key Sequences</strong></p>
		 * <ul>
		 * <li>BACKSPACE</li>
		 * <li>CONTROL</li>
		 * <li>CAPSLOCK</li>
		 * <li>DELETE</li>
		 * <li>DOWN</li>
		 * <li>END</li>
		 * <li>ENTER</li>
		 * <li>ESC</li>
		 * <li>F1</li>
		 * <li>F2</li>
		 * <li>F3</li>
		 * <li>F4</li>
		 * <li>F5</li>
		 * <li>F6</li>
		 * <li>F7</li>
		 * <li>F8</li>
		 * <li>F9</li>
		 * <li>F10</li>
		 * <li>F11</li>
		 * <li>F12</li>
		 * <li>F13</li>
		 * <li>F14</li>
		 * <li>F15</li>
		 * <li>HOME</li>
		 * <li>INSERT</li>
		 * <li>LEFT</li>
		 * <li>PAGEDOWN</li>
		 * <li>PAGEUP</li>
		 * <li>RIGHT</li>
		 * <li>SHIFT</li>
		 * <li>SPACE</li>
		 * <li>TAB</li>
		 * <li>UP</li>
		 * <li>NUMPAD1</li>
		 * <li>NUMPAD2</li>
		 * <li>NUMPAD3</li>
		 * <li>NUMPAD4</li>
		 * <li>NUMPAD5</li>
		 * <li>NUMPAD6</li>
		 * <li>NUMPAD7</li>
		 * <li>NUMPAD8</li>
		 * <li>NUMPAD9</li>
		 * <li>NUMPAD0</li>
		 * <li>NUMPAD_ADD</li>
		 * <li>NUMPAD_DIVIDE</li>
		 * <li>NUMPAD_MULTIPLY</li>
		 * <li>NUMPAD_SUBTRACT</li>
		 * <li>NUMPAD_DECIMAL</li>
		 * <li>NUMPAD_ENTER</li>
		 * </ul>
		 * 
		 * @param	scope	The scope in which to add the keyboard events to.
		 * @param	mapping	The mapping to listen for.
		 * @param	callback	The callback function.
		 */
		public function addMapping(scope:*, mapping:String, callback:Function):void
		{
			if(mapping.length == 1) addCharMapping(scope,mapping,callback);
			else if(mapping.indexOf("+") > -1) addSequenceMapping(scope,mapping,callback);
			else if(isShortcutForKeycode(mapping)) addSequenceMapping(scope,mapping,callback);
			else addWordMapping(scope, mapping, callback);
		}
		
		/**
		 * Remove a keyboard event mapping.
		 * 
		 * @example Removing a keyboard event mapping.
		 * <listing>	
		 * var km:KeyboardEventManager = KeyboardEventManager.gi();
		 * km.addMapping(stage,"f",onF);
		 * km.removeMapping(stage,"f");
		 * </listing>
		 * 
		 * @param	scope	The scope - usually a DisplayObject or Stage.
		 * @param	mapping	The key event mapping being listened for.
		 */
		public function removeMapping(scope:*, mapping:String):void
		{
			if(mapping.length == 1) removeCharMapping(scope, mapping);
			else if(mapping.indexOf("+") > -1) removeSequenceMapping(scope, mapping);
			else if(isShortcutForKeycode(mapping)) removeSequenceMapping(scope,mapping);
			else removeWordMapping(scope, mapping);
		}
		
		/**
		 * Returns the shortcut string representation of a keyCode
		 */
		private function getShortcutForKey(keyCode:uint):String
		{
			var char:String = null;
			switch(keyCode)
			{
				case 0:
					break;
				case Keyboard.BACKSPACE:
					char = "BACKSPACE";
					break;
				case Keyboard.CONTROL:
					char = "CONTROL";
					break;
				case Keyboard.CAPS_LOCK:
					char = "CAPSLOCK";
					break;
				case Keyboard.DELETE:
					char = "DELETE";
					break;
				case Keyboard.DOWN:
					char = "DOWN";
					break;
				case Keyboard.END:
					char = "END";
					break;
				case Keyboard.ENTER:
					char = "ENTER";
					break;
				case Keyboard.ESCAPE:
					char = "ESC";
					break;
				case Keyboard.F1:
					char = "F1";
					break;
				case Keyboard.F2:
					char = "F2";
					break;
				case Keyboard.F3:
					char = "F3";
					break;
				case Keyboard.F4:
					char = "F4";
					break;
				case Keyboard.F5:
					char = "F5";
					break;
				case Keyboard.F6:
					char = "F6";
					break;
				case Keyboard.F7:
					char = "F7";
					break;
				case Keyboard.F8:
					char = "F8";
					break;
				case Keyboard.F9:
					char = "F9";
					break;
				case Keyboard.F10:
					char = "F10";
					break;
				case Keyboard.F11:
					char = "F11";
					break;
				case Keyboard.F12:
					char = "F12";
					break;
				case Keyboard.F13:
					char = "F13";
					break;
				case Keyboard.F14:
					char = "F14";
					break;
				case Keyboard.F15:
					char = "F15";
					break;
				case Keyboard.HOME:
					char = "HOME";
					break;
				case Keyboard.INSERT:
					char = "INSERT";
					break;
				case Keyboard.LEFT:
					char = "LEFT";
					break;
				case Keyboard.PAGE_DOWN:
					char = "PAGEDOWN";
					break;
				case Keyboard.PAGE_UP:
					char = "PAGEUP";
					break;
				case Keyboard.RIGHT:
					char = "RIGHT";
					break;
				case Keyboard.SHIFT:
					char = "SHIFT";
					break;
				case Keyboard.SPACE:
					char = "SPACE";
					break;
				case Keyboard.TAB:
					char = "TAB";
					break;
				case Keyboard.UP:
					char = "UP";
					break;
				case Keyboard.NUMPAD_1:
					char = "NUMPAD1";
					break;
				case Keyboard.NUMPAD_2:
					char = "NUMPAD2";
					break;
				case Keyboard.NUMPAD_3:
					char = "NUMPAD3";
					break;
				case Keyboard.NUMPAD_4:
					char = "NUMPAD4";
					break;
				case Keyboard.NUMPAD_5:
					char = "NUMPAD5";
					break;
				case Keyboard.NUMPAD_6:
					char = "NUMPAD6";
					break;
				case Keyboard.NUMPAD_7:
					char = "NUMPAD7";
					break;
				case Keyboard.NUMPAD_8:
					char = "NUMPAD8";
					break;
				case Keyboard.NUMPAD_9:
					char = "NUMPAD9";
					break;
				case Keyboard.NUMPAD_0:
					char = "NUMPAD0";
					break;
				case Keyboard.NUMPAD_ADD:
					char = "NUMPADADD";
					break;
				case Keyboard.NUMPAD_DECIMAL:
					char = "NUMPAD_DECIMAL";
					break;
				case Keyboard.NUMPAD_DIVIDE:
					char = "NUMPAD_DIVIDE";
					break;
				case Keyboard.NUMPAD_ENTER:
					char = "NUMPAD_ENTER";
					break;
				case Keyboard.NUMPAD_MULTIPLY:
					char = "NUMPAD_MULTIPLY";
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					char = "NUMPAD_SUBTRACT";
					break;
			}
			return char;
		}
		
		/**
		 * Test whether a string is a shortcut for a keycode.
		 */
		private function isShortcutForKeycode(mapping:String):Boolean
		{
			var keys:String = "BACKSPACE+CONTROL+CAPSLOCK+DELETE+DOWN+";
			keys += "END+ENTER+ESC+F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+";
			keys += "F13+F14+F15+HOME+INSERT+LEFT+PAGEDOWN+PAGEUP+RIGHT+SHIFT+SPACE+TAB+UP";
			keys += "NUMPAD0+NUMPAD1+NUMPAD2+NUMPAD3+NUMPAD4+NUMPAD5+NUMPAD6+NUMPAD7+NUMPAD8+NUMPAD9+";
			keys += "NUMPAD_ADD+NUMPAD_DECIMAL+NUMPAD_DIVIDE+NUMPAD_ENTER+NUMPAD_MULTIPLY+NUMPAD_SUBTRACT";
			if(keys.indexOf(mapping) > -1) return true;
			return false;
		}
		
		/**
		 * Add a callback mapping for a character.
		 * 
		 * @param	scope	The scope in which this keyboard event will be valid.
		 * @param	char	The character to listen for.
		 * @param	callback	The callback function.
		 */
		private function addCharMapping(scope:*, char:String, callback:Function):void
		{
			if(!keyMappings[scope])
			{
				scope.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
				keyMappings[scope] = new Dictionary();
			}
			keyMappings[scope][char.charCodeAt(0)] = callback;
			if(!mappingCountByScope[scope])
			{
				mappingCountByScope[scope] = new Dictionary();
				mappingCountByScope[scope]['char'] = 0;
			}
			mappingCountByScope[scope]['char']++;		
		}
		
		/**
		 * Add a callback mapping for a word.
		 * 
		 * @param	scope	The scope in which the key event should be listened for.
		 * @param	word	The word to listen for.
		 * @param	callback	The callback function.
		 */
		private function addWordMapping(scope:*, word:String, callback:Function):void
		{
			if(!wordMappings[scope]) wordMappings[scope] = new Dictionary();
			wordMappings[scope][word] = callback;
			scopeToWordLookup[scope] = word;
			scope.addEventListener(KeyboardEvent.KEY_UP,onKeyUpForWordMapping,false,0,true);
			if(!mappingCountByScope[scope])
			{
				mappingCountByScope[scope] = new Dictionary();
				mappingCountByScope[scope]['word'] = 0;
			}
			if(mappingCountByScope[scope]['word'] < 0) mappingCountByScope[scope]['word'] = 0;
			mappingCountByScope[scope]['word']++;
		}
		
		/**
		 * Add a mapping for a sequence of keys.
		 */
		private function addSequenceMapping(scope:*, sequence:String, callback:Function):void
		{
			if(!sequenceCallbacks[scope])
			{
				scope.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownForSequence);
				scope.addEventListener(KeyboardEvent.KEY_UP, onKeyUpForSequence);
				sequenceCallbacks[scope] = new Dictionary();
			}
			sequenceCallbacks[scope][sequence] = callback;
			if(!mappingCountByScope[scope])
			{
				mappingCountByScope[scope] = new Dictionary();
				mappingCountByScope[scope]['sequence'] = 0;
			}
			mappingCountByScope[scope]['sequence']++;
		}
		
		/**
		 * Remove a char mapping.
		 * @param	scope	The scope in which the char mapping was on.
		 * @param	char	The char that was being listened for.
		 */
		private function removeCharMapping(scope:*, char:String):void
		{
			if(!keyMappings[scope]) return;
			if(!keyMappings[scope][char]) return;
			keyMappings[scope][char] = null;
			if(mappingCountByScope[scope]['char'] > 0) mappingCountByScope[scope]['char']--;
			if(mappingCountByScope[scope]['char'] == 0) scope.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		/**
		 * Remove a word mapping.
		 * 
		 * @param	scope	The scope in which the keyboard event was added.
		 * @param	word	The word that was being listened for.
		 */
		private function removeWordMapping(scope:*, word:String):void
		{
			if(!wordMappings[scope]) return;
			if(!wordMappings[scope][word]) return;
			wordMappings[scope][word] = null;
			if(mappingCountByScope[scope]['word'] > 0) mappingCountByScope[scope]['word']--;
			if(mappingCountByScope[scope]['word'] == 0) scope.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpForWordMapping);
		}
		
		/**
		 * Remove sequence mappings.
		 */
		private function removeSequenceMapping(scope:*, mapping:String):void
		{
			sequenceCallbacks[scope][mapping] = null;
			if(mappingCountByScope[scope]['sequence'] > 0) mappingCountByScope[scope]['sequence']--;
			if(mappingCountByScope[scope]['sequence'] == 0)
			{
				scope.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpForSequence);
				scope.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownForSequence);
			}
		}
		
		/**
		 * On key up for char mapping listener.
		 */
		private function onKeyUp(ke:KeyboardEvent):void
		{
			var scope:* = ke.target;
			if(keyMappings[scope][ke.keyCode]) keyMappings[scope][ke.keyCode]();
			else if(keyMappings[scope][ke.charCode]) keyMappings[scope][ke.charCode]();
		}
		
		/**
		 * On key up for a word mapping listener.
		 */
		private function onKeyUpForWordMapping(ke:KeyboardEvent):void
		{
			if(ke.charCode == 0) return;
			var scope:* = ke.target;
			var word:String = scopeToWordLookup[scope];
			if(!word) return;
			if(!tmpDict[scope]) tmpDict[scope] = "";
			tmpDict[scope] += String.fromCharCode(ke.charCode);
			if(tmpDict[scope] == word)
			{
				wordMappings[scope][word]();
				tmpDict[scope] = "";
			}
			else if(tmpDict[scope].length >= word.length) tmpDict[scope] = "";
			clearTimeout(attemptedWordTimeout);
			attemptedWordTimeout = setTimeout(clearAttemptedWord,500,scope);
		}
		
		/**
		 * On key up for a key sequence mapping listener.
		 */
		private function onKeyUpForSequence(ke:KeyboardEvent):void
		{
			var char:String = getShortcutForKey(ke.keyCode);
			if(char == null) char = String.fromCharCode(ke.charCode);
			var test:String = char + "+";
			for(var i:int = 0; i < 4; i++) if(keysDown.indexOf(test) > -1) keysDown = keysDown.replace(test,"");
		}
		
		/**
		 * On key down logic for a key sequence mapping.
		 */
		private function onKeyDownForSequence(ke:KeyboardEvent):void
		{
			var scope:* = ke.target;
			if(!sequenceCallbacks[scope]) return;
			var char:String = getShortcutForKey(ke.keyCode);
			if(char == null) char = String.fromCharCode(ke.charCode);
			var c:String = char + "+";
			if(!keysDown) keysDown = "";
			if(keysDown.indexOf(c) > -1) return;
			keysDown += c;
			var m:String = keysDown.substring(0,keysDown.length - 1);
			if(!sequenceCallbacks[scope][m]) return;
			if(sequenceCallbacks[scope][m]) sequenceCallbacks[scope][m]();
		}
		
		/**
		 * Clears the attempted word for wordMapping
		 */
		private function clearAttemptedWord(scope:*):void
		{
			tmpDict[scope] = "";
		}
	}
}