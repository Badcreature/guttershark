package net.guttershark.services.http
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;		

	/**
	 * The ServiceCall class is an abstract http service caller and uses callbacks
	 * for result and fault events - this class is not used directly, but used
	 * by a Service which is managed by the ServiceManager.
	 */
	public class ServiceCall
	{
	
		private var loader:URLLoader;
		private var request:URLRequest;
		private var rc:Function;
		private var fc:Function;
		
		/**
		 * Constructor for ServiceCall instances.
		 */
		public function ServiceCall()
		{
			loader = new URLLoader();
		}
		
		/**
		 * Executes the service call.
		 * @param	urlRequest	The urlRequest to use as the endpoint.
		 * @param	service	The service to call.
		 * @param	args	Any arguments to send to the service. Must be an array for url routed services, or an object for querystring get/post services.
		 * @param	rc	The result callback.
		 * @param	fc	The fault callback.
		 */
		public function execute(href:String, id:String, service:String, args:*, props:Object, defaultResultFormat:String):void
		{
			request = new URLRequest(href);
			this.rc = props.onResult;
			this.fc = props.onFault;
			
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.dataFormat = props.resultFormat||defaultResultFormat;
			
			if(props.useRoutes === true)
			{
				var route:String= "/" + id + "/" + service + "/";
				if(args[0] != null)
				{
					for each(var n:String in args) route = route + n + "/";
				}
				request.url += route;
			}
			
			//var durl:String="";
			if(props.data != null)
			{
				var t:URLVariables = new URLVariables();
				for(var key:String in props.data)
				{
					t[key] = props.data[key];
					//durl += "&"+key+"="+props.data[key];
				}
				request.data = t;
				request.url += "?";
			}
			//trace("final URL: ", request.url + durl);
			loader.load(request);
		}
		
		/**
		 * on complete of the service call.
		 */
		private function completeHandler(e:Event):void
		{
			var res:ServiceResult = new ServiceResult();
			var fal:ServiceFault = new ServiceFault();
			res.format = loader.dataFormat;
			if(loader.dataFormat == ServiceResultFormat.VARS)
			{
				if(loader.data.result != null)
				{
					res.result = loader.data.result;
					res.data = loader.data;
					if(loader.data.result.toLowerCase() == "true") res.result = true;
					else if(loader.data.result.toLowerCase() == "false") res.result = false;
					fal = null;
					rc(res);
				}
				else if(loader.data.fault != null)
				{
					res = null;
					fal.fault = loader.data.fault;
					fal.data = loader.data;
					fc(fal);
				}
				else
				{
					trace("Result type was variables, but result and fault properties were not found, use data property.");
					fal = null;
					res.data = loader.data;
					rc(res);
				}
			}
			else if(loader.dataFormat == ServiceResultFormat.XML)
			{
				var x:XML = new XML(loader.data);
				if(x.fault != undefined)
				{
					res = null;
					fal.fault = x.fault.toString();
					fal.data = x;
					fc(fal);
				}
				else
				{
					fal = null;
					res.result = x;
					res.data = x;
					rc(res);
				}
			}
			else if(loader.dataFormat == ServiceResultFormat.BIN)
			{
				fal = null;
				res.result = loader.data as ByteArray;
				res.data = loader.data;
				rc(res);
			}
		}
	}}