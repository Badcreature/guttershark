package scenes.bunker.views
{
	import flash.display.SimpleButton;
	import flash.net.navigateToURL;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.model.Model;

	public class InvestorsView extends ZoomView
	{
		
		private var em:EventManager;

		public var garbonzo_button:SimpleButton;

		public function InvestorsView()
		{
			super();
		}
		
		override protected function animationComplete():void
		{
			super.animationComplete();
			em = EventManager.gi();
			em.handleEvents(garbonzo_button,this, "onG");
			trace("CLOSE!!",close);
		}
		
		public function onGClick():void
		{
			navigateToURL(Model.gi().getLink("garbonzo"),Model.gi().getLinkWindow("garbonzo"));
		}
	}}