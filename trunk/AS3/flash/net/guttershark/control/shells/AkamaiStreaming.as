package net.guttershark.control.shells 
{
	
	import flash.events.Event;
	
	import net.guttershark.akamai.Ident;	
	import net.guttershark.control.DocumentController;
	import net.guttershark.akamai.AkamaiNCManager;
	
	/**
	 * The AkamaiStreaming base Document Class adds one more sequence into
	 * the startup sequence from the default DocumentController. Sniffing
	 * the best IP address to use for a Flash Media Server on Akamai's network.
	 * 
	 * <p>You should override the akamaiIdentComplete method and use that as
	 * the final method in the chain to continue on with your initial logic.</p>
	 * 
	 * <p>This class uses the flashvars.akamaiHost property with the Ident class
	 * to sniff the best IP.</p>
	 * 
	 * <p>You can still override the setupComplete method, but you must call
	 * super.setupComplete() in order to start the Akamai Ident sniff.<p>
	 * 
	 * @see net.guttershark.akamai.Ident
	 */
	public class AkamaiStreaming extends DocumentController
	{

		private var ident:Ident;

		/**
		 * Constructor for AkamaiStreaming Document Class.
		 */
		public function AkamaiStreaming()
		{
			super();
		}
		
		/**
		 * Overrides the setupComplete method to continue on by
		 * loading an Ident service from akamai.
		 */
		override protected function setupComplete():void
		{
			ident = new Ident();
			ident.contentLoader.addEventListener(Event.COMPLETE, onAkamaiIdentComplete);
			ident.findBestIPForAkamaiApplication(flashvars.akamaiHost);
		}
		
		/**
		 * event handler method.
		 */
		private function onAkamaiIdentComplete(e:Event):void
		{
			if(e.target.data.ip) AkamaiNCManager.FMS_IP = e.target.data.ip;
			akamaiIdentComplete();
			ident.dispose();
			ident = null;
		}
		
		/**
		 * A method you can override to hook into the final method in the
		 * startup process.
		 */
		protected function akamaiIdentComplete():void{}
	}
}
