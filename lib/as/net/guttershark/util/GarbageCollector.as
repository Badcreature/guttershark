package net.guttershark.util
{
	
	import flash.net.NetConnection;
	
	/**
	 * The GarbageCollector class forces the garbage collector to run.
	 * 
	 * <p>Note that the garbage collector is already extremely efficient.
	 * The garbage collector is triggered when memory usage reaches
	 * a certain amount. So if very small amounts of memory are being used
	 * then the garbage collector won't run as much.</p>
	 * 
	 * <p>When the garbage collector does run, in situations where there
	 * is a lot going on in the flash player, the garbage collector is
	 * running continuously. This can be verified in the Flex profiler.</p>
	 * 
	 * <p>This class really should only be used when you know that the garbage
	 * collector just isn't running all that often, and you need to force it.</p>
	 */
	final public class GarbageCollector
	{
		
		/**
		 * Run the garbage collector.
		 */
		public static function MarkSweep():void
		{
			var nc:NetConnection = new NetConnection();
			try
			{
				nc.connect("foo");
				nc.connect("foo");	
			}catch(e:*){}
		}
	}
}