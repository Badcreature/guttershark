package 
{
	
	import net.guttershark.util.autosuggest.AutoSuggest;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController
	{
		
		public function Main():void
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			var terms:Array = [
				"George Bush", "Chaotmic Matter", "Particle Effects", "Word up",
				"Gangsta", "The Tony Danza Tap Dance Extravaganza", "Good bye",
				"Goodby","Gaa"
			];
			
			var ast:AutoSuggest = new AutoSuggest(terms,false);
			var a:* = ast.search("The Tony",true);
			trace(a[0].term);
			trace(a[0].highlightedTerm);
			
			var b:* = ast.search("G",true)
			trace(b.length);
			
			for(var i:int = 0; i < b.length; i++)
			{
				trace(b[i].term + " :: " + b[i].highlightedTerm);
			}
		}	}}