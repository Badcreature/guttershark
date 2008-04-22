function Tracking()
{
	this.xmlDoc = null;
}

function createXMLHttpRequest()
{
	if(typeof XMLHttpRequest != "undefined")
		return new XMLHttpRequest();
	else if (typeof ActiveXObject != "undefined")
		return new ActiveXObject("Microsoft.XMLHTTP");
	else
		throw new Error("XMLHttpRequest not supported");
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

function track(xmlid, overrideData, appendData)
{
	var target;
	var wp;
	var redirect;
	var info = getTrackingInfo(xmlid);
	trackForId(xmlid,overrideData,appendData);
	
	target = "_self";
	try
	{
		if(info.target)
			target = info.target;
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
	
	if(!redirect)
		return;
	
	if(wp)
	{
		window.open(info.redirect,target,wp);
	}
	else
	{
		window.open(info.redirect,target);
	}
}

function trackForId(xmlid,overrideArr,appendArr)
{
	atlas(xmlid);
	webtrends(xmlid,overrideArr,appendArr);
}

function webtrends(xmlid,overrideArr,appendArr)
{
	var info = this.getTrackingInfo(xmlid);
	if(!info.webtrends)
		return;
	
	var webtrends = info.webtrends;
	try
	{
		//break out to the delegate. 
		if(webtrendsDelegate != null)
			webtrendsDelegate(webtrends, overrideArr, appendArr);
	}
	catch(e){}
}

function atlas(xmlid)
{
	var info = getTrackingInfo(xmlid);
	if(!info.atlas)
		return;
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
	
	if(null == index)
		return index;
	
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