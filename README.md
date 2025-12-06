To auto-install the app and supporting files
* import the .mltbx (MATLAB Toolbox) file to the MATLAB environment.
* double-click the .mltbx file - this will install the Philips Hue Dashboard app and supportinh HTML and HueData folders.
* The app will now appear in the APPS toolbar.


Getting Started with the PhilipsHueDashboard
* Description
  
  Philips Hue Bridge usage summary with diagnostics and lights controls. 

* System Requirements
  
	Developed and tested on Windows and Mac OS using MATLAB r2025b.

* Features
  
	Provides a single-page at-a-glance overview of all installed components:

	Lights

	Sensors

	Rules

	Scenes

	Schedules

* As well as: 

	Bridge configuration details (IP address, Zigbee Channel, firmware version etc.); a summary for Bridge % usage by component; temperature sensors summary; device batery statuses; warnings for low battery and unreachable lights; a scrollable and sortable list of Rules, Lights and Sensor temperatures.

* Lights control functionality:
  
	Toggle individual lights

	Toggle lights groups

	Toggle all lights

	Switch all lights on

	Switch all lights off

	Change colour of indiviual lights

	Change colour of lights groups

* Built-in Bridge pairing (Whitelist) process and Bridge IP Address control logic.
  
* Automatically adapts to change of IP Address after (e.g.) a router restart.

* First time Use

** Important (!):  Make sure that you start the app in the path that contains the HTML and HueData folders. **

The app will always check:
1) That it has a valid IP address to connect with the Bridge.
2) That it has been registered on the Bridge and, thus, appears on its Whitelist.
   
This means that upon initial execution it will:

a)  Try to obtain your Bridge's IP address from meethue.com.  If this is unsuccessful it means that your Bridge is not connected to the internet OR that you are running via a VPN.  You will have to resolve these issues to continue.

b)  Assuming that the  first step was successful, you will now be presented with a short dialogue guiding you through the process of adding this app to the Bridge.  This will normally be a one-off process, unless you move or delete the userNameHue.mat file - in which case you will be asked to re-register with the Bridge.
