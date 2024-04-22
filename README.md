# :grin:Home Assistance For Window

This app is a home assistance for window created with Flutter, which can provide weather information for you and monitor humidity,temperature of each room in the house and, most importantly, the rainrate near the window of each room in order to protect your house from the damage of rain even when you are not at home. 

#### It is not completed yet, more features are expected to be added. 

## Screenshot:

Login Page:
<img src="screens/Login.jpg" height="500em" />

Home Page (Weather and home status visulization):
<img src="screens/Home.jpg" height="500em" />

Control Page (Control the windows here!)
<img src="screens/Control.jpg" height="500em" />

Account Page:
<img src="screens/Account.jpg" height="500em" />

## Features: 

 * Data visualisation
   * Real-time weather data visualization from Openweathermap API
   * Real-time sensor data visualization in each home including temperature, humidity and rainrate from MQTT broker.
   * Switch room to check the statu of different room by the button list on the top of data
 * Window controller
   * Open/Close window by the button shown on control page
   * Real-time window angle data visualization on the bar besides buttons
 * Customization 

## Installation

Download the whole project folder and unzip it. Open it with your flutter in VScode.
* Three things need to be noticed:
  * Change the MQTT broker to your own one and subscribe to your own topics
  * Use your own API key to get weather service, which can be easily and free to apply at https://openweathermap.org/

##  Contact Details

Feel free to contact me when you have any trouble with this project. My email is: doubleuang2001@163.com
