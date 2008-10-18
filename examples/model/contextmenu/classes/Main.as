package
{
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	
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
			mc.contextMenu=ml.getContextMenuById("menu1",onItemClick);
			addChild(mc);
		}
		
		private function onItemClick(e:ContextMenuEvent):void
		{
			trace("clicked");
		}	}}