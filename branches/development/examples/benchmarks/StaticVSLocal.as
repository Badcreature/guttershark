package  
{
	import flash.utils.getTimer;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.util.ArrayUtils;
	import net.guttershark.util.Utilities;	

	/**
	 * This test illustrates why the utils property is on a CoreSprite
	 * and CoreClip. Object lookup with member variables is 58% faster
	 * than using Static classes.
	 * 
	 * <p>There are three tests here, calling utilities.array.search(),
	 * ar.search(), and ArrayUtils2.Search(). Both calls that are made
	 * on the member variables are 58% faster - Static is always slower.</p>
	 */
	public class StaticVSLocal extends DocumentController
	{

		private var ar:ArrayUtils;

		public function StaticVSLocal()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			super.setupComplete();
			ar = ArrayUtils.gi();
			//all of these average about the same
			run1();
			run2();
			run3();
			run4();
		}

		private function run1():void
		{
			var c:int = 1000000;
			var i:int = 0;
			var l:int = c;
			
			var t:Number = getTimer();
			while(i<--l) utils.array._search();
			trace("1A: ", getTimer()-t);
			
			l = c;
			t = getTimer();
			for(i;i<l;i++) utils.array._search();
			trace("1B: ", getTimer()-t);
		}
		
		private function run2():void
		{
			var c:int = 1000000;
			var i:int = 0;
			var l:int = c;
			
			var t:Number = getTimer();
			while(i<--l) ar._search();
			trace("2A: ", getTimer()-t);
			
			l = c;
			t = getTimer();
			for(i;i<l;i++) ar._search();
			trace("2B: ", getTimer()-t);
		}
		
		private function run3():void
		{
			var a:ArrayUtils = utils.array;
			var c:int = 1000000;
			var i:int = 0;
			var l:int = c;
			
			var t:Number = getTimer();
						
			while(i<--l) a._search();
			trace("3A: ", getTimer()-t);
			
			l = c;
			t = getTimer();
			for(i;i<l;i++) a._search();
			trace("3B: ", getTimer()-t);
		}
		
		//static is slowest. on average about %50 slower.
		private function run4():void
		{
			var c:int = 1000000;
			var i:int = 0;
			var l:int = c;
			
			var t:Number = getTimer();
			while(i<--l) ArrayUtils._Search();
			trace("4A: ", getTimer()-t);
			
			l = c;
			t = getTimer();
			for(i;i<l;i++) ArrayUtils._Search();
			trace("4B: ", getTimer()-t);
		}	}}