package
{
	import net.guttershark.remoting.RemotingManager;	
	import net.guttershark.control.DocumentController;
	import net.guttershark.remoting.events.CallEvent;
	import net.guttershark.remoting.events.FaultEvent;
	import net.guttershark.remoting.events.ResultEvent;	

	public class Main extends DocumentController 
	{
		
		private var rm:RemotingManager;

		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"site.xml",initRemotingEndpoints:[Endpoints.AMFPHP,Endpoints.RUBYAMF]};
		}
		
		override protected function setupComplete():void
		{
			rm = RemotingManager.gi();
			rm.addServiceEventListener(CallEvent.REQUEST_SENT,ServiceID.AMFPHP_MRM_CACHE,onRequestSent);
			rm.call(ServiceID.AMFPHP_MRM_CACHE,"getGroup",["FEEDS"],onResult,onFault,false);
		}
		
		private function onRequestSent(ce:CallEvent):void
		{
			trace("request sent getGroup");
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