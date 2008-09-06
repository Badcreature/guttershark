package  
{
	import net.guttershark.events.EventManager;
	import net.guttershark.sound.SoundManager;
	import net.guttershark.ui.controls.buttons.MovieClipButton;
	import net.guttershark.ui.views.InOutView;
	import net.guttershark.util.FrameDelay;import flash.utils.setTimeout;import flash.utils.clearTimeout;	

	public class ZoomView extends InOutView
	{
		
		private var sm:SoundManager;
		private var em:EventManager;
		public var close:MovieClipButton;
		public var loopSound:String;
		public var playInZoom:Boolean;
		public var playOutZoom:Boolean;
		public var introSound:String;
		public var outroSound:String;
		public static var movementTimeout:Number;
		public var removeTimeout:Number;

		public function ZoomView()
		{
			super();
			sm = SoundManager.gi();
			em = EventManager.gi();
			playInZoom = true;
			playOutZoom = true;
		}
		
		override protected function animationComplete():void
		{
			if(!close) return;
			close.buttonMode = true;
			em.handleEvents(close,this,"onClose");
		}
		
		public function onCloseClick():void
		{
			sm.playSound("Close");
			hide();
		}
		
		override public function hide():void
		{
			super.hide();
			if(outroSound) sm.playSound(outroSound);
			if(playOutZoom) sm.playSound("ZoomOut");
			if(introSound) sm.stopSound(introSound);
			if(loopSound) sm.stopSound(loopSound);
			sm.playSound("BunkerLoop",0,1000);
			removeTimeout = setTimeout(ShellController.gi().bunker.remove,1300,this);
			ZoomView.movementTimeout = setTimeout(ShellController.gi().bunker.addFrameForMovement,600);
		}

		override public function show():void
		{
			clearTimeout(removeTimeout);
			clearTimeout(ZoomView.movementTimeout);
			super.show();
			if(playInZoom) sm.playSound("ZoomIn");
			sm.stopSound("BunkerLoop");
			var ifd:FrameDelay = new FrameDelay(playIntro,25);
		}
		
		private function playIntro():void
		{
			if(introSound) sm.playSound(introSound);
			if(loopSound) sm.playSound(loopSound,0,1000);
		}	}}