package net.guttershark.ui.controls.buttons
{

	import flash.display.MovieClip;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.guttershark.sound.SoundManager;

	/**
	 * The MovieClipButton class is a generic class you can bind
	 * any movie clip to in the Library, and get canned button states.
	 * 
	 * <p>A frame in the movie clip represents a state that the button
	 * is in.</p>
	 * 
	 * <p>Default frame states:</p>
	 * <ul>
	 * <li>1 = normal state</li>
	 * <li>2 = over state</li>
	 * <li>3 = down state</li>
	 * <li>4 = locked frame. Toggle the lock state by setting the <code>locked</code> property.</li>
	 * </ul>
	 * 
	 * <p>Sound support is also available for each of the button states.</p>
	 *  
	 * <p>Sound Properties</p>
	 * <ul>
	 * <li>overSound</li>
	 * <li>downSound</li>
	 * <li>upSound</li>
	 * <li>outSound</li>
	 * <li>lockedSound</li>
	 * <li>unlockedSound</li>
	 * </ul>
	 * 
	 * <p>This class also uses high priority event listeners for mouse events.
	 * When you set the <code>locked</code> property, all MouseEvents will <strong>not</strong>
	 * be dispatched. If you absolutely need mouse events even though the button is locked,
	 * you can add an event listener with a higher priority than 10.</p>
	 */
	public class MovieClipButton extends MovieClip
	{

		/**
		 * Event identifier for the unlocked state
		 */
		public static const UNLOCKED:String = "unlocked";
		
		/**
		 * Event identifier for the locked state
		 */
		public static const LOCKED:String = "locked";
			
		/**
		 * The frame to go to for the normal state.
		 */
		public var normalFrame:int = 1;
		
		/**
		 * The frame to go to for the over state.
		 */
		public var overFrame:int = 2;
		
		/**
		 * The frame to go to for the down state.
		 */
		public var downFrame:int = 3;
		
		/**
		 * The frame to go to for the (optional)
		 * locked state.
		 */
		public var lockedFrame:int = 4;
		
		/**
		 * The over sound to play. The SoundManager class
		 * is used internally here, so that sound should have been
		 * registered with the SoundManager previously.
		 */
		public var overSound:String;
		
		/**
		 * The out sound to play. The SoundManager class
		 * is used internally here, so that sound should have been
		 * registered with the SoundManager previously.
		 */
		public var outSound:String;
		
		/**
		 * The down sound to play. The SoundManager class
		 * is used internally here, so that sound should have been
		 * registered with the SoundManager previously.
		 */
		public var downSound:String;
		
		/**
		 * The up sound to play. The SoundManager class
		 * is used internally here, so that sound should have been
		 * registered with the SoundManager previously.
		 */
		public var upSound:String;
		
		/**
		 * The sound to play when this button is locked. The SoundManager class
		 * is used internally here, so that sound should have been
		 * registered with the SoundManager previously.
		 */
		public var lockSound:String;
		
		/**
		 * The sound to play when this movie clip is unlocked. The SoundManager class
		 * is used internally here, so that sound should have been
		 * registered with the SoundManager previously.
		 */
		public var unlockSound:String;
		
		/**
		 * Set whether or not this button is lockable.
		 * If so, it uses the lockedFrame when enabled
		 * is set to false.
		 */
		public var lockable:Boolean = false;
		
		/**
		 * @private
		 */
		protected var over:Boolean = false;
		
		/**
		 * @private
		 */
		protected var down:Boolean = false;
		
		/**
		 * @private
		 */
		protected var _locked:Boolean = false;
		
		/**
		 * Constructor for MovieClipButton instances. Generally you want to 
		 * bind this class to a movie clip in the library.
		 */
		public function MovieClipButton()
		{
			super();
			stop();
			if(this.stage) this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOutside,false,10,false);
			addEventListener(MouseEvent.CLICK,onClick,false,10,false);
			addEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown,false,10,false);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver,false,10,false);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,10,false);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut,false,10,false);
		}
		
		/**
		 * @private
		 * on click handler.
		 */
		protected function onClick(me:MouseEvent):void
		{
			if(_locked) me.stopImmediatePropagation();
		}
		
		/**
		 * @private
		 * When the mouse button is released outside of the clip. This is not supported in Flex.
		 */
		protected function onMouseUpOutside(me:MouseEvent):void
		{
			if(!over)
			{
				me.stopPropagation();
				down = false;
				return;
			}
			if(upSound) SoundManager.GetInstance().playSound(upSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			if(over) gotoAndStop(overFrame);
			else if(down) gotoAndStop(normalFrame);
			down = false;
		}
		
		/**
		 * @private
		 * When the mouse button is released.
		 */
		protected function onMouseUp(me:MouseEvent):void
		{
			if(upSound) SoundManager.GetInstance().playSound(upSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			gotoAndStop(normalFrame);
		}
		
		/**
		 * @private
		 * When the mouse rolls over this button.
		 */
		protected function onMouseOver(me:MouseEvent):void
		{
			if(overSound) SoundManager.GetInstance().playSound(overSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			over = true;
			gotoAndStop(overFrame);
		}
		
		/**
		 * @private
		 * When the mouse is pressed down over this button.
		 */
		protected function __onMouseDown(me:MouseEvent):void
		{
			if(downSound) SoundManager.GetInstance().playSound(downSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			down = true;
			gotoAndStop(downFrame);
		}
		
		/**
		 * @private
		 * When the mouse moves outside the trackable content.
		 */
		protected function onMouseOut(me:MouseEvent):void
		{
			if(outSound) SoundManager.GetInstance().playSound(outSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			over = false;
			gotoAndStop(normalFrame);
		}
		
		/**
		 * Toggle the lock state of the button.
		 */
		public function set locked(value:Boolean):void
		{
			if(_locked && value) return;
			_locked = value;
			super.enabled = value;
			if(value)
			{
				if(lockSound) SoundManager.GetInstance().playSound(lockSound);
				buttonMode = false;
				gotoAndStop(lockedFrame);
				dispatchEvent(new Event(MovieClipButton.LOCKED));
			}
			else
			{
				if(unlockSound) SoundManager.GetInstance().playSound(unlockSound);
				buttonMode = true;
				if(down) gotoAndStop(downFrame);
				else if(over) gotoAndStop(overFrame);
				else gotoAndStop(normalFrame);
				dispatchEvent(new Event(MovieClipButton.UNLOCKED));
			}
		}
		
		/**
		 * Lock or unlock the button.
		 */
		public function get locked():Boolean
		{
			return _locked;
		}
	}
}