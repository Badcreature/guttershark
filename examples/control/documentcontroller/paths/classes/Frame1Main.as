package
{
	import net.guttershark.control.Frame1Controller;	
	
	public class Frame1Main extends Frame1Controller
	{
		public function Frame1Main()
		{
			super();
		}
		
		override protected function gotoStartFrame():void
		{
			super.gotoStartFrame();
			gotoAndStop(2);
		}
	}}