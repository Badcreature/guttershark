package 
{
	
	import net.guttershark.util.CPU;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			CPU.calculate();
			trace(CPU.Speed);
		}
	}}