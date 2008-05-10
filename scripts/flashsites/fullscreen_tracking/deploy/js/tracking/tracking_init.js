var gDomain="m.webtrends.com";
var gDcsId="dcsjwb9vb00000c932fd0rjc7_5p3tFFFF";
var gFpc="WT_FPC";

/* webtrends */
if(document.cookie.indexOf(gFpc + "=") == -1)
{
	document.write("<script type='text/javascript' src='http" + (window.location.protocol.indexOf('https:')==0 ? 's' : '') + "://" + gDomain + "/" + gDcsId + "/wtid.js" + "'><\/script>");
}
document.write("<img border=\"0\" name=\"DCSIMG\" width=\"1\" height=\"1\" src=\"http://" + gDomain + "/" + gDcsId + "/njs.gif?dcsuri=/nojavascript&WT.js=No\"/>")

/* atlas */
document.write("<img style=\"display:none\" id=\"atlas_tag\" src=\"\" />");