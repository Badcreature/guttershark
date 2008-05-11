package net.guttershark.managers 
{
	
	import flash.display.DisplayObject;	
	import flash.display.Stage;	
	import flash.events.KeyboardEvent;	
	import flash.utils.Dictionary;
	
	import net.guttershark.core.IDisposable;
	
	/**
	 * The KeyboardEventManager class simplifies working with keyboard events,
	 * and scoping of the events. By wrapping logic for handling the events
	 * for you, as well as providing a way to set the scope in which a keyboard
	 * event is called back to your handler function.
	 * 
	 * <p>The KeyboardEventManager is integrated into the base 
	 * DocumentController of the net.guttershark package.</p>
	 * 
	 * @example Accessing the KeyboardEventManager on the DocumentController instance.
	 * <listing>	
	 * DocumentController.Instance.keyboardEventManager.addKeyEventMapping(this,Keyboard.ENTER,onEnter);
	 * </listing>
	 * 
	 * <p>However, if you need to use this with some flash site that isn't
	 * using the DocumentController, here's how you would do so:</p>
	 * @example Using the KeyEventManager:
	 * <listing>	
	 * var km:KeyboardEventManager = new KeyboardEventManager(this.stage);
	 * var mc1:MovieClip = new MovieClip();
	 * var mc2:MovieClip = new MovieClip();
	 * addChild(mc1);
	 * addChild(mc2);
	 * km.addKeyMapping(mc,Keyboard.SPACE, onSpaceInsideMC1);
	 * km.addKeyMapping(mc2,Keyboard.SPACE, onSpaceInsideMC2);
	 * km.scope = mc2;
	 * </listing>
	 * 
	 * <p>In the above example, because <code>km.scope = mc2;</code> is called,
	 * the only keyboard events that will fire are the ones that were registered
	 * for mc2 as the scope object. So in this case, the handler that
	 * would execute after a space bar was pressed would be onSpaceInsideMC2.</p>
	 */
	public class KeyboardEventManager implements IDisposable
	{
		
		/**
		 * The current mappings registered.
		 */
		private var mappings:Dictionary;
		
		/**
		 * The current scope.
		 */
		private var currentScope:DisplayObject;
		
		/**
		 * The main stage object.
		 */
		private var stage:Stage;
		
		/**
		 * Constructor for KeyboardEventManager instances.
		 * 
		 * @param	stage	The main stage.
		 */
		public function KeyboardEventManager(stage:Stage):void
		{
			mappings = new Dictionary();
			this.stage = stage;
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 11, true);
		}
		
		/**
		 * Add a key event mapping.
		 * 
		 * @param	scope	The scope in which this keyboard event will be valid.
		 * @param	keyCode	The key code.
		 * @param	callback	The callback function to call when neccessary.
		 */
		public function addKeyMapping(scope:*, keyCode:uint, callback:Function):void
		{
			if(!mappings[scope]) mappings[scope] = new Dictionary();
			mappings[scope][keyCode] = callback;
		}
		
		/**
		 * Remove a previously added key mapping.
		 * 
		 * @param	scope	The scope in which the keyboard event was added.
		 * @param	keyCode	The key code.
		 */
		public function removeKeyMapping(scope:*, keyCode:uint):void
		{
			if(!mappings[scope]) return;
			if(!mappings[scope][keyCode]) return;
			mappings[scope][keyCode] = null;
		}
		
		/**
		 * Set the scope in which keyboard events are valid.
		 */
		public function set scope(scope:*):void
		{
			currentScope = scope;
		}
		
		/**
		 * The scope in which the keyboard events respond to.
		 */
		public function get scope():*
		{
			return currentScope;
		}
		
		/**
		 * Dispose of this keyboard event manager.
		 */
		public function dispose():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			mappings = null;
		}
		
		/**
		 * Handler for key ups.
		 */
		private function onKeyUp(ke:KeyboardEvent):void
		{
			ke.stopPropagation();
			if(!currentScope) return;
			if(!mappings[currentScope]) return;
			if(!mappings[currentScope][ke.keyCode]) return;
			if(mappings[currentScope][ke.keyCode]) mappings[currentScope][ke.keyCode]();
		}
	}
}