/**
 * Recursively exports selected movie clips in the library as swf's.
 */
function MovieClipToSWF()
{
	//get document path, for win/mac
	function getDocumentPath()
	{
		var path = document.path.replace(/\\/g, '/').split('/').slice(0,-1).join('/');
		if((path.indexOf(':/')!=-1)||(path.charAt(0)=='/'))while(path.charAt(0)=='/')path=path.substr(1);
		if(path.indexOf('file:///')!=0) path='file:///'+path;
		path += '/';
		return path;
	}
	var item,exportPath;
	var dom=fl.getDocumentDOM();
	var docName = document.name.toString().replace(/\.fla/i,"");
	var selItems=dom.library.getSelectedItems();
	var len=selItems.length;
	var selNames=[];
	var publishProfileSource=getDocumentPath()+docName+'_publishProfile.xml';
	dom.exportPublishProfile(publishProfileSource);
	var publishProfile=FLfile.read(publishProfileSource);
	var flf=publishProfile.match(/<flashFileName>(.*)<\/flashFileName>/);
	var exportval = flf[1];
	if(exportval.indexOf("/")>-1) exportPath=getDocumentPath()+exportval.split("/").slice(0,-1).join("/")+"/";
	else exportPath=getDocumentPath();
	for(var i=0;i<len;i++)
	{
		item = selItems[i].name;
		if(item.indexOf("/")>-1) selNames[i]=selItems[i].name.split("/").slice(-1);
		else selNames[i]=selItems[i].name;
	}
	if(len==0) alert('ERROR: No Library items are selected.');
	else for(var i=0;i<len;i++) if(selItems[i].itemType=='movie clip')selItems[i].exportSWF(exportPath+selNames[i]+".swf");
	FLfile.remove(publishProfileSource);
}
MovieClipToSWF();