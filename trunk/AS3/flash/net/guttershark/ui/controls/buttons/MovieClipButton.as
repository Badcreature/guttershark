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
	 * <p>This class also has Sound support. For each of the button states.
	 * overSound and the rest of the sound properties.</p>
	 * 
	 * Default frame states:
	 * 1 = normal state
	 * 2 = over state
	 * 3 = down state
	 * 4 = locked frame (if .lockable == true)
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
		 * Flag for sound enable
		 */
		protected var _soundEnabled:Boolean;
		
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
		
		//some flag vars for state
		private var over:Boolean = false;
		private var down:Boolean = false;
		private var _locked:Boolean = false;
		
		/**
		 * Creates a new MovieClipButton, but generally you want to 
		 * bind this class to a movie clip in the library.
		 */
		public function MovieClipButton()
		{
			super();
			stop();
			if(this.stage) //for flash. .. stage doesnt exist in flex.
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOutside);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		/**
		 * When the mouse button is released outside of the clip.
		 * Right now this only works with Flash. Not flex.
		 */
		protected function onMouseUpOutside(me:MouseEvent):void
		{
			if(_soundEnabled)
			{
				if(upSound)
				{
					try
					{
						SoundManager.GetInstance().playSound(upSound);	
					}
					catch(e:*){}
				}
			}
			if(_locked) return;
			if(over) gotoAndStop(overFrame);
			else if(down) gotoAndStop(normalFrame);
			down = false;
		}
		
		/**
		 * When the mouse button is released.
		 */
		protected function onMouseUp(me:MouseEvent):void
		{
			if(_soundEnabled)
			{
				if(upSound)
				{
					try
					{
						SoundManager.GetInstance().playSound(upSound);	
					}
					catch(e:*){}
				}
			}
			if(_locked) return;
			gotoAndStop(normalFrame);
		}
		
		/**
		 * When the mouse rolls over this button.
		 */
		protected function onMouseOver(me:MouseEvent):void
		{
			if(_soundEnabled)
			{
				if(overSound)
				{
					try
					{
						SoundManager.GetInstance().playSound(overSound);	
					}
					catch(e:*){}
				}
			}
			
			if(_locked) return;
			over = true;
			gotoAndStop(overFrame);
		}
		
		/**
		 * When the mouse is pressed down over this button.
		 */
		protected function onMouseDown(me:MouseEvent):void
		{
			if(_soundEnabled)
			{
				if(downSound)
				{
					try
					{
						SoundManager.GetInstance().playSound(downSound);	
					}
					catch(e:*)
					{
						trace(e);
					}
				}
			}	
			
			if(_locked) return;
			down = true;
			gotoAndStop(downFrame);
		}
		
		/**
		 * Overrides the dispatchEvent function to cancel events sent out of
		 * the button is not enabled.
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			if(locked) return false;
			return super.dispatchEvent(event);
		}
		
		/**
		 * When the mouse moves outside the trackable content.
		 */
		protected function onMouseOut(me:MouseEvent):void
		{
			if(_soundEnabled)
			{
				if(outSound)
				{
					try
					{
						SoundManager.GetInstance().playSound(outSound);	
					}
					catch(e:*){}
				}
			}
			
			if(_locked) return;
			over = false;
			gotoAndStop(normalFrame);
		}
		
		/**
		 * Toggle the lock state of the button.
		 */
		public function set locked(value:Boolean):void
		{
			_locked = value;
			super.enabled = value;
			if(value)
			{
				locked = true;
				if(_soundEnabled)
				{
					if(lockSound)
					{
						try
						{
							SoundManager.GetInstance().playSound(lockSound);	
						}
						catch(error:*){}
					}
				}
				buttonMode = false;
				gotoAndStop(lockedFrame);
				dispatchEvent(new Event(MovieClipButton.LOCKED));
			}
			else
			{
				if(_soundEnabled)
				{
					if(unlockSound)
					{
						try
						{
							SoundManager.GetInstance().playSound(unlockSound);	
						}
						catch(e:*){}
					}
				}
				buttonMode = true;
				gotoAndStop(normalFrame);
				dispatchEvent(new Event(MovieClipButton.UNLOCKED));
			}
		}
		
		/**
		 * Read the locked state of the button.
		 */
		public function get locked():Boolean
		{
			return _locked;
		}
		
		/**
		 * Toggle sound enable.
		 */
		public function set soundEnabled(value:Boolean):void
		{
			_soundEnabled = value;
		}
	}
}