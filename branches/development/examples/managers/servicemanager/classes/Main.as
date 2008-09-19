package
{
	import net.guttershark.control.DocumentController;
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.model.Model;
	import net.guttershark.support.servicemanager.shared.CallFault;
	import net.guttershark.support.servicemanager.shared.CallResult;	

	public class Main extends DocumentController 
	{
		
		/**
		 * This example will not work on your computer, as I have services
		 * setup on mine specific for this test. But you should read through
		 * the code anyway and you'll get a good idea of what's going on.
		 */

		public function Main()
		{
			super();
		}

		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml",initServices:true};
		}
		
		override protected function initPathsForStandalone():void
		{
			if(!ml) ml = Model.gi();
			ml.addPath("amfphp","http://localhost/amfphp/gateway.php");
			ml.addPath("ci","http://tagsf/services/codeigniter/");
			ml.addPath("sd","session/destroy/");
			ml.addPath("sessiondestroy",ml.getPath("ci","sd"));
		}
		
		override protected function setupComplete():void
		{
			trace("SETUP COMPLETE");
			sm = ServiceManager.gi();
			sm.ci({onCreate:onc,onFault:onfs,routes:["session","destroy"],onResult:onhr});
			sm.test.helloWorld({onFault:onf,onResult:onr,onTimeout:ont,onRetry:onrt});
		}
		
		private function onfs(cf:CallFault):void
		{
			trace(cf.fault);
		}

		private function onc():void
		{
			trace("created");
		}
		
		private function onhr(sr:CallResult):void
		{
			trace("service result");
		}
		
		private function onsf(sf:CallFault):void
		{
			trace("fault");
		}

		private function onrt():void
		{
			trace("retry");
		}
		
		private function ont():void
		{
			trace("timeout");
		}
		
		private function onr(re:CallResult):void
		{
			trace("result");
			trace(re.result);
		}

		private function onf(fe:CallFault):void
		{
			trace("fault");
			for(var key:String in fe.fault)
			{
				trace(key);
			}
		}	}}