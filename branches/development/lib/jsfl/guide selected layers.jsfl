/**
 * Toggles selected layers as guides.
 */
var layerArray = fl.getDocumentDOM().getTimeline().getSelectedLayers();
var a=0;
for(a;a<layerArray.length;a++)
{
	var numLayer = layerArray[a];
	var thisLayer = fl.getDocumentDOM().getTimeline().layers[numLayer];
	switch(thisLayer.layerType)
	{
		case 'normal':
			thisLayer.layerType = "guide";
			break;
		case 'guide':
			thisLayer.layerType = "normal";
			break;
	}
}