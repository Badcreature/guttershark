package net.guttershark.decorators 
{
	import net.guttershark.managers.SoundManager3;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * The SoundDecorator class decorates a sprite with
	 * sound functionality for most mouse events.
	 * 
	 * <p>Internally, the sound decorator uses the sound manager,
	 * so any sounds you want to play must have been registered
	 * with the sound manager before they play.</p>
	 */
	final public class SoundDecorator
	{
		
		/**
		 * Enabled flag.
		 */
		private var en:Boolean;
		
		/**
		 * The clips' stage reference.
		 */
		private var clipStageRef:Stage;
		
		/**
		 * the clip being decorated.
		 */
		private var clip:Sprite;
		
		/**
		 * The sound manager.
		 */
		private var snm:SoundManager3;
		
		/**
		 * click sound.
		 */
		private var _clicksound:String;
		
		/**
		 * double click sound.
		 */
		private var _dclickSound:String;
		
		/**
		 * over sound.
		 */
		private var _overSound:String;
		
		/**
		 * down sown
		 */
		private var _downSound:String;
		
		/**
		 * up sound.
		 */
		private var _upSound:String;
		
		/**
		 * mouse out sound.
		 */
		private var _outSound:String;
		
		/**
		 * mouse up outside sound.
		 */
		private var _upOutsideSound:String;
		
		/**
		 * flag for using up outside.
		 */
		private var useUpOutside:Boolean;
		
		/**
		 * Constructor for SoundDecorator instances.
		 * 
		 * <p>You can pass an object with the same properties
		 * available on this class, that will automatically
		 * get applied.</p>
		 * 
		 * @example Passing a sound object:
		 * <listing>	
		 * var sd:SoundDecorator=new SoundDecorator(mySprite,{clickSound:"blip",overSound:"ringSound"});
		 * </listing>
		 * 
		 * @param clip The sprite to decorate.
		 * @param sounds An object with sound properties to used.
		 */
		public function SoundDecorator(clip:Sprite,sounds:Object=null)
		{
			if(!clip) throw new Error("Parameter {clip} cannot be null.");
			this.clip=clip;
			snm=SoundManager3.gi();
			if(sounds.clickSound)clickSound=sounds.clickSound;
			if(sounds.overSound)overSound=sounds.overSound;
			if(sounds.downSound)downSound=sounds.downSound;
			if(sounds.upSound)upSound=sounds.upSound;
			if(sounds.outSound)outSound=sounds.outSound;
			if(sounds.upOutsideSound)upOutsideSound=sounds.upOutsideSound;
			if(sounds.doubleClickSound)doubleClickSound=sounds.doubleClickSound;
		}
		
		/**
		 * Enable or disable sound functionality.
		 */
		public function set enabled(val:Boolean):void
		{
			en=val;
		}
		
		/**
		 * Enable or disable sound functionality.
		 */
		public function get enabled():Boolean
		{
			return en;
		}
		
		/**
		 * Set the click sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set clickSound(audibleId:String):void
		{
			_clicksound=audibleId;
			clip.removeEventListener(MouseEvent.CLICK,onClick);
			clip.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
		}
		
		/**
		 * On click
		 */
		private function onClick(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_clicksound);
		}
		
		/**
		 * Set the double click sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set doubleClickSound(audibleId:String):void
		{
			_dclickSound=audibleId;
			clip.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick,false,0,true);
		}
		
		/**
		 * On double click
		 */
		private function onDoubleClick(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_dclickSound);
		}
		
		/**
		 * Set the over sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set overSound(audibleId:String):void
		{
			_overSound=audibleId;
			clip.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			clip.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
		}
		
		/**
		 * On mouse over.
		 */
		private function onMouseOver(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_overSound);
		}
		
		/**
		 * Set the down sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set downSound(audibleId:String):void
		{
			_downSound=audibleId;
			clip.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			clip.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
		}
		
		/**
		 * On mouse down.
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_downSound);
		}
		
		/**
		 * Set the up sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set upSound(audibleId:String):void
		{
			_upSound=audibleId;
			clip.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			clip.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
		}
		
		/**
		 * On mouse up.
		 */
		private function onMouseUp(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_upSound);
		}
		
		/**
		 * Set the out sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set outSound(audibleId:String):void
		{
			_outSound=audibleId;
			clip.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			clip.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
		}
		
		/**
		 * On mouse out.
		 */
		private function onMouseOut(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_outSound);
		}
		
		/**
		 * Set the up outside sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set upOutsideSound(audibleId:String):void
		{
			_upOutsideSound=audibleId;
			useUpOutside=true;
			if(!clip.stage)
			{
				clip.removeEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage);
				clip.addEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage,false,0,true);
				return;
			}
			clipStageRef=clip.stage;
			clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
			clipStageRef.addEventListener(MouseEvent.MOUSE_UP,onMouseUpStage,false,0,true);
			clip.addEventListener(Event.REMOVED_FROM_STAGE,onClipRemovedFromStage,false,0,true);
		}
		
		/**
		 * On stage mouse up
		 */
		private function onMouseUpStage(e:MouseEvent):void
		{
			if(!en)return;
			snm.playAudible(_upOutsideSound);
		}
		
		/**
		 * On clip added to stage.
		 */
		private function onClipAddedToStage(e:Event):void
		{
			clipStageRef=clip.stage;
			clip.removeEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage);
			clip.addEventListener(Event.REMOVED_FROM_STAGE,onClipRemovedFromStage);
			if(useUpOutside)
			{
				clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
				clipStageRef.addEventListener(MouseEvent.MOUSE_UP,onMouseUpStage,false,0,true);
			}
		}
		
		/**
		 * On clip removed from stage.
		 */
		private function onClipRemovedFromStage(e:Event):void
		{
			clip.removeEventListener(Event.REMOVED_FROM_STAGE,onClipRemovedFromStage);
			if(useUpOutside)
			{
				clip.addEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage,false,0,true);
				clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
			}
		}
		
		/**
		 * Dispose of this decorator.
		 */
		public function dispose():void
		{
			if(clipStageRef)clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
			clip.removeEventListener(MouseEvent.CLICK,onClick);
			clip.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			clip.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			clip.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			clip.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			en=false;
			_clicksound=null;
			_downSound=null;
			_outSound=null;
			_overSound=null;
			_upOutsideSound=null;
			_upSound=null;
			clip=null;
			clipStageRef=null;
			snm=null;
			useUpOutside=false;
		}	}}