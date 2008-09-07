/**
 * Publishes the current document utilizing
 * an {fla}_exclude.xml file, which excludes classes
 * from being compiled into the swf.
 * @see http://exanimo.com/actionscript/flash-cs3-and-exclude-xml/
 */


//TODO: Better error handling (or at least some indication that there was an error!
var as3PackagePaths;
var docName = document.name.substr(-4).toLowerCase() == '.fla' ? document.name.substr(0, document.name.length - 4) : document.name;
var dom = fl.getDocumentDOM();
var i;
var j;
var libPublishProfileSource;
var modifiedLibraryItems = [];
var publishProfileSource;
var renamedClasses = [];
var tmp;
var tmp2;

/**
 * Utility function for getting the fla's path.
 * (Because even if document.path is defined, it doesn't mean getPath will work)
 */
function getDocumentPath()
{
	return document.path?fixPath(document.path.replace(/\\/g,'/').split('/').slice(0,-1).join('/'))+'/':null;
}

/**
 * Utility function used to convert a path to a uri.
 */  
function fixPath(path)
{
	path = path.replace(/\\/g, '/');
	if((path.indexOf(':/')!=-1)||(path.charAt(0)=='/'))
	{
		while(path.charAt(0)=='/') path=path.substr(1);
		if(path.indexOf('file:///')!=0) path='file:///'+path;
	}
	return path;
}

/**
 * Utility function used resolve a path to a base path.
 */  
function resolve(path, base)
{
	path = fixPath(path);
	base = fixPath(base);
	if (path.indexOf('file:///')==0) return path;
	if (base.indexOf('file:///')!=0) return resolve(path,resolve(base,getDocumentPath()));
	//remove trailing slashes from base.
	while(base.charAt(base.length-1)=='/') base=base.substr(0,base.length-1);	
	tmp = path.split('/');
	tmp2 = base.split('/');
	while(tmp[0] && (tmp[0].charAt(0)=='.'))
	{
		if(tmp[0]=='.') tmp.shift();
		else if (tmp[0] == '..')
		{
			tmp.shift();
			tmp2.pop();
		}
	}
	return tmp2.join('/')+'/'+tmp.join('/');
}


/**
 * Cleans up all the temp files.
 */
function cleanup()
{
	if(dom && publishProfileSource) dom.importPublishProfile(publishProfileSource);
	FLfile.remove(libPublishProfileSource);
	FLfile.remove(publishProfileSource);
	FLfile.remove(getDocumentPath() + docName + '_lib____.swf');
	FLfile.remove(getDocumentPath() + docName + '_lib____.swc');
	
	//un-rename the renamed classes.
	for(i = 0; i < renamedClasses.length; i++)
	{
		if(FLfile.copy(renamedClasses[i]+'.bkup',renamedClasses[i]))
		{
			if(!FLfile.remove(renamedClasses[i]+'.bkup'))
			{
				fl.trace('Warning: unable to delete temporary file ' + renamedClasses[i] + '.bkup');
			}
		}
		else fl.trace('Warning: unable to restore file '+renamedClasses[i]);
	}
	//un-modify modified library items.
	for(i = 0; i<modifiedLibraryItems.length;i++) modifiedLibraryItems[i].linkageExportInFirstFrame = true;
}   

// The fla must be saved in order to find the exclude xml file.
if(getDocumentPath())
{
	//reads the {fla}_exclude.xml file.
	var contents = FLfile.read(getDocumentPath()+docName+'_exclude.xml');
	if(contents)
	{
		//remove the comments.
		contents = contents.replace(/\n/g, ' ').replace(/<!--.*?-->/g, '');
		var pattern = /name="([^"]+)"/g;
		var excludedClasses = [];
		while(tmp = pattern.exec(contents)) excludedClasses.push(tmp[1]);
		if(excludedClasses.length > 0)
		{
			dom = fl.getDocumentDOM();
			
			//get the publish profile of the currently active fla.
			publishProfileSource = getDocumentPath() + docName + '_publishProfile.xml';
			dom.exportPublishProfile(publishProfileSource);
			var publishProfile = FLfile.read(publishProfileSource);
			
			//extract the package paths.
			as3PackagePaths = (/<AS3PackagePaths>(.*?)<\/AS3PackagePaths>/.exec(publishProfile)[1] + ';' + 
							  fl.as3PackagePaths).replace(/\$\(AppConfig\)/g, fl.configURI).split(';');
			
			//create a new publish profile for creating the library swc.
			var libPublishFormatProperties = '<PublishFormatProperties enabled="true">\n    <defaultNames>0</defaultNames>\n    <flash>1</flash>\n    <generator>0</generator>\n    <projectorWin>0</projectorWin>\n    <projectorMac>0</projectorMac>\n    <html>0</html>\n    <gif>0</gif>\n    <jpeg>0</jpeg>\n    <png>0</png>\n    <qt>0</qt>\n    <rnwk>0</rnwk>\n    <flashDefaultName>0</flashDefaultName>\n    <generatorDefaultName>0</generatorDefaultName>\n    <projectorWinDefaultName>0</projectorWinDefaultName>\n    <projectorMacDefaultName>0</projectorMacDefaultName>\n    <htmlDefaultName>0</htmlDefaultName>\n    <gifDefaultName>0</gifDefaultName>\n    <jpegDefaultName>0</jpegDefaultName>\n    <pngDefaultName>0</pngDefaultName>\n    <qtDefaultName>0</qtDefaultName>\n    <rnwkDefaultName>0</rnwkDefaultName>\n    <flashFileName>%FILE_NAME%.swf</flashFileName>\n    <generatorFileName>%FILE_NAME%.swt</generatorFileName>\n    <projectorWinFileName>%FILE_NAME%.exe</projectorWinFileName>\n    <projectorMacFileName>%FILE_NAME%.app</projectorMacFileName>\n    <htmlFileName>%FILE_NAME%.html</htmlFileName>\n    <gifFileName>%FILE_NAME%.gif</gifFileName>\n    <jpegFileName>%FILE_NAME%.jpg</jpegFileName>\n    <pngFileName>%FILE_NAME%.png</pngFileName>\n    <qtFileName>%FILE_NAME%.mov</qtFileName>\n    <rnwkFileName>%FILE_NAME%.smil</rnwkFileName>\n    </PublishFormatProperties>';
			
			libPublishFormatProperties = libPublishFormatProperties.replace(/%FILE_NAME%/g, docName + '_lib____');
			var libPublishProfile = publishProfile.replace(/\n/g, '%NEWLINE%').replace(/<PublishFormatProperties.*?\/PublishFormatProperties>/, libPublishFormatProperties).replace(/%NEWLINE%/g, '\n').replace(/<ExportSwc.*?\/ExportSwc>/, '<ExportSwc>1</ExportSwc>');
			
			libPublishProfileSource = getDocumentPath() + docName + '_lib____' + '_publishProfile.xml';
		    if(!FLfile.write(libPublishProfileSource, libPublishProfile))
		    {
		    	cleanup();
		    	throw new Error('The library publish profile could not be saved');
		    }

			//eliminate redundancies in the list of classes to exclude.
			for (i = excludedClasses.length - 1; i > 0; i--) if(excludedClasses.indexOf(excludedClasses[i])!=i) excludedClasses.splice(i, 1);

			//set the publish profile.
	        dom.importPublishProfile(libPublishProfileSource);

			// Publish the library fla to produce the swc file.
			dom.publish();

			//rename/move excluded classes so that they aren't compiled into the swf.
			for(i = 0; i < excludedClasses.length; i++)
			{
				var classSource;
				//find the location(s) of the class.
				for(var j = 0; j < as3PackagePaths.length; j++)
				{
					if(!as3PackagePaths[j]) continue;
					classSource = resolve(excludedClasses[i].replace(/\./g, '/') + '.as', as3PackagePaths[j]);
					if(FLfile.exists(classSource))
					{
						//rename the class.
						renamedClasses.push(classSource);
						if(!FLfile.copy(classSource,classSource+'.bkup')||!FLfile.remove(classSource))
						{
							cleanup();
							throw new Error('Unable to rename file ' + classSource);
						}
					}
				}
			}

// WON'T WORK IF SYMBOLS ARE ON STAGE!
			//make sure library symbols that are linked to excluded classes are not compiled into the swf.
			for(i = 0; i < dom.library.items.length; i++)
			{
				var item = dom.library.items[i];
				if((excludedClasses.indexOf(item.linkageClassName)!=-1) || (excludedClasses.indexOf(item.linkageBaseClass)!=-1))
				{
					if(item.linkageExportInFirstFrame)
					{
						modifiedLibraryItems.push(item);
						item.linkageExportInFirstFrame = false;
					}
				}
			}
			
			//publish the fla, with the original publish profile.
		    dom.importPublishProfile(publishProfileSource);
			dom.publish();
			
			//get rid of the temp files.
			cleanup();
		}
		else
		{
			//no excluded classes.
			dom.publish();
		}
	}
	else
	{
		//no {fla}_exclude.xml file.
		dom.publish();
	}
}
else
{
	//document not saved.
	throw new Error('In order to run this JSFL script, the document must be saved.');
}
