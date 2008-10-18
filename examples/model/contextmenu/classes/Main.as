package
{
	import flash.events.ContextMenuEvent;	
	import flash.ui.ContextMenu;	
	import flash.display.MovieClip;	
	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController 
	{
		
		private var mc:MovieClip;

		public function Main()
		{
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			mc = new MovieClip();
			mc.graphics.beginFill(0xff0066);
			mc.graphics.drawRect(0,0,100,15);
			mc.graphics.endFill();
			var cm:ContextMenu = ml.getContextMenuById("menu1",onItemClick);
			mc.contextMenu=cm;
			addChild(mc);
		}
		
		private function onItemClick(e:ContextMenuEvent):void
		{
			trace("clicked");
		}	}}