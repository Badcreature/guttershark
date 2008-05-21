package
{
	
	import net.guttershark.remoting.events.RemotingEventsDelegate;
	import net.guttershark.remoting.events.CallEvent;	
	import net.guttershark.remoting.events.FaultEvent;
	import net.guttershark.remoting.events.ResultEvent;
	import net.guttershark.control.DocumentController;
	import net.guttershark.remoting.RemotingManager;	

	public class Main extends DocumentController 
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml",initRemotingEndpoints:[Endpoints.AMFPHP,Endpoints.RUBYAMF]};
		}
		
		override protected function setupComplete():void
		{
			remotingManager.remotingEventsDelegate = new RemotingEventsDelegate();
			remotingManager.addServiceEventListener(CallEvent.REQUEST_SENT,ServiceID.AMFPHP_MRM_CACHE,onRequestSent);
			remotingManager.call(ServiceID.AMFPHP_MRM_CACHE,"getGroup",["FEEDS"],onResult,onFault,false);
		}
		
		private function onRequestSent(ce:CallEvent):void
		{
			//trace("request sent FFFF");
		}
		
		private function onResult(re:ResultEvent):void
		{
			//trace("result");
			trace(re.result[0].Data);
		}
		
		private function onFault(fe:FaultEvent):void
		{
			//trace("FAULT");
			trace(fe.fault.description);
		}
	}
}