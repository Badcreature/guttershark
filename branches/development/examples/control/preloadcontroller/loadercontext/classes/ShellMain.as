package
{
	import net.guttershark.control.DocumentController;
	import net.guttershark.control.PreloadController;
	import net.guttershark.support.preloading.Asset;		

	public class ShellMain extends DocumentController
	{
		public function ShellMain()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			super.setupComplete();
			preload();
		}
		
		private function preload():void
		{
			pc=new PreloadController(100);
			em.he(pc,this,"onPC");
			pc.addItems([new Asset("assets/child.swf","childSWF")]);
			pc.start();
		}
		
		public function onPCComplete():void
		{
			trace("complete");
			trace("shellClipTest from current domain:",am.getMovieClip("shellClipTest"));
			trace("child clip test from child domain", am.getMovieClipFromSWFLibrary("childSWF","Child"));
			trace("child clip test from current domain",am.getMovieClip("Child"));
			addChild(am.getMovieClip("Child") as ChildTest);
			trace(am.getSound("OdeTo"));
		}	}}