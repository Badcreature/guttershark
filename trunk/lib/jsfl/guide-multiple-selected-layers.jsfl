var layerArray = fl.getDocumentDOM().getTimeline().getSelectedLayers();
for(a = 0; a < layerArray.length; a++)
{
	var numLayer = layerArray[a]
	var thisLayer = fl.getDocumentDOM().getTimeline().layers[numLayer]
	switch(thisLayer.layerType)
	{
		case ‘normal’:
			thisLayer.layerType = “guide”;
			break;
		case ‘guide’:
			thisLayer.layerType = “normal”;
			break;
	}
}