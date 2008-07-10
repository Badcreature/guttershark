package scenes.bunker.views
{
	import flash.display.MovieClip;
	import flash.net.navigateToURL;
	
	import fl.video.FLVPlayback;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.model.Model;	

	public class UpcomingProjects extends ZoomView
	{
		
		private var em:EventManager;
		private var sxp:Model;

		public var launchBtn:MovieClip;
		public var grenade:MovieClip;
		public var sniperBtn:MovieClip;
		public var grenadeguy_mc:MovieClip;
		public var blast_mc:FLVPlayback;
		
		public function UpcomingProjects()
		{
			super();
			em = EventManager.gi();
			sxp = Model.gi();
		}
		
		override protected function animationComplete():void
		{
			super.animationComplete();
			em.disposeEventsForObject(sniperBtn);
			em.handleEvents(sniperBtn,this,"onSniperBtn");
			sniperBtn.buttonMode = true;
		}

		public function playeGrenadeVideo():void
		{
			blast_mc.play();
		}

		public function onSniperBtnMouseOver():void
		{
			launchBtn.gotoAndStop(2);
		}
		
		public function onSniperBtnMouseOut():void
		{
			launchBtn.gotoAndStop(1);
		}

		public function onSniperBtnClick():void
		{
			grenadeguy_mc.play();
		}

		public function onLaunchClick():void
		{
			grenade.play();
		}
		
		public function launchTheBlog():void
		{
			navigateToURL(sxp.getLink("blog"),sxp.getLinkWindow("blog"));
		}	}}