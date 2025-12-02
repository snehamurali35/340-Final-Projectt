# Instructions:

- In the top-level README.md, you should briefly explain the purpose of your app, then explain how to build and run the app.
- Make sure to explain any dependencies, API keys, or other requirements that others (including the course teaching team) need to satisfy to compile and run your app.
- You should also include a guide to the layout of your project structure (what files/classes implement what functionality). Think of this section as a guide to help the teaching team navigate what is important to look at for assessment. Note: you do not need to include all of the folders in your project here, focus on what is in lib and assets or other directories not associated with building the app (such as android, ios, macos, etc.)

# About This App

Our app is a migraine tracker that allows users to log migraine episodes, and view statistics on their past migraines, and also view a calendar to access past log entries about their migraines to view previous data. It is intended to be used for those who feel like they are not able to monitor and better forsee future migraines, by allowing them to keep track of past migraine episodes, and better predict future migraines.

# Requirements

The course team will need to allow their health app data to be viewed, so that they can see a graph of the steps they walked. At the prompt, allow should be clicked.

# Build Instructions

The app is easily run by simply building the app on their phone, and allowing all permissions to the health app.

# Project Layout

The lib holds the models, views, providers, main, and l10n folders, where the l10n folders hold the translations for internationalization. There are 5 views, one is the view of the calendar, the next is the view of the graph, the view of creating a new entry. The step chart view is called in graph to present the graph of steps in the same view of the data, and the navigation view allows for all these to come together and be accessible from the same page, with 3 different buttons for each of the three views.
[NeuroLog_Poster-3.pdf](https://github.com/user-attachments/files/23892353/NeuroLog_Poster-3.pdf)
