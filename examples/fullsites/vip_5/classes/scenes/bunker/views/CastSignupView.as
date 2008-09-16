package scenes.bunker.views
{
	import flash.display.MovieClip;	

	public class CastSignupView extends CrewSignupView
	{
		
		public var aquarium_mc:MovieClip;
		
		public function CastSignupView()
		{
			super();		}
		
		override protected function animationComplete():void
		{
			super.animationComplete();
			playFish();
			em.disposeEventsForObject(aquarium_mc.fish_mc);
			em.handleEvents(aquarium_mc.fish_mc,this,"onFLV");
		}
		
		private function playFish():void
		{
			aquarium_mc.fish_mc.source = sxp.getAttribute("fishVideo");
			aquarium_mc.fish_mc.play();
		}
		
		public function onFLVComplete():void
		{
			aquarium_mc.fish_mc.play();
			playFish();
		}
		
		override public function onCloseClick():void
		{
			aquarium_mc.fish_mc.stop();
			super.onCloseClick();
		}
	}}