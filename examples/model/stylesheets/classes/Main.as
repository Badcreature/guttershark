package 
{
	import flash.text.StyleSheet;	
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
			var s:StyleSheet = ml.getStyleSheetById("colors");
			trace(s);
			trace(s.getStyle(".pink").color);
			test.styleSheet = s;
			test.htmlText = "hello <span class='pink'>world</span>";
		}	}}