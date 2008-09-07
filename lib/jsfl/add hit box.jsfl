/**
 * Add's a "hit" box to the current symbol's stage, and
 * computes the width / height it needs to be to cover 
 * the entire item; a movie clip with the exported name
 * of "hit" is required.
 */
var fl = fl.getDocumentDOM();
var lib = fl.library;
var items = lib.items;
var hit;
var i=0;
lib.addNewLayer("hit","normal",true);
for(i=0;i<items.length;i++)
{
	if(items[i].linkageClassName == "hit")
	{
		hit = items[i];
		break;
	}
}
