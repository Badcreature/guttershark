/**
 * Recursively exports selected movie clips in the library as swf's.
 */
function MovieClipToSWF()
{
	var doc=fl.getDocumentDOM();
	var selLibItems=doc.library.getSelectedItems();
	var selLibItemNames=new Array();
	var len=selLibItems.length;
	for(var i=0;i<len;i++)
	{
		var item = selLibItems[i].name;
		if(item.indexOf("/")>-1)
		{
			var nameAry=selLibItems[i].name.split("/");
			selLibItemNames[i]=nameAry[nameAry.length-1];
		}
		else selLibItemNames[i]=selLibItems[i].name;
	}
	if(selLibItems.length==0)
	{
		alert('ERROR: No Library items are selected.');
		return;
	}
	else
	{
		var tempPath="file:///"+doc.path.split("\\").join("/").split(":").join("|");
		var baseFilePathArray=tempPath.split(".fla")[0].split("/");
		var mcName=baseFilePathArray[baseFilePathArray.length-1].split("_")[0]+"/";
		baseFilePathArray.pop();
		var saveFolder=baseFilePathArray.join('/')+'/'+mcName;
		var len=selLibItems.length;
		var pathString='';
		var pathArray=saveFolder.split('/').concat();
		var len2=pathArray.length;
		for(var i=0;i<len;i++)
		{
			if(selLibItems[i].itemType == 'movie clip')
			{
				for(var j=0;j<len2;j++) 
				{
					if(i!=0) pathString+='/'+pathArray[j];
					else pathString+=pathArray[j];
					if(pathString!='file://')if(!FLfile.exists(pathString))FLfile.createFolder(pathString);
				}
				selLibItems[i].exportSWF(saveFolder+selLibItemNames[i]+".swf");
			}
		}
	}
}
MovieClipToSWF();