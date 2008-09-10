package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.guttershark.managers.EventManager;	

	public class Main extends Sprite
	{
		
		private var em:EventManager;
		private var mc:MovieClip;

		public function Main()
		{
			super();
			mc = new MovieClip();
			mc.graphics.beginFill(0xFF0066);
			mc.graphics.drawCircle(200, 200, 100);
			mc.graphics.endFill();
			em = EventManager.gi();
			em.handleEvents(mc, this, "onClip");
			addChild(mc);
		}
		
		public function onClipMouseOut():void
		{
			trace("mouse over");
		}
		
		public function onClipAddedToStage():void
		{
			trace("added to stage");
		}
		
		public function onClipMouseOver():void
		{
			trace("over");
		}
		
		public function onClipClick():void
		{
			trace("circle click");
		}	}}