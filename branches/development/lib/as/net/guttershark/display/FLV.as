﻿package net.guttershark.display
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import net.guttershark.managers.AssetManager;
	import net.guttershark.support.events.FLVEvent;
	import net.guttershark.util.MathUtils;
	/**
		/**
		protected var url:String;