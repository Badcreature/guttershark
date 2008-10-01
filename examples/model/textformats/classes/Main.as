package 
{
	import flash.text.TextField;
	
	import net.guttershark.control.DocumentController;

	public class Main extends DocumentController 
	{
		
		public var test:TextField;

		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			test.defaultTextFormat = ml.getTextFormatById("theTF");
			test.text = "TESTING";
		}	}}