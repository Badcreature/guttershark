package net.guttershark.managers 
{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;	
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	import net.guttershark.ui.controls.IToolTip;
	import net.guttershark.core.IDisposable;
	import net.guttershark.util.DisplayListUtils;
	import net.guttershark.ui.controls.IToolTipDataProvider;	
	
	/**
	 * The ToolTipManager class manages tooltips for any number of sprites
	 * that need tool tips associated with them.
	 * 
	 * @example Using the ToolTipManager:
	 * <listing>	
	 * //a display list sandbox where the tooltips get added and rendered in.
	 * var tooltipDisplaySandbox:Sprite = new Sprite();
	 * 
	 * //the tool tip manager.
	 * var manager:ToolTipManager = new ToolTipManager(tooltipDisplaySandbox,500); //the delay before calling show() for any tool tip.
	 * 
	 * //an instance of the tool tip we want to use
	 * var myToolTip:ToolTip1 = Library.GetMovieClip("MyToolTipTest") as ToolTip1; //That movie clip would implement the IToolTip class.
	 * 
	 * //data providers for 2 different sets of data for any tool tip.
	 * var myTTDataProvider = new ToolTipDataProvider("My Tooltip Message"); //A data provider to provide to the tool top just before it's shown.
	 * var my2TTDataProvider = new ToolTipDataProvider("My Other Tooltip Message"); //A data provider to provide to the tool top just before it's shown. 
	 * 
	 * //the buttons we want tool tips on.
	 * var myButton:Button = new Button(); //the button we want a tool tip on.
	 * var myOtherButton:Button = new Button(); //another button we want a tool tip on.
	 * myButton.label = "Word Up";
	 * myOtherButton.label = "Other button";
	 * 
	 * addChild(myButton);
	 * addChild(myOtherButton);
	 * addChild(tooltipDisplaySandbox);
	 * 
	 * //associate the tips with these buttons
	 * manager.addToolTip(myButton, myToolTip, myTTDataProvider);
	 * manager.addToolTip(myOtherButton, myToolTip, my2TTDataProvider);
	 * </listing>
	 * 
	 * <p>You should use the same instance of a tool tip for any sprite that
	 * is going to display the same style of tool tip.</p>
	 * 
	 * <p>Your tooltips need to implement IToolTip. So they conform to 
	 * methods that are called on each tool tip.</p>
	 * 
	 * <p>Tool tip data providers are used specifically for polymorphism with the
	 * the ToolTipManager so that you could potentially provide other data with
	 * the payload that's set on your tool tip instance. Like icons, colors, or
	 * other custom things. You would extend ToolTipDataProvider</p>
	 * 
	 * <p>Tool tip data providers need to implement the IToolTipDataProvider
	 * interface for plymorphism against your tool tips "set dataProvider"
	 * setter method</p>
	 * 
	 * <p>See the example in examples/tooltip/manager folder for a complete
	 * working example.</p>
	 * 
	 * @see net.guttershark.ui.controls.IToolTip IToolTip interface
	 * @see net.guttershark.ui.controls.IToolTipDataProvider IToolTipDataProvider interface
	 * @see net.guttershark.ui.controls.ToolTipDataProvider ToolTipDataProvider class
	 */
	public class ToolTipManager implements IDisposable 
	{
		
		/**
		 * Tool tips by sprite.
		 */
		private var registeredToolTips:Dictionary;
		
		/**
		 * Messages by sprite and renderer.
		 */
		private var dpsBySpriteAndRenderer:Dictionary;
		
		/**
		 * The show interval.
		 */
		private var showHideInterval:int;
		
		/**
		 * The show timeout used to call the show.
		 */
		private var showTimeout:Number;
		
		/**
		 * The timeout to wait before cleaning the display list.
		 */
		private var cleanDisplayListTimeout:Number;
		
		/**
		 * A render sandbox where all tooltips get rendered into.
		 */
		private var renderSandbox:Sprite;
		
		/**
		 * A flag used for tool tip shown status.
		 */
		private var toolTipShown:Boolean;
		
		/**
		 * Constructor for ToolTipManager instances.
		 * 
		 * @param toolTipDisplayListSandbox	The sandbox sprite where all tooltips get rendered into.
		 * @param showHideInterval	The interval to wait for before calling show() on the IToolTip.
		 */
		public function ToolTipManager(toolTipDisplayListSandbox:Sprite, showHideInterval:int):void
		{
			renderSandbox = toolTipDisplayListSandbox;
			registeredToolTips = new Dictionary();
			dpsBySpriteAndRenderer = new Dictionary();
			this.showHideInterval = showHideInterval;
		}

		/**
		 * Register (associate) a tool tip with a display object.
		 * 
		 * @param	scope	The display object that should be associated with the tool tip.
		 * @param	renderer	An IToolTip instance.
		 * @param	dataProvider	An IToolTipDataProvider, that get's updated on the tool tip right before it's shown.
		 */
		public function addToolTip(forSprite:Sprite, withRenderer:IToolTip, dataProvider:IToolTipDataProvider):void
		{
			registeredToolTips[forSprite] = withRenderer;
			if(!dpsBySpriteAndRenderer[forSprite]) dpsBySpriteAndRenderer[forSprite] = new Dictionary();
			dpsBySpriteAndRenderer[forSprite][withRenderer] = dataProvider;
			forSprite.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			forSprite.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			forSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			forSprite.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		/**
		 * On mouse over of a scope.
		 */
		private function onMouseOver(me:MouseEvent):void
		{
			clearTimeout(cleanDisplayListTimeout);
			var scope:DisplayObject = DisplayObject(me.target);
			var tooltip:IToolTip = registeredToolTips[scope] as IToolTip;
			var dp:IToolTipDataProvider = dpsBySpriteAndRenderer[scope][tooltip];
			showTimeout = setTimeout(showToolTip, showHideInterval,scope,tooltip,dp);
			clearTimeout(cleanDisplayListTimeout);
		}
		
		/**
		 * Shows the tool tip.
		 */
		private function showToolTip(scope:Sprite, tooltip:*, dp:IToolTipDataProvider):void
		{
			tooltip.visible = false;
			renderSandbox.addChild(tooltip);
			tooltip.dataProvider = dp;
			tooltip.show(scope);
			toolTipShown = true;
		}

		/**
		 * on mouse down of the sprite scope.
		 */
		private function onMouseDown(me:MouseEvent):void
		{
			clearTimeout(showTimeout);
			clearTimeout(cleanDisplayListTimeout);
			var scope:Sprite = Sprite(me.target);
			var tooltip:IToolTip = registeredToolTips[scope] as IToolTip;
			toolTipShown = false;
			tooltip.hide();
			cleanDisplayListTimeout = setTimeout(cleanupDisplayList, 3000);
		}
		
		/**
		 * On mouse out of sprite scope.
		 */
		private function onMouseOut(me:MouseEvent):void
		{
			clearTimeout(showTimeout);
			clearTimeout(cleanDisplayListTimeout);
			var scope:Sprite = Sprite(me.target);
			var tooltip:IToolTip = registeredToolTips[scope] as IToolTip;
			toolTipShown = false;
			tooltip.hide();
			cleanDisplayListTimeout = setTimeout(cleanupDisplayList, 3000);
		}
		
		/**
		 * On mouse move of the sprite scope.
		 */
		private function onMouseMove(me:MouseEvent):void
		{
			if(!toolTipShown) return;
			var scope:Sprite = Sprite(me.target);
			var tooltip:IToolTip = registeredToolTips[scope] as IToolTip;
			if(!tooltip.move(scope))
			{
				tooltip.hide();
			}
		}
		
		/**
		 * Cleans up the sandbox display list.
		 */
		private function cleanupDisplayList():void
		{
			DisplayListUtils.RemoveAllChildren(renderSandbox);
		}

		/**
		 * Dispose of this tool tip managers' internal data.
		 */
		public function dispose():void
		{
			for(var key:* in registeredToolTips)
			{
				registeredToolTips[key].removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				registeredToolTips[key].removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if(registeredToolTips[key].stage) registeredToolTips[key].stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			registeredToolTips = new Dictionary(false);
		}
	}
}
