using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Browser;

namespace Tracking_Example_Silverlight2
{
    public partial class Page : UserControl
    {
        public Page()
        {
            InitializeComponent();
        }

        private void button_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {

            Button senderButton = (Button)sender;
            switch (senderButton.Name)
            {
                case "button1":
                HtmlPage.Window.Invoke("invokeTracking", "goToGooglePopup");
		        break;
	
	            case "button2":
                HtmlPage.Window.Invoke("invokeTracking", "goToGoogle");
		        break;
		    
		        case "button3":
                HtmlPage.Window.Invoke("invokeTracking", "noRedirectsOrPopups");
		        break;
		    
		        case "button4":
                HtmlPage.Window.Invoke("invokeTracking", "webtrendsOnly");
		        break;
		    
		        case "button5":
                HtmlPage.Window.Invoke("invokeTracking", "atlasOnly");
		        break;
		    
		        case "button6":
                HtmlPage.Window.Invoke("invokeTracking", "webtrendsOnlyAndPopup");
		        break;
		    
		        case "button7":
                HtmlPage.Window.Invoke("invokeTracking", "atlasOnlyAndPopup");
		        break;
            }
        }
    }
}
