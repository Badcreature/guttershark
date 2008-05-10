if (!window.SilverlightSite1)
	SilverlightSite1 = {};

SilverlightSite1.Page = function() 
{
}

var globalRootElement;
NUMBER_OF_BUTTONS = 7;

SilverlightSite1.Page.prototype =
{
	handleLoad: function(control, userContext, rootElement) 
	{
	
	    globalRootElement = rootElement;
		this.control = control;
		
		
	    for (i=0; i< NUMBER_OF_BUTTONS; i++){
		        buttonName = "button" + (i+1);
		        this.button = rootElement.findName(buttonName);
		        this.button.addEventListener("MouseLeftButtonDown", Silverlight.createDelegate(this, this.buttonMouseDown));
		    }
		
		this.assignButtonHandlers();
		
	},
	
	assignButtonHandlers: function(sender, eventArgs){
		    
    },
	
	buttonMouseDown: function(sender, eventArgs) 
	{
		switch(sender.Name){
		
		    case "button1":
		    tracking.track('goToGooglePopup');
		    break;
	
	        case "button2":
		    tracking.track('goToGoogle');
		    break;
		    
		    case "button3":
		    tracking.track('noRedirectsOrPopups');
		    break;
		    
		    case "button4":
		    tracking.track('webtrendsOnly');
		    break;
		    
		    case "button5":
		    tracking.track('atlasOnly');
		    break;
		    
		    case "button6":
		    tracking.track('webtrendsOnlyAndPopup');
		    break;
		    
		    case "button7":
		    tracking.track('atlasOnlyAndPopup');
		    break;
	
	    }
		
	}
}