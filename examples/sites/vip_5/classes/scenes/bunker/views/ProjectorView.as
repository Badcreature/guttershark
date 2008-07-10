package scenes.bunker.views
{
	import flash.display.MovieClip;
	
	import fl.motion.easing.Quadratic;
	import fl.video.VideoAlign;
	import fl.video.VideoScaleMode;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.sound.SoundManager;
	
	import scenes.bunker.ReelController;	

	public class ProjectorView extends ZoomView
	{
		
		private var em:EventManager;
		private var sm:SoundManager;
		private var pc:PreloadController;
		private var sxp:Model;
		
		public var projector:MovieClip;

		public var controller:ReelController;
		private var videoxml:XML;
		private var animc:Boolean;

		public function ProjectorView()
		{
			super();
			em = EventManager.gi();
			sm = SoundManager.gi();
			sxp = Model.gi();
			pc = new PreloadController();
		}
		
		public function playLightFlickr():void
		{
			if(Math.random() * 100 < 50) sm.playSound("LightFlickr3");
			else sm.playSound("LightFlickr2");
		}

		public function prepare():void
		{
			playLightFlickr();
			if(videoxml) controller.dataProvider = videoxml;
		}
		
		public function prepareXML():void
		{
			if(videoxml) return;
			pc.addItems([sxp.getAssetByLibraryName("videosXML")]);
			em.handleEvents(pc,this,"onPC");
			pc.start();
		}
		
		public function onPCComplete():void
		{
			videoxml = AssetLibrary.gi().getXML("videosXML");
			if(animc) controller.dataProvider = videoxml;
		}
		
		override protected function animationComplete():void
		{
			super.animationComplete();
			animc = true;
			projector.player.align = VideoAlign.TOP_LEFT;
			projector.player.scaleMode = VideoScaleMode.EXACT_FIT;
			controller.player = projector.player;
			controller.loadFirstPreview();
			controller.playFirstFLV();
		}
		
		override public function onCloseClick():void
		{
			controller.dispose();
			projector.player.stop();
			TweenMax.to(projector.player,.3,{autoAlpha:0,ease:Quadratic.easeOut});
			em.disposeEventsForObject(pc);
			super.onCloseClick();
		}	}}