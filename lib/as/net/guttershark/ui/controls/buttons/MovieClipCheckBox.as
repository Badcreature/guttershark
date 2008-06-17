package net.guttershark.ui.controls.buttons
{
	
	import flash.events.MouseEvent;	
	import flash.events.Event;	

	import net.guttershark.sound.SoundManager;	
	import net.guttershark.ui.controls.buttons.MovieClipButton;
	
	/**
	 * The MovieClipCheckBox class is a basic checkbox that extends
	 * from MovieClipButton and adds more functionality to control
	 * the "checked" state with frames on the movie clip.
	 * 
	 * <p>Default frame states:</p>
	 * <ul>
	 * <li>1 = normal state</li>
	 * <li>2 = over state</li>
	 * <li>3 = checked normal state</li>
	 * <li>4 = checked over state</li>
	 * <li>5 = not checked locked frame.</li>
	 * <li>6 = checked locked frame.</li>
	 * </ul>
	 * 
	 * <p>There is also 1 sound property added.</p>
	 * <ul>
	 * <li>checkStateChangeSound</li>
	 * </ul>
	 * 
	 * <p>There is an example of this class in the examples/ui/controls/buttons folder.</p>
	 */
	public class MovieClipCheckBox extends MovieClipButton
	{
		
		/**
		 * The frame to go to for the out checked stat.
		 */
		public var normalCheckedFrame:int = 3;
		
		/**
		 * The frame to go to for the checked over state.
		 */
		public var overCheckedFrame:int = 4;
		
		/**
		 * The frame to go to when the button is locked but
		 * not currently checked.
		 */
		public var notCheckedLockedFrame:int = 5;
		
		/**
		 * The frame to go to when the button is locked and
		 * is currently checked.
		 */
		public var checkedLockedFrame:int = 6;
		
		/**
		 * Flag indicator for the checked state
		 */
		private var _checked:Boolean;
		
		/**
		 * The sound to play when a change to the check state
		 * happens. 
		 */
		public var checkStateChangeSound:String;
		
		/**
		 * Constructor for MovieClipCheckBox instances. Generally this class should be 
		 * bound to a movie clip in the library.
		 */
		public function MovieClipCheckBox(){}

		/**
		 * @private
		 * Overrides the super locked function and implements
		 * new logic that decides which frame to go to based
		 * off of the <code>checked</code> property.
		 */
		override public function set locked(value:Boolean):void
		{
			if(_locked && value) return;
			_locked = value;
			super.enabled = value;
			if(value)
			{
				if(lockSound) SoundManager.gi().playSound(lockSound);
				buttonMode = false;
				if(_checked) gotoAndStop(checkedLockedFrame);
				else gotoAndStop(notCheckedLockedFrame);
				dispatchEvent(new Event(MovieClipButton.LOCKED));
			}
			else
			{
				if(unlockSound) SoundManager.gi().playSound(unlockSound);
				buttonMode = true;
				if(_checked) gotoAndStop(normalCheckedFrame);
				else if(over) gotoAndStop(overFrame);
				else gotoAndStop(normalFrame);
				dispatchEvent(new Event(MovieClipButton.UNLOCKED));
			}
		}
		
		/**
		 * @private
		 * Overrides the onMouseOver for custom logic dealing with
		 * checked state.
		 */
		override protected function onMouseOver(me:MouseEvent):void
		{
			if(overSound) SoundManager.gi().playSound(overSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			over = true;
			if(_checked) gotoAndStop(overCheckedFrame);
			else gotoAndStop(overFrame);
		}

		/**
		 * @private
		 * Overrides the onMouseOver for custom logic dealing with
		 * checked state.
		 */
		override protected function onMouseUp(me:MouseEvent):void
		{
			if(upSound) SoundManager.gi().playSound(upSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			if(_checked && over) gotoAndStop(overCheckedFrame);
			else if(_checked) gotoAndStop(normalCheckedFrame);
			else if(!_checked && over) gotoAndStop(overFrame);
			else gotoAndStop(normalFrame);
			down = false;
		}
		
		/**
		 * @private
		 * When the mouse button is released outside of the clip. This is not supported in Flex.
		 */
		override protected function onMouseUpOutside(me:MouseEvent):void
		{
			if(!over)
			{
				me.stopPropagation();
				down = false;
				return;
			}
			if(upSound) SoundManager.gi().playSound(upSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			if(_checked) gotoAndStop(overCheckedFrame);
			else gotoAndStop(normalFrame);
			down = false;
		}
		
		/**
		 * @private
		 * Overrides the onMouseOver for custom logic dealing with
		 * checked state.
		 */
		override protected function onMouseOut(me:MouseEvent):void
		{
			if(outSound) SoundManager.gi().playSound(outSound);
			if(_locked)
			{
				if(_locked) me.stopImmediatePropagation();
				return;
			}
			over = false;
			if(_checked) gotoAndStop(normalCheckedFrame);
			else gotoAndStop(normalFrame);
		}

		/**
		 * @private
		 * Overrides the default super implementation to automatically
		 * toggle between the checked / (down|over|normal) frames.
		 */
		override protected function __onMouseDown(me:MouseEvent):void
		{
			if(_locked) return;
			this.checked = !this.checked;
			if(_checked) gotoAndStop(normalCheckedFrame);
			down = true;
		}

		/**
		 * Set the checked state of the button. Note that this is a 
		 * convenience method if you need to check this button through
		 * code. But by default "checked" toggling happens by default.
		 */
		public function set checked(state:Boolean):void
		{
			_checked = state;
			if(checkStateChangeSound) SoundManager.gi().playSound(checkStateChangeSound);
			gotoAndStop(normalCheckedFrame);
		}

		/**
		 * Read the checked state of the button.
		 */
		public function get checked():Boolean
		{
			return _checked;
		}
	}
}