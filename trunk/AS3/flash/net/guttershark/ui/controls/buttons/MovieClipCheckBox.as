package net.guttershark.ui.controls.buttons
{
	
	import net.guttershark.sound.SoundManager;	
	import net.guttershark.ui.controls.buttons.MovieClipButton;
	
	/**
	 * The MovieClipCheckBox is a basic checkbox that extends
	 * from MovieClipButton and adds more functionality to control
	 * the "checked" state with frames on the movie clip.
	 * 
	 * Default frame states:
	 * 1 = normal state
	 * 2 = over state
	 * 3 = down state
	 * 4 = checked state
	 * 5 = locked frame (if .lockable == true)
	 */
	public class MovieClipCheckBox extends MovieClipButton
	{
		
		/**
		 * The frame to go to for a "checked" state
		 */
		private var checkedFrame:int = 4;
		
		/**
		 * Flag indicator for the checked state
		 */
		private var _checked:Boolean;
		
		/**
		 * The sound to play when a change to the check state
		 * happens. 
		 */
		public var checkChangeSound:String;
		
		/**
		 * New MovieClipCheckBox. This class generally should be 
		 * bound to a movie clip in the library.
		 */
		public function MovieClipCheckBox()
		{
			lockedFrame = 5;
		}
		
		/**
		 * Set the checked state of the button.
		 */
		public function set checked(state:Boolean):void
		{
			_checked = state;
			if(_soundEnabled)
			{
				if(checkChangeSound)
				{
					SoundManager.GetInstance().playSound(checkChangeSound);
				}
			}
			gotoAndStop(checkedFrame);
		}

		/**
		 * Read the checked state of the button.
		 */
		public function get checked():Boolean
		{
			return super.enabled;
		}
	}
}