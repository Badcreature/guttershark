package 
{
	import net.guttershark.control.PreloadController;	
	import net.guttershark.support.preloading.Asset;	
	import net.guttershark.control.DocumentController;
	
	public class Main extends DocumentController 
	{
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			pc = new PreloadController();
			pc.addItems([new Asset("./usanails.mp3","usanails")]);
			em.he(pc,this,"onPC");
			pc.start();
		}
		
		public function onPCComplete():void
		{
			trace("completE");
			snm.addSound("usanails",am.getSound("usanails"));
			snm.playSound("usanails");
		}	}}