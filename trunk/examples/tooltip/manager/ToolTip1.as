package 
{
	import net.guttershark.ui.controls.ToolTipDataProvider;	
	import net.guttershark.ui.controls.IToolTipDataProvider;	
	
	import fl.motion.easing.Quadratic;	
	
	import gs.TweenMax;	
	
	import flash.display.Sprite;	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.display.MovieClip;
	
	import net.guttershark.ui.controls.IToolTip;
	
	public class ToolTip1 extends MovieClip implements IToolTip 
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
			x = forSprite.x + 30;
			y = forSprite.y + 30;
			TweenMax.to(this,.3,{autoAlpha:1,ease:Quadratic.easeIn});
		}
		
		public function move(forSprite:Sprite):Boolean
		{
			return false;
		}
		
		public function hide():void
		{
			TweenMax.to(this,.5,{autoAlpha:0});
		}	}}