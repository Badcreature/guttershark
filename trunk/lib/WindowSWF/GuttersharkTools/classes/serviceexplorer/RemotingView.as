package serviceexplorer 
{
	import fl.controls.Button;
	
	import net.guttershark.display.views.BasicView;
	import net.guttershark.util.MovieClipUtils;		

	public class RemotingView extends BasicView
	{
		public var deleteService:Button;
		public var newService:Button;
		public var editService:Button;
		public var deleteGateway:Button;
		public var newGateway:Button;
		public var editGateway:Button;
		public var callService:Button;
		public var exportXML:Button;
		public var callResults:RemotingCallResultsView;
		public var newRemotingGateway:NewRemotingGatewayView;

		public function RemotingView()
		{
			super();
			MovieClipUtils.SetVisible(false,callResults,newRemotingGateway);
			em.handleEvents(newGateway, this, "onNewGateway");
		}
		
		public function onNewGatewayClick():void
		{
			newRemotingGateway.show();
		}	}}