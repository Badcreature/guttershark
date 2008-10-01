package 
{
	import flash.display.MovieClip;	
	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController
	{
		
		public var t:MovieClip;
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			t.visible = false;
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0xFF0066);
			mc.graphics.drawCircle(100,100,100);
			mc.graphics.endFill();
			addChild(mc);
			em.handleEvents(mc, this, "onMC");
		}
		
		public function onMCClick():void
		{
			t.visible = true;
		}	}}