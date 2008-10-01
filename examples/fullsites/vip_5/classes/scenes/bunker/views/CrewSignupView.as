package scenes.bunker.views
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import fl.motion.easing.Quadratic;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.managers.FormFieldManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.ui.controls.buttons.MovieClipButton;
	import net.guttershark.ui.controls.buttons.MovieClipCheckBox;
	import net.guttershark.util.DisplayListUtils;
	import net.guttershark.util.FileFilters;
	import net.guttershark.util.MathUtils;
	import net.guttershark.util.ScopeUtils;		

	public class CrewSignupView extends SignupView
	{
		
		protected var ffm:FormFieldManager;
		protected var sxp:Model;
		protected var pc:PreloadController;
		protected var em:EventManager;
		private var fr:FileReference;
		private var l:URLLoader;

		public var submitURL:String;
		 
		public var forms:MovieClip;
		public var firstname:TextField;
		public var lastname:TextField;
		public var wemet:TextField;
		public var how:TextField;
		public var position:TextField;
		public var position2:TextField;
		public var resume:MovieClipCheckBox;
		public var reel:MovieClipCheckBox;
		public var headshot:MovieClipCheckBox;
		public var email:TextField;
		public var mobile:TextField;
		public var website:TextField;
		public var story:TextField;
		public var signup:MovieClipButton;
		private var uploadedFileName:String;
		public var uploadedImageStore:String;
		public var imageUploadSubmit:String;
		public var submissionThanks:MovieClip;
		public var thanksHolder:MovieClip;
		public var earth:MovieClip;
		protected var closing:Boolean;

		public function CrewSignupView()
		{
			super();
			ffm = new FormFieldManager();
			fr = new FileReference();
			pc = new PreloadController();
			em = EventManager.gi();
			sxp = Model.gi();
			em.handleEvents(fr,this,"onFR");
			em.handleEvents(l,this,"onLoader");
		}
		
		override protected function animationComplete():void
		{
			super.animationComplete();
			closing = false;
			ScopeUtils.ReTargetInstanceVars([
				"firstname","lastname","wemet","how","position","position2","reel","resume",
				"email","website","mobile","website","story","signup","headshot"],this,forms);
			signup.buttonMode = true;
			reel.buttonMode = true;
			headshot.buttonMode = true;
			resume.buttonMode = true;
			ffm.addTextFields([lastname,firstname,wemet,how,position,position2,email,mobile,website,story]);
			ffm.addToggleables([resume,reel,headshot]);
			ffm.setTabs([lastname,firstname,wemet,how,position,position2,email,mobile,website,story]);
			ffm.disableTabsOnToggleables();
			ffm.displayBooleansAs("YES","NO");
			em.handleEvents(forms,this,"onForms");
			em.handleEvents(signup,this,"onSignup");
			em.handleEvents(headshot,this,"onHeadshot");
		}

		public function onFormsMouseWheel(me:MouseEvent):void
		{
			var t:Number = -550;
			var wy:Number = this.y + me.delta;
			if(wy < t) this.y = -550;
			else if(wy >= 0) this.y = 0;
			else this.y += me.delta;
		}
		
		public function onFRUploadCompleteData(e:DataEvent):void
		{
			var name:String = e.data.split("=")[1];
			uploadedFileName = name;
			var a:Asset = new Asset(uploadedImageStore + name, "uploadedPic");
			pc.addItems([a]);
			em.handleEvents(pc,this,"onPreloader");
			pc.start();
		}
		
		public function onPreloaderComplete():void
		{
			var b:Bitmap = AssetLibrary.gi().getBitmap("uploadedPic");
			if(b.width > 110 || b.height > 110)
			{
				var c:Object = MathUtils.ConstrainedResize(110,110,b.width,b.height);
				b.width = c.w;
				b.height = c.h;
				b.smoothing = true;
			}
			forms.holder.addChild(b);
		}

		public function onFormsMouseMove():void
		{
			if(closing) return;
			if(stage.mouseY < 50) TweenMax.to(this,.6,{y:0,ease:Quadratic.easeIn,overwrite:false});
			if(this.y == -550 || TweenMax.isTweening(this)) return;
			if(stage.mouseY > 600) TweenMax.to(this,.6,{y:-550,overwrite:false,ease:Quadratic.easeIn});
		}

		public function onFRSelect():void
		{
			fr.upload(new URLRequest(imageUploadSubmit));
		}

		public function onLoaderComplete():void
		{
		}

		public function onFRCancel():void
		{
			headshot.checked = false;
		}

		public function onHeadshotClick():void
		{
			if(headshot.checked)
			{
				DisplayListUtils.RemoveAllChildren(forms.holder);
				fr.browse([FileFilters.BitmapFileFilter]);
			}
		}

		public function onSignupClick():void
		{
			var l:URLLoader = new URLLoader();
			l.dataFormat = URLLoaderDataFormat.VARIABLES;
			var ur:URLRequest = new URLRequest(submitURL);
			var o:URLVariables = ffm.getOutputAsURLVariables();
			if(headshot.checked) o.headshot = uploadedImageStore + uploadedFileName;
			ur.data = o;
			ur.method = "POST";
			//l.load(ur);
			sendToURL(ur);
			submissionThanks = AssetLibrary.gi().getMovieClipFromSWFLibrary("castSignup", "SubmissionThanks");
			submissionThanks.alpha = 0;
			submissionThanks.y = 550;
			thanksHolder.addChild(submissionThanks);
			TweenMax.to(submissionThanks,.4,{autoAlpha:1,ease:Quadratic.easeOut});
			setTimeout(hideThanks, 3000);
		}
		
		protected function hideThanks():void
		{
			TweenMax.to(submissionThanks,.3,{autoAlpha:0,ease:Quadratic.easeOut,onComplete:onCloseClick});
		}

		override public function onCloseClick():void
		{
			//TODO: close url loader for submission.
			closing = true;
			if(earth) earth.earth_mc.stop();
			if(this.y == 0) super.onCloseClick();
			else TweenMax.to(this,.2,{y:0,onComplete:super.onCloseClick});
		}	}}