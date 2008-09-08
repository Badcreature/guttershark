package serviceexplorer 
{
	import flash.display.MovieClip;
	
	import fl.controls.Button;
	
	import net.guttershark.display.views.BasicView;		

	public class NewRemotingGatewayView extends BasicView 
	{
		public var cancel:Button;
		public var savebtn:Button;
		public var arrow:MovieClip;

		public function NewRemotingGatewayView()
		{
			super();
			em.handleEvents(cancel,this,"onCancel");
		}
		
		public function onCancelClick():void
		{
			hide();
		}
		
		override public function hide():void
		{
			visible = false;
			arrow.gotoAndStop(1);
		}
		
		override public function show():void
		{
			visible = true;
			arrow.play();
		}			}}