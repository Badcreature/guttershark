package net.guttershark.events 
{
	import flash.events.DataEvent;	
	import flash.net.FileReference;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.net.URLLoader;
	import flash.net.Socket;
	import flash.media.Microphone;
	import flash.events.StatusEvent;
	import flash.events.ActivityEvent;
	import flash.media.Camera;
	import flash.events.ProgressEvent;
	import flash.display.LoaderInfo;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.events.IEventDispatcher;
	
	import net.guttershark.core.IDisposable;
	import net.guttershark.util.Tracking;
	
	/**
	 * The EventManager class simplifies events and provides shortcuts for event listeners 
	 * for numerous AS3 top level classes, and component events on an opt-in basis. 
	 * 
	 * <p>All events can circulate through the Tracking class to implement tracking
	 * for you base off of any event that is being managed.</p>
	 * 
	 * @example Using EventManager with a MovieClip.
	 * <listing>	
	 * import net.guttershark.events.EventManager;
	 * import net.guttershark.events.EventTypes;
	 * 
	 * public class Main extends Sprite
	 * {
	 * 
	 *    private var em:EventManager;
	 *    private var mc:MovieClip;
	 *    
	 *    public function Main()
	 *    {
	 *       super();
	 *       em = EventManager.gi();
	 *       mc = new MovieClip();
	 *       mc.graphics.beginFill(0xFF0066);
	 *       mc.graphics.drawCircle(200, 200, 100);
	 *       mc.graphics.endFill();
	 *       em.handleEvents(mc,this,"onCircle");
	 *       addChild(mc);
	 *    }
	 *    
	 *    public function onCircleClick():void
	 *    {
	 *       trace("circle click");
	 *    }
	 *    
	 *    public function onCircleAddedToStage():void
	 *    {
	 *        trace("my circle was added to stage");
	 *    }
	 * }
	 * </listing>
	 * 
	 * <p>Callback methods will only be called if you have them defined. Your callback methods must 
	 * be defined with the specified prefix, plus the name of the event. Specified in the below tables.<p>
	 * 
	 * <p>Passing the originating event back to your callback is optional, but there are a few
	 * events that are not optional, because they contain information you probably need.
	 * The non-negotiable events are listed below.</p>
	 * 
	 * <p>EventManager also supports adding your own EventHandlerDelegate, this is how
	 * component support is available. There are custom EventHandlerDelegates for 
	 * components so you don't have to compile every one into your swf. This also
	 * allows for you to create your own if neccessary.</p>
	 * 
	 * @example Adding support for event handler delegate of an FLVPlayback component:
	 * <listing>	
	 * import net.guttershark.events.EventManager;
	 * import net.guttershark.events.delegates.FLVPlaybackEventListenerDelegate;
	 * var em:EventManager = EventManager.gi();
	 * em.addEventListenerDelegate(FLVPlayback,FLVPlaybackEventListenerDelegate);
	 * em.handleEvents(myFLVPlayback,this,"onMyFLVPlayback");
	 * </listing>
	 * 
	 * @example Adding support for tracking:
	 * <listing>	
	 * import net.guttershark.events.EventManager;
	 * var em:EventManager = EventManager.gi():
	 * em.handleEvents(mc,this,"onMyMC",false,true);
	 * </listing>
	 * 
	 * <p>Supported TopLevel Flashplayer Objects and Events:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Object</strong></td><td><strong>Events</strong></td></tr>
	 * <tr><td>DisplayObject</td><td>Added,AddedToStage,Activate,Deactivate,Removed,RemovedFromStage</td>
	 * <tr><td>InteractiveObject</td><td>Click,MouseUp,MouseDown,MouseMove,MouseOver,MouseWheel,MouseOut,FocusIn,<br/>
	 * FocusOut,KeyFocusChange,MouseFocusChange,TabChildrenChange,TabIndexChange,TabEnabledChange</td></tr>
	 * <tr><td>Stage</td><td>Resize,Fullscreen,MouseLeave</td></tr>
	 * <tr><td>TextField</td><td>Change,Link</td></tr>
	 * <tr><td>Timer</td><td>Timer,TimerComplete</td></tr>
	 * <tr><td>Socket</td><td>Connect,Close,SocketData</td></tr>
	 * <tr><td>LoaderInfo</td><td>Complete,Unload,Init,Open,Progress</td></tr>
	 * <tr><td>Camera</td><td>Activity,Status</td></tr>
	 * <tr><td>Microphone</td><td>Activity,Status</td></tr>
	 * <tr><td>NetConnection</td><td>Status</td></tr>
	 * <tr><td>NetStream</td><td>Status</td></tr>
	 * <tr><td>FileReference</td><td>Cancel,Complete,Open,Select,UploadCompleteData</td></tr>
	 * </table>
	 * 
	 * <p>Supported Guttershark Classes:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Object</strong></td><td width="200"><strong>EventListenerDelegate</strong></td><td><strong>Events</strong></td></tr>
	 * <tr><td>PreloadController</td><td>PreloadControllerEventListenerDelegate</td><td>Complete,PreloadProgress</td></tr>
	 * </table>
	 * 
	 * <p>Supported Components:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Component</strong></td><td width="200"><strong>EventHandlerDelegate</strong></td><td><strong>Events</strong></td></tr>
	 * <tr><td>FLVPlayback</td><td>FLVPlaybackEventDelegate</td><td>Play,Pause,Stopped,PlayheadUpdate,StateChange,AutoRewound,Close,Complete,FastForward,Rewind,<br/>
	 * SkinLoaded,Seeked,ScrubStart,ScrubFinish,Ready,BufferState</td></tr>
	 * <tr><td>Button (Inherits Events)</td><td>Change,LabelChange,ButtonDown</td><td></td></tr>
	 * </table>
	 * 
	 * <p>To support any of those components, you must first add the event handler delegate
	 * to the event manager. See the example above for using the FLVPlaybackEventDelegate</p>
	 * 
	 * <p>Non-negotiable event types that always pass event objects to your callbacks:</p>
	 * <ul>
	 * <li>ActivityEvent.ACTIVITY</li>
	 * <li>ColorPickerEvent.CHANGE</li>
	 * <li>ComponentEvent.LABEL_CHANGE</li>
	 * <li>DataEvent.UPLOAD_COMPLETE_DATA</li>
	 * <li>KeyboardEvent.KEY_UP</li>
	 * <li>KeyboardEvent.KEY_DOWN</li>
	 * <li>MouseEvent.MOUSE_WHEEL</li>
	 * <li>PreloadProgressEvent.PROGRESS</li>
	 * <li>ScrollEvent.SCROLL</li>
	 * <li>StatusEvent.STATUS</li>
	 * <li>TextEvent.LINK</li>
	 * <li>VideoEvent.PLAYHEAD_UPDATE</li>
	 * </ul>
	 */
	public class EventManager implements IDisposable
	{
		
		/**
		 * singleton instance
		 */
		private static var instance:EventManager;
		
		/**
		 * Stores info about objects.
		 */
		private var edinfo:Dictionary;
		
		/**
		 * Holds callback descriptions.
		 */
		private var verifiedMethods:Dictionary;

		/**
		 * Custom handlers.
		 */
		private var handlers:Dictionary;
		private var h:Dictionary;
		
		/**
		 * Custom handler instances.
		 */
		private var instances:Dictionary;
		
		/**
		 * lookup for interactive objects events.
		 */
		private var eventsByObject:Dictionary;

		/**
		 * Singleton access.
		 */
		public static function gi():EventManager
		{
			if(instance == null) instance = new EventManager();
			return instance;
		}
		
		/**
		 * @private
		 * Constructor for EventListenersDelegate instances.
		 */
		public function EventManager()
		{
			if(EventManager.instance) throw new Error("EventManager is a singleton, see EventManager.gi()");
			instances = new Dictionary();
			handlers = new Dictionary();
			edinfo = new Dictionary();
			eventsByObject = new Dictionary();
			h = new Dictionary();
			verifiedMethods = new Dictionary();
		}
		
		/**
		 * Add a custom IEventHandlerDelegate. The class must be 
		 * an implementation of IEventHandlerDelegate.
		 * 
		 * <p>You must specify EventTypes.CUSTOM when you call "handleEvents()"
		 * on an object that needs to use one of the custom handlers</p>
		 */
		public function addEventListenerDelegate(klassOfObject:Class, klassHandler:Class):void
		{
			handlers[klassHandler] = klassOfObject;
			h[klassOfObject] = klassHandler;
		}

		/**
		 * Add auto event handling for a target object.
		 * 
		 * @param	obj	The object to add event listeners too.
		 * @param   callbackDelegate	The object in which your callback methods are defined.
		 * @param	callbackPrefix	A prefix for all callback function definitions.
		 * @param	returnEventObjects	Whether or not to pass the origin event objects back to your callbacks (with exception of non-negotiable event types).
		 * @param	cycleThroughTracking	Whether or not to pass all function calls (onMyClipClick) for the obj - through the tracking framework.
		 */
		public function handleEvents(obj:IEventDispatcher, callbackDelegate:*, callbackPrefix:String, returnEventObjects:Boolean = false, cycleThroughTracking:Boolean = false):void
		{
			edinfo[obj] = {};
			edinfo[obj].callbackDelegate = callbackDelegate;
			edinfo[obj].callbackPrefix = callbackPrefix;
			edinfo[obj].passEventObjects = returnEventObjects;
			edinfo[obj].passThroughTracking = cycleThroughTracking;
			
			if(obj is Timer)
			{
				if((callbackPrefix + "Timer") in callbackDelegate) obj.addEventListener(TimerEvent.TIMER, onTimer,false,0,true);
				if((callbackPrefix + "TimerComplete") in callbackDelegate) obj.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete,false,0,true); 
				return;
			}
			
			if(obj is LoaderInfo || obj is URLLoader)
			{
				if((callbackPrefix + "Complete") in callbackDelegate) obj.addEventListener(Event.COMPLETE, onLIComplete,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate) obj.addEventListener(Event.OPEN, onLIOpen,false,0,true);
				if((callbackPrefix + "Unload") in callbackDelegate) obj.addEventListener(Event.UNLOAD, onLIUnload,false,0,true);
				if((callbackPrefix + "Init") in callbackDelegate) obj.addEventListener(Event.INIT, onLIInit,false,0,true);
				if((callbackPrefix + "Progress") in callbackDelegate) obj.addEventListener(ProgressEvent.PROGRESS, onLIProgress,false,0,true);
				return;
			}
			
			if(obj is Camera || obj is Microphone)
			{
				if((callbackPrefix + "Activity") in callbackDelegate) obj.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity,false,0,true);
				if((callbackPrefix + "Status") in callbackDelegate) obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is Socket)
			{
				if((callbackPrefix + "Close") in callbackDelegate) obj.addEventListener(Event.CLOSE, onSocketClose,false,0,true);
				if((callbackPrefix + "Connect") in callbackDelegate) obj.addEventListener(Event.CONNECT, onSocketConnect,false,0,true);
				if((callbackPrefix + "SocketData") in callbackDelegate) obj.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData,false,0,true);
				return;
			}
			
			if(obj is NetConnection)
			{
				if((callbackPrefix + "CameraStatus") in callbackDelegate) obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is NetStream)
			{
				if((callbackPrefix + "Status") in callbackDelegate) obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is FileReference)
			{
				if((callbackPrefix + "Cancel") in callbackDelegate) obj.addEventListener(Event.CANCEL, onFRCancel,false,0,true);
				if((callbackPrefix + "Complete") in callbackDelegate) obj.addEventListener(Event.COMPLETE, onFRComplete,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate) obj.addEventListener(Event.OPEN,onFROpen,false,0,true);
				if((callbackPrefix + "Select") in callbackDelegate) obj.addEventListener(Event.SELECT, onFRSelect,false,0,true);
				if((callbackPrefix + "UploadCompleteData") in callbackDelegate) obj.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onFRUploadCompleteData,false,0,true);
			}
			
			if(obj is TextField)
			{
				if((callbackPrefix + "Change") in callbackDelegate) obj.addEventListener(Event.CHANGE, onTextFieldChange,false,0,true);
				if((callbackPrefix + "Link") in callbackDelegate) obj.addEventListener(TextEvent.LINK, onTextFieldLink,false,0,true);
			}
			
			for each(var objType:Class in handlers)
			{
				if(obj is objType)
				{
					var i:* = new h[objType]();
					i.eventHandlerFunction = this.handleEvent;
					instances[obj] = i;
					i.addListeners(obj);
				}
			}
			
			if(obj is InteractiveObject)
			{
				if((callbackPrefix + "Resize") in callbackDelegate) obj.addEventListener(Event.RESIZE, onStageResize,false,0,true);
				if((callbackPrefix + "Fullscreen") in callbackDelegate) obj.addEventListener(Event.FULLSCREEN, onStageFullscreen,false,0,true);
				if((callbackPrefix + "Added") in callbackDelegate) obj.addEventListener(Event.ADDED,onDOAdded,false,0,true);
				if((callbackPrefix + "AddedToStage") in callbackDelegate) obj.addEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage,false,0,true);
				if((callbackPrefix + "Activate") in callbackDelegate) obj.addEventListener(Event.ACTIVATE,onDOActivate,false,0,true);
				if((callbackPrefix + "Deactivate") in callbackDelegate) obj.addEventListener(Event.DEACTIVATE,onDODeactivate,false,0,true);
				if((callbackPrefix + "Removed") in callbackDelegate) obj.addEventListener(Event.REMOVED,onDORemoved,false,0,true);
				if((callbackPrefix + "RemovedFromStage") in callbackDelegate) obj.addEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage,false,0,true);
				if((callbackPrefix + "MouseLeave") in callbackDelegate) obj.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave,false,0,true);
				if((callbackPrefix + "Click") in callbackDelegate) obj.addEventListener(MouseEvent.CLICK,onIOClick);
				if((callbackPrefix + "DoubleClick") in callbackDelegate) obj.addEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick,false,0,true);
				if((callbackPrefix + "MouseDown") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown,false,0,true);
				if((callbackPrefix + "MouseMove") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove,false,0,true);
				if((callbackPrefix + "MouseUp") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_UP,onIOMouseUp,false,0,true);
				if((callbackPrefix + "MouseOut") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut,false,0,true);
				if((callbackPrefix + "MouseOver") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver,false,0,true);
				if((callbackPrefix + "MouseWheel") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel,false,0,true);
				if((callbackPrefix + "RollOut") in callbackDelegate) obj.addEventListener(MouseEvent.ROLL_OUT, onIORollOut,false,0,true);
				if((callbackPrefix + "RollOver") in callbackDelegate) obj.addEventListener(MouseEvent.ROLL_OVER,onIORollOver,false,0,true);
				if((callbackPrefix + "FocusIn") in callbackDelegate) obj.addEventListener(FocusEvent.FOCUS_IN,onIOFocusIn,false,0,true);
				if((callbackPrefix + "FocusOut") in callbackDelegate) obj.addEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut,false,0,true);
				if((callbackPrefix + "KeyFocusChange") in callbackDelegate) obj.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange,false,0,true);
				if((callbackPrefix + "MouseFocusChange") in callbackDelegate) obj.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange,false,0,true);
				if((callbackPrefix + "TabChildrenChange") in callbackDelegate) obj.addEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange,false,0,true);
				if((callbackPrefix + "TabEnabledChange") in callbackDelegate) obj.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange,false,0,true);
				if((callbackPrefix + "TabIndexChange") in callbackDelegate) obj.addEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange,false,0,true);
				if((callbackPrefix + "KeyDown") in callbackDelegate) obj.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
				if((callbackPrefix + "KeyUp") in callbackDelegate) obj.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
			}
		}
		
		private function onFRCancel(e:Event):void
		{
			handleEvent(e, "Cancel");
		}
		
		private function onFRComplete(e:Event):void
		{
			handleEvent(e,"Complete");
		}
		
		private function onFROpen(e:Event):void
		{
			handleEvent(e,"Open");
		}
		
		private function onFRSelect(e:Event):void
		{
			handleEvent(e,"Select");
		}
		
		private function onFRUploadCompleteData(de:DataEvent):void
		{
			handleEvent(de,"UploadCompleteData",true);
		}
		
		private function onSocketClose(e:Event):void
		{
			handleEvent(e, "Close");
		}
		
		private function onSocketConnect(e:Event):void
		{
			handleEvent(e, "Connect");
		}
		
		private function onSocketData(pe:ProgressEvent):void
		{
			handleEvent(pe, "SocketData");
		}

		private function onCameraActivity(ae:ActivityEvent):void
		{
			handleEvent(ae, "Activity");
		}
	
		private function onCameraStatus(ae:StatusEvent):void
		{
			handleEvent(ae, "Status", true);
		}

		private function onLIProgress(pe:ProgressEvent):void
		{
			handleEvent(pe, "Progress");
		}

		private function onLIInit(e:Event):void
		{
			handleEvent(e, "Init");
		}
		
		private function onLIUnload(e:Event):void
		{
			handleEvent(e, "Unload");
		}
		
		private function onLIOpen(e:Event):void
		{
			handleEvent(e, "Open");
		}
		 
		private function onLIComplete(e:Event):void
		{
			handleEvent(e, "Complete");
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			handleEvent(e,"KeyDown",true);
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			handleEvent(e,"KeyUp",true);
		}
		
		private function onTabChildrenChange(e:Event):void
		{
			handleEvent(e,"TabChildrenChange");
		}
		
		private function onTabEnabledChange(e:Event):void
		{
			handleEvent(e,"TabEnabledChange");
		}
		
		private function onTabIndexChange(e:Event):void
		{
			handleEvent(e,"TabIndexChange");
		}
		
		private function onTextFieldChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onTextFieldLink(e:TextEvent):void
		{
			handleEvent(e,"Link",true);
		}
		
		private function onStageFullscreen(e:Event):void
		{
			handleEvent(e,"Fullscreen");
		}
		
		private function onStageResize(e:Event):void
		{
			handleEvent(e,"Resize");
		}
		
		private function onStageMouseLeave(e:Event):void
		{
			handleEvent(e,"MouseLeave");
		}
		
		private function onTimer(e:Event):void
		{
			handleEvent(e,"Timer");
		}
		
		private function onTimerComplete(e:Event):void
		{
			handleEvent(e,"TimerComplete");
		}
		
		private function onIORollOver(e:MouseEvent):void
		{
			handleEvent(e,"RollOver");
		}
		
		private function onIORollOut(e:MouseEvent):void
		{
			handleEvent(e,"RollOut");
		}

		private function onIOFocusIn(e:Event):void
		{
			handleEvent(e,"FocusIn");
		}
		
		private function onIOFocusOut(e:Event):void
		{
			handleEvent(e,"FocusOut");
		}
		
		private function onIOKeyFocusChange(e:Event):void
		{
			handleEvent(e,"KeyFocusChange");
		}
		
		private function onIOMouseFocusChange(e:Event):void
		{
			handleEvent(e,"MouseFocusChange");
		}
		
		private function onDOAdded(e:Event):void
		{
			handleEvent(e,"Added");
		}

		private function onDOAddedToStage(e:Event):void
		{
			handleEvent(e,"AddedToStage");
		}
		
		private function onDOActivate(e:Event):void
		{
			handleEvent(e,"Activate");
		}
		
		private function onDODeactivate(e:Event):void
		{
			handleEvent(e,"Deactivate");
		}
		
		private function onDORemoved(e:Event):void
		{
			handleEvent(e,"Removed");
		}
		
		private function onDORemovedFromStage(e:Event):void
		{
			handleEvent(e,"RemovedFromStage");
		}

		private function onIOClick(e:MouseEvent):void
		{
			handleEvent(e,"Click");
		}
		
		private function onIODoubleClick(e:MouseEvent):void
		{
			handleEvent(e,"DoubleClick");
		}
		
		private function onIOMouseDown(e:MouseEvent):void
		{
			handleEvent(e,"MouseDown");
		}
		
		private function onIOMouseMove(e:MouseEvent):void
		{
			handleEvent(e,"MouseMove");
		}
		
		private function onIOMouseOver(e:MouseEvent):void
		{
			handleEvent(e,"MouseOver");
		}
		
		private function onIOMouseOut(e:MouseEvent):void
		{
			handleEvent(e,"MouseOut");
		}
		
		private function onIOMouseUp(e:MouseEvent):void
		{
			handleEvent(e,"MouseUp");
		}
	
		private function onIOMouseWheel(e:MouseEvent):void
		{
			handleEvent(e,"MouseWheel",true);
		}
		
		/**
		 * Generic method used to handle all events, and possibly call
		 * the callback on the defined callback delegate.
		 */
		private function handleEvent(e:*, func:String, forceEventObjectPass:Boolean = false):void
		{
			var obj:IEventDispatcher = IEventDispatcher(e.currentTarget);
			if(!edinfo[obj]) return;
			var info:Object = Object(edinfo[obj]);
			var f:String = info.callbackPrefix + func;
			if(info.passThroughTracking) Tracking.TrackFromEventManager(f);
			if(!(f in info.callbackDelegate)) return;
			if(info.passEventObjects || forceEventObjectPass) info.callbackDelegate[f](e);
			else info.callbackDelegate[f]();
		}
		
		/**
		 * Dispose of events for an object that was being managed by this event manager.
		 * 
		 * @param	obj	The object in which events are being managed in this manager.
		 */
		public function disposeEventsForObject(obj:*):void
		{
			var callbackPrefix:String = edinfo[obj].callbackPrefix;
			var callbackDelegate:* = edinfo[obj].callbackDelegate;
			
			if(obj is Timer)
			{
				if((callbackPrefix + "Timer") in callbackDelegate) obj.removeEventListener(TimerEvent.TIMER, onTimer,false,0,true);
				if((callbackPrefix + "TimerComplete") in callbackDelegate) obj.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete,false,0,true); 
				return;
			}
			
			if(obj is LoaderInfo || obj is URLLoader)
			{
				if((callbackPrefix + "Complete") in callbackDelegate) obj.removeEventListener(Event.COMPLETE, onLIComplete,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate) obj.removeEventListener(Event.OPEN, onLIOpen,false,0,true);
				if((callbackPrefix + "Unload") in callbackDelegate) obj.removeEventListener(Event.UNLOAD, onLIUnload,false,0,true);
				if((callbackPrefix + "Init") in callbackDelegate) obj.removeEventListener(Event.INIT, onLIInit,false,0,true);
				if((callbackPrefix + "Progress") in callbackDelegate) obj.removeEventListener(ProgressEvent.PROGRESS, onLIProgress,false,0,true);
				return;
			}
			
			if(obj is Camera || obj is Microphone)
			{
				if((callbackPrefix + "Activity") in callbackDelegate) obj.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity,false,0,true);
				if((callbackPrefix + "Status") in callbackDelegate) obj.removeEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is Socket)
			{
				if((callbackPrefix + "Close") in callbackDelegate) obj.removeEventListener(Event.CLOSE, onSocketClose,false,0,true);
				if((callbackPrefix + "Connect") in callbackDelegate) obj.removeEventListener(Event.CONNECT, onSocketConnect,false,0,true);
				if((callbackPrefix + "SocketData") in callbackDelegate) obj.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData,false,0,true);
				return;
			}
			
			if(obj is NetConnection)
			{
				if((callbackPrefix + "CameraStatus") in callbackDelegate) obj.removeEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is NetStream)
			{
				if((callbackPrefix + "Status") in callbackDelegate) obj.removeEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is FileReference)
			{
				if((callbackPrefix + "Cancel") in callbackDelegate) obj.removeEventListener(Event.CANCEL, onFRCancel,false,0,true);
				if((callbackPrefix + "Complete") in callbackDelegate) obj.removeEventListener(Event.COMPLETE, onFRComplete,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate) obj.removeEventListener(Event.OPEN,onFROpen,false,0,true);
				if((callbackPrefix + "Select") in callbackDelegate) obj.removeEventListener(Event.SELECT, onFRSelect,false,0,true);
				if((callbackPrefix + "UploadCompleteData") in callbackDelegate) obj.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onFRUploadCompleteData,false,0,true);
			}
			
			if(obj is TextField)
			{
				if((callbackPrefix + "Change") in callbackDelegate) obj.removeEventListener(Event.CHANGE, onTextFieldChange,false,0,true);
				if((callbackPrefix + "Link") in callbackDelegate) obj.removeEventListener(TextEvent.LINK, onTextFieldLink,false,0,true);
			}
			
			if(obj is InteractiveObject)
			{
				if((callbackPrefix + "Resize") in callbackDelegate) obj.removeEventListener(Event.RESIZE, onStageResize,false,0,true);
				if((callbackPrefix + "Fullscreen") in callbackDelegate) obj.removeEventListener(Event.FULLSCREEN, onStageFullscreen,false,0,true);
				if((callbackPrefix + "Added") in callbackDelegate) obj.removeEventListener(Event.ADDED,onDOAdded,false,0,true);
				if((callbackPrefix + "AddedToStage") in callbackDelegate) obj.removeEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage,false,0,true);
				if((callbackPrefix + "Activate") in callbackDelegate) obj.removeEventListener(Event.ACTIVATE,onDOActivate,false,0,true);
				if((callbackPrefix + "Deactivate") in callbackDelegate) obj.removeEventListener(Event.DEACTIVATE,onDODeactivate,false,0,true);
				if((callbackPrefix + "Removed") in callbackDelegate) obj.removeEventListener(Event.REMOVED,onDORemoved,false,0,true);
				if((callbackPrefix + "RemovedFromStage") in callbackDelegate) obj.removeEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage,false,0,true);
				if((callbackPrefix + "MouseLeave") in callbackDelegate) obj.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave,false,0,true);
				if((callbackPrefix + "Click") in callbackDelegate) obj.removeEventListener(MouseEvent.CLICK,onIOClick);
				if((callbackPrefix + "DoubleClick") in callbackDelegate) obj.removeEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick,false,0,true);
				if((callbackPrefix + "MouseDown") in callbackDelegate) obj.removeEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown,false,0,true);
				if((callbackPrefix + "MouseMove") in callbackDelegate) obj.removeEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove,false,0,true);
				if((callbackPrefix + "MouseUp") in callbackDelegate) obj.removeEventListener(MouseEvent.MOUSE_UP,onIOMouseUp,false,0,true);
				if((callbackPrefix + "MouseOut") in callbackDelegate) obj.removeEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut,false,0,true);
				if((callbackPrefix + "MouseOver") in callbackDelegate) obj.removeEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver,false,0,true);
				if((callbackPrefix + "MouseWheel") in callbackDelegate) obj.removeEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel,false,0,true);
				if((callbackPrefix + "RollOut") in callbackDelegate) obj.removeEventListener(MouseEvent.ROLL_OUT, onIORollOut,false,0,true);
				if((callbackPrefix + "RollOver") in callbackDelegate) obj.removeEventListener(MouseEvent.ROLL_OVER,onIORollOver,false,0,true);
				if((callbackPrefix + "FocusIn") in callbackDelegate) obj.removeEventListener(FocusEvent.FOCUS_IN,onIOFocusIn,false,0,true);
				if((callbackPrefix + "FocusOut") in callbackDelegate) obj.removeEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut,false,0,true);
				if((callbackPrefix + "KeyFocusChange") in callbackDelegate) obj.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange,false,0,true);
				if((callbackPrefix + "MouseFocusChange") in callbackDelegate) obj.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange,false,0,true);
				if((callbackPrefix + "TabChildrenChange") in callbackDelegate) obj.removeEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange,false,0,true);
				if((callbackPrefix + "TabEnabledChange") in callbackDelegate) obj.removeEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange,false,0,true);
				if((callbackPrefix + "TabIndexChange") in callbackDelegate) obj.removeEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange,false,0,true);
				if((callbackPrefix + "KeyDown") in callbackDelegate) obj.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
				if((callbackPrefix + "KeyUp") in callbackDelegate) obj.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
			}
			
			if(instances[obj])
			{
				instances[obj].dispose();
				instances[obj] = null;
			}
			if(edinfo[obj]) edinfo[obj] = null;
		}
		
		public function dispose():void
		{
			for each(var instance:* in instances)
			{
				instance.dispose();
			}
			instances = null;
			handlers = null;
		}	
	}}