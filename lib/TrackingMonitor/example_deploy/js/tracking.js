var tracking;
var gDomain="m.webtrends.com";
var gDcsId="";
var gFpc="WT_FPC";
var ganalyticsUA = "UA-xxxxxx-x";
var pageTracker;

/* webtrends */
if(document.cookie.indexOf(gFpc + "=") == -1)
{
	document.write("<script type='text/javascript' src='http" + (window.location.protocol.indexOf('https:')==0 ? 's' : '') + "://" + gDomain + "/" + gDcsId + "/wtid.js" + "'><\/script>");
}

/* google analytics */
if(ganalyticsUA != "UA-xxxxxx-x")
{
	pageTracker = _gat._getTracker(ganalyticsUA);
	pageTracker._initData();
}

function Tracking()
{
	this.xmlDoc = null;
}

function setupTracking(xmlFile, monitorDelegateID, monitorIsSWF)
{
	tracking = new Tracking();
	tracking.trackingMonitorDelegateID = monitorDelegateID;
	tracking.monitorIsSWF = monitorIsSWF;
	tracking.loadXML(xmlFile);
}

function attemptToSetTrackingMonitorForSWFOBject()
{
	try{
		tracking.monitorDelegate = swfobject.getObjectById(tracking.trackingMonitorDelegateID);
	}catch(e){alert(e);}
	tracking.attemptedMonitor = true;
}

function attempToSetTrackingMonitorForOther()
{
	try{
		tracking.monitorDelegate = document.getElementById(tracking.trackingMonitorDelegateID);
	}catch(e){}
	tracking.attemptedMonitor = true;
}

function flashTrack(xmlid,appendData)
{
	tracking.track(xmlid,appendData);
}

function trackForId(xmlid,appendArr)
{
	atlas(xmlid);
	webtrends(xmlid,appendArr);
	_ganalytics(xmlid);
}

function track(xmlid,appendData)
{
	try
	{
		if(!tracking.attemptedMonitor)
		{
			if(tracking.monitorIsSWF) attemptToSetTrackingMonitorForSWFOBject();
			else attempToSetTrackingMonitorForOther();
		}
	}
	catch(e)
	{
		alert(e);
	}
	
	var target;
	var wp;
	var redirect;
	var info = getTrackingInfo(xmlid);
	trackForId(xmlid,appendData);
	target = "_self";
	try
	{
		if(info.target) target = info.target;
	}
	catch(e){}
	try
	{
		wp = info.windowParameters;
	}
	catch(e){}
	try
	{
		redirect = info.redirect;
	}
	catch(e){}
	if(!redirect) return;
	if(wp) window.open(info.redirect,target,wp);
	else window.open(info.redirect,target);
}

function _ganalytics(xmlid)
{
	var info = this.getTrackingInfo(xmlid);
	if(!info.ganalytics) return;
	try
	{
		try
		{
			pageTracker._trackPageview(info.ganalytics.toString());
		}
		catch(e)
		{
			if(tracking.monitorDelegate) monitorTrack("ga::Error! pageTracker not defined in document.")
			return;
		}
		if(tracking.monitorDelegate) monitorTrack("ga::" + info.ganalytics.toString());
	}
	catch(e){}
}

function webtrends(xmlid,appendArr)
{
	var info = this.getTrackingInfo(xmlid);
	if(!info.webtrends) return;
	var webtrends = info.webtrends;
	try
	{
		//break out to the delegate. 
		if(webtrendsDelegate != null) webtrendsDelegate(webtrends.toString(), appendArr);
	}
	catch(e){}
}

/* does the webtrends work */
function webtrendsDelegate(tagStr,appendArr)
{
	var parts = tagStr.split(",");
	var dcsuri = parts[0];
	var ti = parts[1];
	var cg_n = parts[2];
	
	if(appendArr)
	{
		if(appendArr[0] != null) dcsuri += appendArr[0];
		if(appendArr[1] != null) ti += appendArr[1];
		if(appendArr[2] != null) cg_n += appendArr[2];
	}
	try
	{
		//dcsMultiTrack accepts "pairs" of parameters. 
		//so the odd parameter is the name of the next
		//even parameter. So parameters 0 -> 'DCS.dcsuri'
		//is the name of the next value -> dcsuri.
		//alert('DCS.dcsuri: ' + dcsuri + ' WT.ti: ' + ti + ' WT_cg_n: ' + cg_n);
		dcsMultiTrack('DCS.dcsuri',dcsuri,'WT.ti',ti,'WT_cg_n',cg_n);		
		
		//try tracking monitor
		if(tracking.monitorDelegate)
		{
			//re-create the tag from split pieces, plus grabbing any appended data.
			//and add atlas:: identifier.
			var newtag = "wt::" + dcsuri + "," + ti + "," + cg_n;
			monitorTrack(newtag);
		}
	}
	catch(e)
	{
		if(tracking.monitorDelegate) monitorTrack("wt::Error! dcsMultiTrack not defined in document.");
	}
}

function atlas(xmlid)
{
	var info = getTrackingInfo(xmlid);
	if(!info.atlas) return;
	var timestamp = new Date();
	var qs = "?qstr=random=" + Math.ceil(Math.random() * 99999999)+timestamp.getUTCFullYear()+timestamp.getUTCMonth()+timestamp.getUTCDate()+timestamp.getUTCHours()+timestamp.getUTCMinutes()+timestamp.getUTCSeconds()+timestamp.getUTCMilliseconds();
	var uri = info.atlas + qs;
	document.getElementById("atlas_tag").src = uri;
	if(tracking.monitorDelegate) monitorTrack("al::" + uri);
}

function monitorTrack(msg)
{
	try
	{
		if(tracking.monitorDelegate) tracking.monitorDelegate.tracked(msg);
	}catch(e)
	{
		alert(e);
	}
}

function createXMLHttpRequest()
{
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	else if (typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	else throw new Error("XMLHttpRequest not supported");
}

function loadXML(file)
{
 	var request = this.createXMLHttpRequest();
	request.open("GET", file, true);
	request.onreadystatechange = function()
	{
		if(request.readyState == 4)
		{	
			xmlDoc = request.responseXML;
		}
	}
	request.send(null);
}

function getTrackingInfo(xmlid)
{
	var trackNodes = xmlDoc.getElementsByTagName("track");
	var index;
	var i = 0;
	var results = {};
	for(i = 0; i < trackNodes.length; i++)
	{
		if(xmlid == trackNodes[i].attributes.getNamedItem("id").value)
		{
			index = i;
		}
	}
	if(null == index) return index;
	try
	{
		var w = trackNodes[index].getElementsByTagName("webtrends").item(0).firstChild.nodeValue;
		results.webtrends = w;
	}
	catch(e){}
	try
	{
		var a = trackNodes[index].getElementsByTagName("atlas").item(0).firstChild.nodeValue;
		results.atlas = a;
	}
	catch(e){}
	try
	{
		var g = trackNodes[index].getElementsByTagName("ganalytics").item(0).firstChild.nodeValue;
		results.ganalytics = g;
	}
	catch(e){}
	try
	{
		var r = trackNodes[index].getElementsByTagName("redirect").item(0).firstChild.nodeValue;
		results.redirect = r;
	}
	catch(e){}
	try
	{
		var rt = trackNodes[index].getElementsByTagName("redirect").item(0).attributes.getNamedItem("target").value
		results.target = rt;
	}
	catch(e){}
	try
	{
		wp = trackNodes[index].getElementsByTagName("redirect").item(0).attributes.getNamedItem("windowParameters").value
		results.windowParameters = wp;
	}
	catch(err){}
	return results;
}

Tracking.prototype.createXMLHttpRequest = createXMLHttpRequest;
Tracking.prototype.attemptedMonitor = false;
Tracking.prototype.monitorDelegate = null;
Tracking.prototype.trackingMonitorDelegateID = null;
Tracking.prototype.monitorIsSWF = null;
Tracking.prototype.loadXML = loadXML;
Tracking.prototype.track = track;
Tracking.prototype.trackForId = trackForId;
Tracking.prototype.webtrends = webtrends;
Tracking.prototype.atlas = atlas;
Tracking.prototype.getTrackingInfo = getTrackingInfo;