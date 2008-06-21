package 
{
	import net.guttershark.events.delegates.components.FLVPlaybackEventListenerDelegate;	
	
	import fl.video.FLVPlayback;	

	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import net.guttershark.events.EventTypes;
	import net.guttershark.events.EventManager;
	
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
			em.handleEvents(mc, this, "onMC", EventTypes.STAGE | EventTypes.MOUSE, false, true);
			
			addChild(mc);
			stage.focus = mc;
		}

		public function cKeyDown(ke:KeyboardEvent)
		{
			trace("key down");
		}
		
		public function test():void
		{
			trace("word");
		}

		public function onStageKeyDown(ke:KeyboardEvent):void
		{
			trace(ke.keyCode);
			trace("s key down");
		}
		
		public function onMCMouseOver():void
		{
			//trace("mouse move");
		}
		
		public function cAddedToStage():void
		{
			trace("added to stage");
		}
		
		public function cMouseOver():void
		{
			trace("over");
		}
		
		public function cClick():void
		{
			trace("circle click");
		}	}}