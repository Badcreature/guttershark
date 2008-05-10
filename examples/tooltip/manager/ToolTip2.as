package 
{

	import flash.display.Sprite;
	import fl.motion.easing.Quadratic;

	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.display.MovieClip;
	
	import net.guttershark.ui.controls.ToolTipDataProvider;	
	import net.guttershark.ui.controls.IToolTipDataProvider;	
	import net.guttershark.ui.controls.IToolTip;
	
	import gs.TweenMax;
	
	public class ToolTip2 extends MovieClip implements IToolTip 
	{
		
		public var label:TextField;
		var dp:ToolTipDataProvider;

		public function set dataProvider(dpv:IToolTipDataProvider):void
		{
			dp = ToolTipDataProvider(dpv);
			label.text = dp.message;
		}
		
		public function show(forSprite:Sprite):void
		{
			this.visible = false;
			x = this.stage.mouseX;
			y = this.stage.mouseY + 14;
			TweenMax.to(this,.3,{autoAlpha:1,ease:Quadratic.easeIn});
		}
		
		public function move(forSprite:Sprite):Boolean
		{
			var nx:Number = this.stage.mouseX;
			var ny:Number = this.stage.mouseY + 14;
			TweenMax.to(this,.3,{autoAlpha:1,x:nx,y:ny,ease:Quadratic.easeIn});
			return true;
		}
		
		public function hide():void
		{
			TweenMax.to(this,.5,{autoAlpha:0});
		}
	}
}
