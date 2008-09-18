package net.guttershark.util
{
	import adobe.utils.MMExecute;
	
	import net.guttershark.util.Singleton;
	import net.guttershark.util.Utilities;		
	
	/**
	 * The JSFLProxy class is a proxy that communicates with
	 * JSFL, and can simplifies various facets of the actionscript<->jsfl
	 * workflow.
	 */
	final public class JSFLProxy
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:JSFLProxy;
		
		/**
		 * Utils.
		 */
		private var utils:Utilities;
		
		/**
		 * @private
		 */
		public function JSFLProxy()
		{
			Singleton.assertSingle(JSFLProxy);
			utils = Utilities.gi();
		}

		/**
		 * Singleton access.
		 */
		public static function gi():JSFLProxy
		{
			if(!inst) inst = Singleton.gi(JSFLProxy);
			return inst;
		}
		
		/**
		 * Run a jsfl script file, with optional parameters.
		 * 
		 * <p>The callProps object accepts these properties</p>
		 * 
		 * <ul>
		 * <li>method (String) - A method inside of the jsfl file to execute.</li>
		 * <li>params (Array) - Parameters to send to the jsfl function.</li>
		 * <li>escapeParams (Boolean) - Whether or not to escape all params</li>
		 * <li>responseWasEscaped (Boolean) - Whether the return value from jsfl was escaped.</li>
		 * <li>responseFormat (String) - A response format, so that casting can occur - supports (xml,boolean,int,number,array).
		 * </ul>
		 * 
		 * <p>Those properties are optional. And depending on what properties are present,
		 * either a jsfl file will execute, or a method inside of it</p>
		 * 
		 * @param scriptFile The fileURI (file:///) to run.
		 * @param callProps The call properties to use for this call.
		 */
		public function runScript(scriptFile:String, callProps:Object = null):*
		{
			//trase("runscript "+scriptFile);
			if(!callProps) callProps = {};
			var params:Array = (callProps.params) ? callProps.params : [];
			var a:String;
			if(callProps.requestFormat) trace("ADD SUPPORT FOR REQUEST FORMAT");
			if(params.length > 0) a = "";
			for(var i:int = 0; i < params.length;i++)
			{
				if(callProps.escapeParams ==true) a += "'" + escape(params[i].toString()) + "'";
				else a += "'" + params[i].toString() + "'";
				if(i<params.length-1) a += ",";
			}
			var r:String;
			if(!callProps.method) r = MMExecute("fl.runScript('"+scriptFile+"')");
			else
			{
				if(a) r  = MMExecute("fl.runScript('"+scriptFile+"','"+callProps.method+"',"+a+")");
				else r = MMExecute("fl.runScript('"+scriptFile+"','"+callProps.method+"')");
			}
			if(callProps.responseWasEscaped) r = unescape(r);
			var ret:* = r;
			if(!callProps.responseFormat && r == "null" || r == "false") ret = false;
			if(!callProps.responseFormat && r == "true") ret = true;
			switch(callProps.responseFormat)
			{
				case "boolean":
					ret = utils.string.toBoolean(r);
					break;
				case "xml":
					ret = new XML(r);
					break;
				case "number":
					ret = Number(r);
					break;
				case "int":
					ret = int(r);
					break;
				case "array":
					ret = r.split(",");
					break;
				default:
					ret = r;
					break;
			}
			return ret;
		}
		
		/**
		 * Alert a message.
		 * @param message A message to alert.
		 */
		public function alert(message:String):void
		{
			MMExecute("alert('"+message+"')");
		}
		
		/**
		 * Trace to output.
		 * 
		 * <p>Note that your message gets traced out like: escape(msg.toString()),
		 * this is so that you don't get stupid errors when passing complex strings to jsfl.</p>
		 * 
		 * @param msg An object to trace out.
		 */
		public function trase(msg:*):void
		{
			MMExecute("fl.trace("+escape(msg.toString())+")");
		}	}}