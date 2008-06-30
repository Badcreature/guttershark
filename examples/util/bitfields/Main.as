package 
{
	
	import net.guttershark.util.BitField;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController 
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			var bf = new BitField();
			bf.addField("isOpen",4,0);
			bf.addField("isTest",4,4);
			bf.addField("anotherState",4,8);
			bf.addField("booltest",1,9);
			bf.isOpen = -3;
			bf.isTest = 15;
			bf.anotherState = -2;
			trace(bf.isOpen);
			trace(bf.isTest);
			trace(bf.anotherState);
			bf.booltest = 0;
			if(bf.booltest) trace("WORD");
		}
			}}