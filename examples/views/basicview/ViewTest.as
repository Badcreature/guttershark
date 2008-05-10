package
{
	
	import net.guttershark.ui.views.BasicView;
	
	public class ViewTest extends BasicView
	{
		
		public function ViewTest():void{}
		
		override protected function activated():void
		{
			super.activated();
			trace("activated");
		}
		
		override protected function deactivated():void
		{
			super.deactivated();
			trace("deactivated");
		}
		
		override protected function init():void
		{
			super.init();
			trace("INIT");
		}
		
		override protected function addListeners():void
		{
			super.addListeners();
			trace("add listeners");
		}
		
		override protected function removeListeners():void
		{
			super.removeListeners();
			trace("remove listeners");
		}
		
		override protected function cleanup():void
		{
			super.cleanup();
			trace("cleanup");
		}
		
		override public function dispose():void
		{
			super.dispose();
			trace("dispose");
		}	}}