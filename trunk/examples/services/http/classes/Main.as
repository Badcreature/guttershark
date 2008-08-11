package
{
	import net.guttershark.services.ServiceFault;	
	import net.guttershark.services.ServiceResult;	
	import net.guttershark.services.ServiceManager;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController
	{
		
		private var sm:ServiceManager;

		public function Main()
		{
		
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {initHTTP:["user"],model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			sm = ServiceManager.gi();
			//trace("setup complete");
			//trace(sm.user);
			//sm.user.name([],onResult,onFault);
			sm.user([],{onResult:onResult,onFault:onFault,data:{c:"user",m:"name"}});
			sm.user.name([],{onResult:onResult,onFault:onFault});
			//sm.user.save(["test","again"],{onResult:onResult,onFault:onFault,data:{c:"ffffff",d:"eeeee"}});
		}
		
		private function onResult(sr:ServiceResult):void
		{
			trace(sr.result);
			trace("RES");
		}
		
		private function onFault(sf:ServiceFault):void
		{
			trace("FAULT");
		}	}}