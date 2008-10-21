package
{
	import flash.display.MovieClip;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.managers.ContextMenuManager;
	import net.guttershark.support.contextmenumanager.CContextMenuEvent;	

	public class Main extends DocumentController 
	{
		
		private var mc:MovieClip;

		public function Main()
		{
			super();
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
			addChild(mc);
			
			var cmm:ContextMenuManager = ContextMenuManager.gi();
			
			//use the cmm directly.
			//cmm.createMenu("menu1",[{id:"home",label:"home"},{id:"back",label:"GO BACK",sep:true}]);
			//mc.contextMenu=cmm.getMenu("menu1");
			
			//use model
			mc.contextMenu = ml.createContextMenuById("menu1");
			
			//events
			em.he(mc.contextMenu,this,"onCM");
		}
		
		public function onCMhome():void
		{
			trace("on home");
		}
		
		public function onCMback():void
		{
			trace("go back");
		}	}}