package net.guttershark.util 
{
		
	import flash.filters.BlurFilter;	
	import flash.display.MovieClip;
	import flash.utils.getTimer;	
	
	/**
	 * The CPU class benchmarks the clients computer
	 * and provides a fast/med/slow estimate.
	 * 
	 * <p>The CPU class does not provide details about how many
	 * CPU's they have, or he actual clock speed.</p>
	 * 
	 * @example Benchmarking client CPU:
	 * <listing>	
	 * CPU.calculate();
	 * trace(CPU.Speed);
	 * trace(CPU.Speed == CPU.FAST);
	 * trace(CPU.Speed == CPU.MEDIUM);
	 * trace(CPU.Speed == CPU.SLOW);
	 * trace(CPU.Benchmark);
	 * </listing>
	 * 
	 * @see net.guttershark.control.DocumentController
	 */
	final public class CPU 
	{
		
		/**
		 * An Identifier for the Speed property of this class.
		 */
		public static const FAST:String = "fast";
		
		/**
		 * An Identifier for the Speed property of this class.
		 */
		public static const MEDIUM:String = "medium";
		
		/**
		 * An Identifier for the Speed property of this class.
		 */
		public static const SLOW:String = "slow";
		
		/**
		 * The actual benchmark number.
		 */
		public static var Benchmark:Number;
		
		/**
		 * The speed identifier. It will be set to one of 
		 * CPU.FAST || CPU.MEDIUM || CPU.SLOW;
		 */
		public static var Speed:String;
		
		/**
		 * Calculate a benchmark time that gives a fairly accurate
		 * number you can use to decide if the client's CPU is
		 * fast / med / slow.
		 * 
		 * @param maxForFast	The maximum benchmark that qualifies the client CPU as FAST.
		 * @param maxForMedium	The maximum benchmark that qualifies the client CPU as MEDIUM.
		 */
		public static function calculate(maxForFast:int = 45, maxForMedium:int = 80):void
		{
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0xFF0066);
			mc.graphics.drawRect(0, 0, 200, 200);
			mc.graphics.endFill();
			var blurFilter:BlurFilter = new BlurFilter(4,4,1);
			var filters:Array = [];
			var passes:int = 3;
			var h:int = 0;
			var t:Number;
			for(h;h<passes;h++)
			{
				t = getTimer();
				for(var i:int = 0; i < ((h+1) * 200); i++)
				{
					filters.push(blurFilter);
					mc.filters = filters;
				}
				Benchmark = (getTimer() - t);
				filters = [];
			}
			if(Benchmark < maxForFast) Speed = CPU.FAST;
			else if(Benchmark < maxForMedium) Speed = CPU.MEDIUM;
			else Speed = CPU.SLOW;
		}
	}
}