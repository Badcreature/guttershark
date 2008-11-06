/**
 * Creates an output of symbold definitions as public vars
 * and traces to the output panel.
 */
var items = fl.getDocumentDOM().selection;
var finalDeclarations="";
for(var i=0;i<items.length;i++)
{
	var item=items[i];
	if(item.libraryItem)
	{
		if(isComponent(item.libraryItem.name))finalDeclarations+="public var "+items[i].name+":"+getClassOfComponent(item.libraryItem.name)+";\n";
		else if(items[i].name)finalDeclarations+="public var "+items[i].name+":MovieClip;\n";
	}
	else if(items[i].elementType=="text"&&items[i].name)finalDeclarations+="public var "+items[i].name+":TextField;\n";
}
function isComponent(libItemName){return libItemName.match(/Components\//i);}
function getClassOfComponent(libItemName){return libItemName.match(/Components\/([a-zA-Z0-9_-]*)/i)[1];}
fl.outputPanel.trace(finalDeclarations);