/*
 webtrendsDelegate.
 Example delegate function that is called from
 within the tracking.js file. This is required for 
 webtrends from the tracking.js file.

 The tagStr is whatever is inbetween a <webtrends></webtrends>
 tag for a matched id.

 The overrideArr and appendArr are arrays that
 give hooks into overiding or appending data
 to the default tags that are in XML. It gives you
 a chance to work with dynamic data.
*/
function webtrendsDelegate(tagStr, overrideArr, appendArr)
{
	
	/**************
	THIS IS JUST EXAMPLE LOGIC,
	YOU WOULD NEED TO RE-WORK THIS 
	OUT FOR YOUR PARTICULAR CASE
	***************/
	
	var parts = webtrends.split(",");
	
	//first grab defaults
	var dcsuri = parts[0];
	var ti = parts[1];
	var cg_n = parts[2];
	var ws2008 = parts[3];
	
	//do some overrides if needed
	//say u wanted to override a default ti variable for certain calls,
	//you would provide the 1 element in overrideArr
	if(override[1] != null)
		ti = overrideArr[1];
	
	//do some appends if needed
	//say i wanted to append some value onto the cg_n tag
	if(appendArr[2])
		cg_n += appendArr[2]
	
	//call it
	try
	{
		//dcsMultiTrack accepts "pairs" of parameters. 
		//so the odd parameter is the name of the next
		//even parameter. So parameters 0 -> 'DCS.dcsuri'
		//is the name of the next value -> dcsuri.
		dcsMultiTrack('DCS.dcsuri',dcsuri,'WT.ti',ti,'WT_cg_n',cg_n,'DCSext.ws2008',ws2008);
	}
	catch(e){}
}