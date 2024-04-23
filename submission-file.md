<!---

---
title: "CASA0015: Mobile System Final Assessment"
author: "ZHENKUN WANG(HARRY)"
date: "22 Apr 2024"
---

-->

## Link to GitHub Repository

Flutter Application Name - Home Window Assistance

GitHub Repository - [https://github.com/DoubleU-ANG/CASA0015_Mobile_System](https://github.com/DoubleU-ANG/CASA0015_Mobile_System)

## Introduction to Application

This application is a home assistance for window, which can provide current weather status and monitor humidity, temperature of each room in the house and, most importantly, the rain rate near the window of each room in order to protect user's house from the damage of rain even when there are not people at home. There are four main pages in this app: Login, Home, Control and setting page. In the login page, e-mail and password are supposed to be inputted to enter the app. In the home page, weather information is displayed on the top of page by calling the Openweathermap API and Geolocator API. The room data collected from user’s own sensors in the room is displayed below weather data, obtained from MQTT broker. In the control page, user can control the windows in house by clicking the buttons on screen, which can publish rotation messages to MQTT broker and micro-controller will control the corresponding window to open or close based on those message. In the setting page, user can customize their account. With the help of this APP, user can stay up-to-date with real-time weather updates and room environment data, and also manage their windows in house.

Below create a Bibliography to code, tutorial, or plugins you've used in the project. Use this guide
for citation - [https://www.scribbr.co.uk/referencing/harvard-website-reference/](https://www.scribbr.co.uk/referencing/harvard-website-reference/)

## Biblography

1. Last name, First initial. (Year published). Title. Edition. (Only include the edition if it is not the first edition) City published: Publisher, Page(s). <http://google.com>

2. Last name, First initial. (Year published). Title. Edition. (Only include the edition if it is not the first edition) City published: Publisher, Page(s).  <http://google.com>

----

## Declaration of Authorship

We, Zhenkun Wang, confirm that the work presented in this assessment is my own. Where information has been derived from other sources, I confirm that this has been indicated in the work.

Zhenkun Wang

ASSESSMENT DATE
