package core
{
	import adobe.utils.MMExecute;
	
	import net.guttershark.util.Singleton;
	import net.guttershark.util.converters.BoolConverter;	

	public class JSFLProxy
	{

		private static var inst:JSFLProxy;

		public function JSFLProxy()
		{
			Singleton.assertSingle(JSFLProxy);
		}
		
		public static function gi():JSFLProxy
		{
			if(!inst) inst = Singleton.gi(JSFLProxy);
			return inst;
		}
		
		public function runScript(scriptFile:String, callProps:Object = null):*
		{
			//trase("runscript "+scriptFile);
			if(!callProps) callProps = {};
			var params:Array = (callProps.params) ? callProps.params : [];
			var a:String;
			if(params.length > 0) a = "";
			
			if(callProps.requestFormat)
			{
				trace("ADD SUPPORT FOR REQUEST FORMAT");
			}
			
			for(var i:int = 0; i < params.length;i++)
			{
				if(callProps.escapeParams===true) a += "'" + escape(params[i].toString()) + "'";
				else a += "'" + params[i].toString() + "'";
				if(i<params.length-1) a += ",";
			}
			
			var r:String;
			if(!callProps.method) r = MMExecute("fl.runScript('"+scriptFile+"')");
			else
			{
				if(a) r = MMExecute("fl.runScript('"+scriptFile+"','"+callProps.method+"',"+a+")");
				else r = MMExecute("fl.runScript('"+scriptFile+"','"+callProps.method+"')");
			}
			
			var ret:*;
			if(callProps.responseWasEscaped) r = unescape(r);
			switch(callProps.responseFormat)
			{
				case "boolean":
					ret = BoolConverter.toBoolean(r);
					break;
				case "xml":
					trase(r);
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
			}
			return ret;
		}
		
		public function alert(message:String):void
		{
			MMExecute("alert('"+message+"')");
		}
		
		public function trase(...params:Array):void
		{
			var a:String = "";
			for(var i:int = 0; i < params.length;i++)
			{
				a += "'" + params[i].toString() + "'";
				if(i<params.length-1) a += " : ";
			}
			trace(a);
			MMExecute("fl.trace("+a+")");
		}	}}