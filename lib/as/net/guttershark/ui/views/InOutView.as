package net.guttershark.ui.views 
{
	
	/**
	 * The InOutView class is an AnimatedView with default
	 * functionality setup so that you can use a timeline
	 * to play forwards and backwards as the in and out of
	 * the view.
	 */
	public class InOutView extends AnimatedView
	{
		
		/**
		 * Constructor for InOutView instances.
		 */
		public function InOutView()
		{
			super();
			stop();
			watchForLastFrameAndCallComplete = true;
			autoStopOnLastFrame = true;
		}
		
		override public function show():void
		{
			play();
		}
		
		override public function hide():void
		{
			playReverse();
		}	}}