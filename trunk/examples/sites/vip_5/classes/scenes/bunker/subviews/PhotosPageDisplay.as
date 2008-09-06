package scenes.bunker.subviews 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.guttershark.events.EventManager;	

	public class PhotosPageDisplay extends MovieClip 
	{
		
		private var em:EventManager;
		
		private var _dp:Array;
		private var _ph:PhotosOnRope;
		private var screws:Array;
		private var offset:int;
		private var page:int;
		private var totalPages:int;
		private var curpageScrew:MovieClip;
		
		public function PhotosPageDisplay()
		{
			super();
			em = EventManager.gi();
			screws = [];
			offset = 0;
			page = 0;
		}

		public function showInitial():void
		{
			hideAllPages();
			var p:Photo;
			if(_dp.length <= 4)
			{
				offset = 0;
				for(var j:int= 0; j < _dp.length; j++)
				{
					p = Photo(_ph["ph" + j]);
					p.asset = _dp[j];
					p.loadThumb();
				}
				return;
			}
			else
			{
				offset = 0;
				for(var i:int = 0; i < 5; i++)
				{
					p = Photo(_ph["ph" + i]);
					p.asset = _dp[i];
					p.loadThumb();
				}
				totalPages = Math.ceil(_dp.length / 5);
				if(totalPages == 1) return;
				for(var k:int = 0; k < totalPages; k++)
				{
					var s:MovieClip = this["screw"+(k+1).toString()]; 
					s.visible = true;
					s.buttonMode = true;
					em.handleEvents(s,this,"onScrew",true);
				}
				curpageScrew = this['screw1'];
				curpageScrew.gotoAndStop(2);
			}
		}
		
		//pages start at 0
		public function showThumbsForPage(page:int):void
		{
			offset = (page * 5);
			curpageScrew.gotoAndStop(1);
			curpageScrew = this['screw'+ (page+1).toString()];
			curpageScrew.gotoAndStop(2);
			var p:Photo;
			for(var i:int = 0; i < 5; i++)
			{
				if(_dp[offset+i] == null) return;
				p = Photo(_ph["ph" + i]);
				p.asset = _dp[offset + i];
				p.loadThumb();
			}
			_ph.play();
			displayFirstImage();
		}
		
		public function onScrewClick(me:MouseEvent):void
		{
			var page:String = me.target.name.substring(5);
			showThumbsForPage(int(page)-1);
		}

		private function hideAllPages():void
		{
			for(var i:int = 1; i < 29; i ++)
			{
				this["screw"+ i.toString()].visible = false;
			}
		}

		public function set dataProvider(data:Array):void
		{
			_dp = data;
		}
		
		public function set photosOnRope(photosOnRope:PhotosOnRope):void
		{
			_ph = photosOnRope;
			photosOnRope.next.buttonMode = true;
			photosOnRope.previous.buttonMode = true;
			em.handleEvents(photosOnRope.next, this, "onNext");
			em.handleEvents(photosOnRope.previous, this, "onPrevious");
		}
		
		public function displayFirstImage():void
		{
			_ph.ph0.displayAsLarge();
		}

		public function onNextClick():void
		{
			if(page == totalPages - 1) return;
			page++;
			showThumbsForPage(page);
		}
		
		public function onPreviousClick():void
		{
			if(page == 0) return;
			page--;
			showThumbsForPage(page);
		}
	}
	}