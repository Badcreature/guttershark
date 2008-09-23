package net.guttershark.display.views
{
	import flash.utils.setTimeout;		

	/**
	 * The BaseErrorView class provides some default functionality
	 * that might want to be used for an "error" view of a form.
	 */
	public class BaseErrorView extends BaseFormView
	{
		
		/**
		 * Constructor for BaseErrorView instances.
		 */
		public function BaseErrorView()
		{
			super();
		}
		
		/**
		 * A set method you should override when needing to
		 * set some kind of error message.
		 */
		public function set message(str:String):void{}
		
		/**
		 * This is an alternative to the default method (show), which
		 * can optionally autoHide this error view, after a specified amount
		 * of time.
		 * 
		 * @param autoHide Whether or not to auto close this error after n time.
		 * @param autoHideTimeout The time the error view is shown before it auto hides.
		 */
		public function showAndHide(autoHideTimeout:int=2000):void
		{
			super.show();
			setTimeout(hide,autoHideTimeout);
		}
	}
}
