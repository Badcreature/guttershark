package net.guttershark.ui.controls 
{
	import flash.display.Sprite;	
	
	/**
	 * The IToolTip interface is an interace sprites must
	 * conform too when implementing tool tips with the ToolTipManager.
	 * 
	 * <p>See the example in examples/tooltip/manager as well.</p>
	 * 
	 * @see net.guttershark.managers.ToolTipManager ToolTipManager class
	 */
	public interface IToolTip 
	{
		
		/**
		 * Sets the message for the tool tip.
		 */
		function set dataProvider(dp:IToolTipDataProvider):void;
		
		/**
		 * Show the tooltip.
		 * 
		 * @param	forSprite	A reference to the sprite the tooltooip is being shown for.
		 */
		function show(forSprite:Sprite):void;
		
		/**
		 * Move the tooltip. This is when the mouse is still within the target sprite and you
		 * want to move the tip instead of just closing it.
		 * 
		 * @param	forSprite	The sprite that the tooltip is currently being shown over.
		 * 
		 * @return	Boolean	Return false if you just want to close the tip on move.
		 */
		function move(forSprite:Sprite):Boolean;
		
		/**
		 * Hide the tool tip.
		 */
		function hide():void;
	}
}