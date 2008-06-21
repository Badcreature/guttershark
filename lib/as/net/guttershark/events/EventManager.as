package net.guttershark.events 
{
	import flash.display.MovieClip;	
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
	 * <p>The EventManager class also allows you to create custom EventHandlerDelegate classes
	 * to use with custom events, or components that aren't supported by default.</p> 
	 * 
	 * <p>All events can circulate through the Tracking class to implement tracking
	 * for you base off of any event that is being managed.</p>
	 * 
	 * @example Using EventManager with a MovieClip.
	 * <listing>	
	 * import net.guttershark.events.EventManager;
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
	 *       em.handleEvents(mc,this,"onCircle", EventTypes.MOUSE | EventTypes.STAGE);
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
	 * import net.guttershark.events.EventTypes;
	 * import net.guttershark.events.delegates.FLVPlaybackEventListenerDelegate;
	 * var em:EventManager = EventManager.gi();
	 * em.addEventListenerDelegate(FLVPlayback,FLVPlaybackEventListenerDelegate);
	 * em.handleEvents(myFLVPlayback,this,"onMyFLVPlayback",EventTypes.CUSTOM);
	 * </listing>
	 * 
	 * @example Adding support for tracking:
	 * <listing>	
	 * import net.guttershark.events.EventManager;
	 * var em:EventManager = EventManager.gi():
	 * em.handleEvents(mc,this,"onMyMC",EventTypes.MOUSE,false,true);
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
	 * </table>
	 * 
	 * <p>InteractiveObject Event Groups:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Group Name</strong></td><td><strong>Includes Events</strong></td></tr>
	 * <tr><td>Mouse Events</td><td>Click,MouseUp,MouseDown,MouseMove,MouseOver,MouseWheel,MouseOut,RollOver,RollOut</td>
	 * <tr><td>Focus Events</td><td>FocusIn,FocusOut,KeyFocusChange,MouseFocusChange</td>
	 * <tr><td>Stage Events</td><td>Resize,Fullscreen,MouseLeave,Added,AddedToStage,Activate,Deactivate,Removed,RemovedFromStage</td>
	 * <tr><td>Text Events</td><td>Change,Link</td></tr>
	 * <tr><td>Tab Events</td><td>TabChildrenChange,TabIndexChange,TabEnabledChange</td></tr>
	 * <tr><td>Custom Events</td><td>Pass the target IEventDispatcher through all custom handlers</td></tr>
	 * </table>
	 * 
	 * <p>Supported Guttershark Classes:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Object</strong></td><td width="200">EventListenerDelegate</td><td><strong>Events</strong></td></tr>
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
	 * <li>KeyboardEvent.KEY_UP</li>
	 * <li>KeyboardEvent.KEY_DOWN</li>
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
		 * Stores bit shifts for the enumeration of values in EventTypes.
		 */
		private var shifts:Dictionary;
		
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
		 * Default event types.
		 */
		private var _defaultTypes:int;

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
			shifts = new Dictionary();
			eventsByObject = new Dictionary();
			h = new Dictionary();
			verifiedMethods = new Dictionary();
			shifts[EventTypes.STAGE] = 0;
			shifts[EventTypes.MOUSE] = 1;
			shifts[EventTypes.FOCUS] = 2;
			shifts[EventTypes.TABS] = 3;
			shifts[EventTypes.KEYS] = 4;
			shifts[EventTypes.CUSTOM] = 5;
		}

		/**
		 * Set the defualt EventTypes so you don't have to keep repeating them. You
		 * can set the defaultEventTypes at any time. As an example, if you are using
		 * EventManager to delegate events for 10 movie clips that all need mouse events
		 * and stage events. You would set the defaultEventTypes to (EventTypes.MOUSE | EventTypes.STAGE).
		 * Then say you need to use the EventManager to delegate events for 10 more MovieClips
		 * but you don't need stage events. You can set the defaultEventTypes to EventTypes.MOUSE.
		 * 
		 * <p>You can clear the defaultEventTypes by setting it to 0, or by calling
		 * <code><em>clearDefaultEventTypes()</em></strong>
		 * 
		 * <p><strong>Important:</strong> If you specify EventTypes in the handleEvents() method,
		 * it overrides defaultEventTypes.</p>
		 * 
		 * @example Setting default event types. 
		 * <listing>	
		 * EventManager.gi().defaultEventTypes = EventTypes.MOUSE | EventTypes.STAGE;
		 * </listing>
		 */
		public function set defaultEventTypes(eventTypes:int):void
		{
			_defaultTypes = eventTypes;
		}
		
		/**
		 * Clear the defaultEventTypes if set.
		 */
		public function clearDefaultEventTypes():void
		{
			_defaultTypes = 0;
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
		 * Setup event handling.
		 * 
		 * @param	obj	The object to add event listeners too.
		 * @param   callbackDelegate	The object in which your callback methods are defined.
		 * @param	callbackPrefix	A prefix for all callback function definitions.
		 * @param	eventTypes	Event types to listen for. Provided by bitwise OR'ing values from the EventTypes class. You must use EventTypes.CUSTOM if you want to use custom event handler delegates.
		 * @param	passEventObjects	Whether or not to pass the origin event objects back to your callbacks (with exception of non-negotiable event types).
		 * @param	passThroughTracking	Whether or not to pass all function calls (onMyClipClick) for the obj - through the tracking framework.
		 */
		public function handleEvents(obj:IEventDispatcher, callbackDelegate:*, callbackPrefix:String, eventTypes:int = 0, passEventObjects:Boolean = false, passThroughTracking:Boolean = false):void
		{
			edinfo[obj] = {};
			edinfo[obj].callbackDelegate = callbackDelegate;
			edinfo[obj].callbackPrefix = callbackPrefix;
			edinfo[obj].passEventObjects = passEventObjects;
			edinfo[obj].passThroughTracking = passThroughTracking;
			
			if(obj is Timer)
			{
				obj.addEventListener(TimerEvent.TIMER, onTimer,false,0,true);
				obj.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete,false,0,true);
				return;
			}
			
			if(obj is LoaderInfo || obj is URLLoader)
			{
				obj.addEventListener(Event.COMPLETE, onLIComplete,false,0,true);
				obj.addEventListener(Event.OPEN, onLIOpen,false,0,true);
				obj.addEventListener(Event.UNLOAD, onLIUnload,false,0,true);
				obj.addEventListener(Event.INIT, onLIInit,false,0,true);
				obj.addEventListener(ProgressEvent.PROGRESS, onLIProgress,false,0,true);
				return;
			}
			
			if(obj is Camera || obj is Microphone)
			{
				obj.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity,false,0,true);
				obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is Socket)
			{
				obj.addEventListener(Event.CLOSE, onSocketClose,false,0,true);
				obj.addEventListener(Event.CONNECT, onSocketConnect,false,0,true);
				obj.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData,false,0,true);
				return;
			}
			
			if(obj is NetConnection)
			{
				obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is NetStream)
			{
				obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			
			if(obj is TextField)
			{
				obj.addEventListener(Event.CHANGE, onTextFieldChange,false,0,true);
				obj.addEventListener(TextEvent.LINK, onTextFieldLink,false,0,true);
			}
			
			if((!_defaultTypes || _defaultTypes == 0) && eventTypes == 0) return;
			if(_defaultTypes > 0 && eventTypes < 1) eventTypes = _defaultTypes;
			
			if(eventTypes >> shifts[EventTypes.CUSTOM] & 1 == 1)
			{
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
			}
			
			if(obj is InteractiveObject)
			{
				if(eventTypes >> shifts[EventTypes.STAGE] & 1 == 1)
				{
					eventsByObject[obj] = new Dictionary();
					eventsByObject[obj][shifts[EventTypes.STAGE]] = true;
					obj.addEventListener(Event.RESIZE, onStageResize,false,0,true);
					obj.addEventListener(Event.FULLSCREEN, onStageFullscreen,false,0,true);
					obj.addEventListener(Event.ADDED,onDOAdded,false,0,true);
					obj.addEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage,false,0,true);
					obj.addEventListener(Event.ACTIVATE,onDOActivate,false,0,true);
					obj.addEventListener(Event.DEACTIVATE,onDODeactivate,false,0,true);
					obj.addEventListener(Event.REMOVED,onDORemoved,false,0,true);
					obj.addEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage,false,0,true);
					obj.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave,false,0,true);
				}
				
				if(eventTypes >> shifts[EventTypes.MOUSE] & 1 == 1)
				{
					eventsByObject[obj] = new Dictionary();
					eventsByObject[obj][shifts[EventTypes.MOUSE]] = true;
					obj.addEventListener(MouseEvent.CLICK,onIOClick);
					obj.addEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick,false,0,true);
					obj.addEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown,false,0,true);
					obj.addEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove,false,0,true);
					obj.addEventListener(MouseEvent.MOUSE_UP,onIOMouseUp,false,0,true);
					obj.addEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut,false,0,true);
					obj.addEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver,false,0,true);
					obj.addEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel,false,0,true);
					obj.addEventListener(MouseEvent.ROLL_OUT, onIORollOut,false,0,true);
					obj.addEventListener(MouseEvent.ROLL_OVER,onIORollOver,false,0,true);
				}
				
				//focus
				if(eventTypes >> shifts[EventTypes.FOCUS] & 1 == 1)
				{
					eventsByObject[obj] = new Dictionary();
					eventsByObject[obj][shifts[EventTypes.FOCUS]] = true;
					obj.addEventListener(FocusEvent.FOCUS_IN,onIOFocusIn,false,0,true);
					obj.addEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut,false,0,true);
					obj.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange,false,0,true);
					obj.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange,false,0,true);
				}
				
				//tab ones
				if(eventTypes >> shifts[EventTypes.TABS] & 1 == 1)
				{
					eventsByObject[obj] = new Dictionary();
					eventsByObject[obj][shifts[EventTypes.TABS]] = true;
					obj.addEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange,false,0,true);
					obj.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange,false,0,true);
					obj.addEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange,false,0,true);
				}
				
				//key events
				if(eventTypes >> shifts[EventTypes.KEYS] & 1 == 1)
				{
					eventsByObject[obj] = new Dictionary();
					eventsByObject[obj][shifts[EventTypes.KEYS]] = true;
					obj.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
					obj.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
				}
			}
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
			handleEvent(e,"MouseWheel");
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
			if(instance is InteractiveObject)
			{
				if(eventsByObject[obj][EventTypes.STAGE])
				{
					obj.removeEventListener(Event.RESIZE, onStageResize);
					obj.removeEventListener(Event.FULLSCREEN, onStageFullscreen);
					obj.removeEventListener(Event.ADDED,onDOAdded);
					obj.removeEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage);
					obj.removeEventListener(Event.ACTIVATE,onDOActivate);
					obj.removeEventListener(Event.DEACTIVATE,onDODeactivate);
					obj.removeEventListener(Event.REMOVED,onDORemoved);
					obj.removeEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage);
					obj.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
				}
				if(eventsByObject[obj][EventTypes.MOUSE])
				{
					obj.removeEventListener(MouseEvent.CLICK,onIOClick);
					obj.removeEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick);
					obj.removeEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown);
					obj.removeEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove);
					obj.removeEventListener(MouseEvent.MOUSE_UP,onIOMouseUp);
					obj.removeEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut);
					obj.removeEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver);
					obj.removeEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel);
					obj.removeEventListener(MouseEvent.ROLL_OUT, onIORollOut);
					obj.removeEventListener(MouseEvent.ROLL_OVER,onIORollOver);
				}
				
				if(eventsByObject[obj][EventTypes.FOCUS])
				{
					obj.removeEventListener(FocusEvent.FOCUS_IN,onIOFocusIn);
					obj.removeEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut);
					obj.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange);
					obj.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange);
				}
				
				if(eventsByObject[obj][EventTypes.TABS])
				{
					obj.removeEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange);
					obj.removeEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);
					obj.removeEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange);
				}
				
				if(eventsByObject[obj][EventTypes.KEYS])
				{
					obj.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
					obj.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}
			}
				
			if(obj is Timer)
			{
				obj.removeEventListener(TimerEvent.TIMER, onTimer);
				obj.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				return;
			}
			
			if(obj is LoaderInfo || obj is URLLoader)
			{
				obj.removeEventListener(Event.COMPLETE, onLIComplete);
				obj.removeEventListener(Event.OPEN, onLIOpen);
				obj.removeEventListener(Event.UNLOAD, onLIUnload);
				obj.removeEventListener(Event.INIT, onLIInit);
				obj.removeEventListener(ProgressEvent.PROGRESS, onLIProgress);
				return;
			}
			
			if(obj is Camera || obj is Microphone)
			{
				obj.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
				obj.removeEventListener(StatusEvent.STATUS, onCameraStatus);
				return;
			}
			
			if(obj is Socket)
			{
				obj.removeEventListener(Event.CLOSE, onSocketClose);
				obj.removeEventListener(Event.CONNECT, onSocketConnect);
				obj.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				return;
			}
			
			if(obj is NetConnection)
			{
				obj.removeEventListener(StatusEvent.STATUS, onCameraStatus);
				return;
			}
			
			if(obj is NetStream)
			{
				obj.removeEventListener(StatusEvent.STATUS, onCameraStatus);
				return;
			}
			
			if(obj is TextField)
			{
				obj.removeEventListener(Event.CHANGE, onTextFieldChange);
				obj.removeEventListener(TextEvent.LINK, onTextFieldLink);
				return;
			}
			
			if(instances[obj])
			{
				instances[obj].dispose();
				instances[obj] = null;
				edinfo[obj] = null;
			}
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