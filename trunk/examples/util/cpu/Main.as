package 
{
	import net.guttershark.util.Bandwidth;	
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
			trace(CPU.Speed);
			trace(Bandwidth.Speed);
		}

		override protected function flashvarsForStandalone():Object
		{
			return {sniffCPU:true, sniffBandwidth:true};
		}
	}}