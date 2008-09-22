package net.guttershark.display.views.forms
{
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import net.guttershark.display.views.CoreFormView;		

	/**
	 * The BaseErrorView class...
	 */
	public class BaseErrorView extends CoreFormView
	{
		
		public var errorMessage:TextField;

		/**
		 * Constructor for BaseErrorView instances.
		 */
		public function BaseErrorView()
		{
			super();
		}
		
		public function set message(str:String):void
		{
			if(!str) return;
			errorMessage.text = str;
		}
		
		override public function show():void
		{
			super.show();
			showError(true,2000);
		}
		
		public function showError(autoClose:Boolean,autoCloseTimeout:int=2000):void
		{
			super.show();
			if(autoClose && autoCloseTimeout) setTimeout(hide, autoCloseTimeout);
		}
	}
}
