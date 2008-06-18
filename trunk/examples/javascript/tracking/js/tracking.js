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

/*
 webtrendsDelegate.
 Example delegate function that is called from
 within the tracking.js file. This is required for 
 webtrends from the tracking.js file.

 The overrideArr and appendArr are arrays that
 give hooks into overiding or appending data
 to the default tags that are in XML. It gives you
 a chance to work with dynamic data.
*/
function webtrendsDelegate(tagStr,appendArr)
{
	var parts = tagStr.split(",");
	var dcsuri = parts[0];
	var ti = parts[1];
	var cg_n = parts[2];
	if(appendArr)
	{
		//do some overrides if needed
		//say u wanted to override a default ti variable for certain calls,
		//you would provide the 1 element in overrideArr
		if(override[0] != null) dcsuri += overrideArr[0];
		if(override[1] != null) ti += overrideArr[1];
		if(override[2] != null) cg_n += overrideArr[2];
	}
	try
	{
		//dcsMultiTrack accepts "pairs" of parameters. 
		//so the odd parameter is the name of the next
		//even parameter. So parameters 0 -> 'DCS.dcsuri'
		//is the name of the next value -> dcsuri.
		//alert('DCS.dcsuri: ' + dcsuri + ' WT.ti: ' + ti + ' WT_cg_n: ' + cg_n);
		dcsMultiTrack('DCS.dcsuri',dcsuri,'WT.ti',ti,'WT_cg_n',cg_n);
	}
	catch(e){}
}

function flashTrack(xmlid,appendData)
{
	tracking.track(xmlid,appendData);
}

function setupTracking(xmlLocation)
{
	tracking = new Tracking();
	tracking.loadXML(xmlLocation);
}

function Tracking()
{
	this.xmlDoc = null;
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

function track(xmlid,appendData)
{
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

function trackForId(xmlid,appendArr)
{
	atlas(xmlid);
	webtrends(xmlid,appendArr);
	_ganalytics(xmlid);
}

function _ganalytics(xmlid)
{
	var info = this.getTrackingInfo(xmlid);
	if(!info.ganalytics) return;
	try
	{
		pageTracker._trackPageview(info.ganalytics.toString());
	}
	catch(e){}
}

function webtrends(xmlid,overrideArr,appendArr)
{
	var info = this.getTrackingInfo(xmlid);
	if(!info.webtrends) return;
	var webtrends = info.webtrends;
	try
	{
		//break out to the delegate. 
		if(webtrendsDelegate != null) webtrendsDelegate(webtrends.toString(), overrideArr, appendArr);
	}
	catch(e){}
}

function atlas(xmlid)
{
	var info = getTrackingInfo(xmlid);
	if(!info.atlas) return;
	document.getElementById("atlas_tag").src = info.atlas;
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
Tracking.prototype.loadXML = loadXML;
Tracking.prototype.track = track;
Tracking.prototype.trackForId = trackForId;
Tracking.prototype.webtrends = webtrends;
Tracking.prototype.atlas = atlas;
Tracking.prototype.getTrackingInfo = getTrackingInfo;