package net.guttershark.support.servicemanager.http
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import net.guttershark.support.servicemanager.shared.BaseCall;
	import net.guttershark.support.servicemanager.shared.CallFault;
	import net.guttershark.support.servicemanager.shared.CallResult;		

	/**
	 * The ServiceCall class is an abstract http service call and uses callbacks
	 * for result and fault events - this class is generally not used directly.
	 */
	final public class ServiceCall extends BaseCall
	{
		
		/**
		 * The url
		 */
		private var url:String;
		
		/**
		 * The loader.
		 */
		private var loader:URLLoader;
		
		/**
		 * A request.
		 */
		private var request:URLRequest;
		
		/**
		 * Constructor for ServiceCall instances.
		 */
		public function ServiceCall(url:String,callProps:Object)
		{
			super(callProps);
			this.url = url;
			request = new URLRequest(url);
		}
		
		/**
		 * Executes the service call.
		 * 
		 * @param urlRequest The urlRequest to use as the endpoint.
		 * @param service The service to call.
		 * @param args Any arguments to send to the service. Must be an array for url routed services, or an object for querystring get/post services.
		 * @param rc The result callback.
		 * @param fc The fault callback.
		 */
		override public function execute():void
		{
			if(!completed)
			{
				attempts = props.attempts;
				request.method = props.method;
				if(!callTimer)
				{
					callTimer = new Timer(props.timeout,attempts);
					callTimer.addEventListener(TimerEvent.TIMER,onTick, false, 0, true);
				}
				if(!loader)
				{
					if(props.routes && props.routes.length > 0)
					{
						var route:String = "";
						for each(var n:String in props.routes) route = route + n + "/";
						request.url += route;
					}
					if(props.data)
					{
						var t:URLVariables = new URLVariables();
						for(var key:String in props.data) t[key] = props.data[key];
						request.data = t;
						if(props.method=="get") request.url += "?";
					}
				}
				tries++;
				if(loader)
				{
					loader.close();
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
				}
				loader = new URLLoader();
				if(!loader.hasEventListener(Event.COMPLETE))
				{
					loader.addEventListener(Event.COMPLETE, onComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
				}
				var rf:String = props.responseFormat;
				if(rf == ResponseFormat.XML) rf = ResponseFormat.TEXT;
				loader.dataFormat = rf;
				if(!callTimer.running) callTimer.start();
				loader.load(request);
			}
		}
		
		private function onError(e:*):void
		{
			if(!completed && !url) return;
			if(completed) return;
			callComplete();
			var fal:CallFault = new CallFault(e);
			if(!checkForOnFaultCallback()) return;
			props.onFault(fal);
			dispose();
		}
		
		/**
		 * on complete of the service call.
		 */
		private function onComplete(e:Event):void
		{
			if(!completed && !url) return;
			if(completed) return;
			callComplete();
			var res:CallResult;
			var fal:CallFault;
			if(props.responseFormat == ResponseFormat.VARS)
			{
				if(loader.data.result != null)
				{
					res = new CallResult(loader.data.result);
					if(loader.data.result.toLowerCase() == "true") res.result = true;
					else if(loader.data.result.toLowerCase() == "false") res.result = false;
					if(!checkForOnResultCallback()) return;
					props.onResult(res);
				}
				else if(loader.data.fault != null)
				{
					fal = new CallFault(loader.data.fault);
					fal.fault = loader.data.fault;
					if(!checkForOnFaultCallback()) return;
					props.onFault(fal);
				}
				else
				{
					res = new CallResult(loader.data);
					props.onResult(res);
				}
			}
			else if(props.responseFormat == ResponseFormat.XML)
			{
				var x:XML = new XML(loader.data);
				if(x.fault != undefined)
				{
					fal = new CallFault(x.fault.toString());
					if(!checkForOnFaultCallback()) return;
					props.onFault(fal);
				}
				else
				{
					res = new CallResult(x);
					if(!checkForOnResultCallback()) return;
					props.onResult(res);
				}
			}
			else if(props.responseFormat == ResponseFormat.TEXT)
			{
				res = new CallResult(loader.data);
				if(!checkForOnResultCallback()) return;
				props.onResult(res);
			}
			else if(props.responseFormat == ResponseFormat.BINARY)
			{
				res = new CallResult(loader.data as ByteArray);
				if(!checkForOnResultCallback()) return;
				props.onResult(res);
			}
			dispose();
		}
		
		/**
		 * Dispose of this call.
		 */
		override public function dispose():void
		{
			super.dispose();
			url = null;
			loader.close();
			loader.removeEventListener(Event.COMPLETE, onComplete);
			loader.removeEventListener(IOErrorEvent.NETWORK_ERROR,onError);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loader = null;
			request = null;
		}
	}
}