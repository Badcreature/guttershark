package net.guttershark.ui.controls 
{
	
	import net.guttershark.ui.controls.IToolTipDataProvider;

	/**
	 * The ToolTipDataProvider class is the base class for
	 * any tool tip data provider.
	 */
	public class ToolTipDataProvider implements IToolTipDataProvider
	{
		
		/**
		 * The message to show in a tool tip.
		 */
		public var message:String;

		/**
		 * Constructor for ToolTipDataProvider instances.
		 * 
		 * @param	message	The message to show in a tool tip.
		 */
		public function ToolTipDataProvider(message:String):void
		{
			this.message = message;
		}
	}
}
