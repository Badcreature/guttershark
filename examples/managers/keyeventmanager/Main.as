package 
{
	
	import flash.ui.Keyboard;
	import net.guttershark.control.DocumentController;
	
	public class Main extends DocumentController
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			keyboardEventManager.scope = this;
			keyboardEventManager.addKeyMapping(this,Keyboard.SPACE,onSpace);
		}
		
		private function onSpace():void
		{
			trace("space pressed");
		}
	}}