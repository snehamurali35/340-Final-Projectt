# Instructions:

- Identify which of the course topics you applied (e.g. secure data persistence) and describe how you applied them. In addition to the list of topics enumerated above, you must also describe how your app design reflects what you learned about the design principles we discussed in our Inclusive Design lecture (Lecture 9: Designing for Accessibility)

We applied internalization through the language button, where a user can toggle between Spanish and English depending on which is more relevant to the user.
For the undo/redo, buttons are provided in the entry editing view to allow users to revert edits that they make.
We used Isar to persist log entries the user’s save.
For drawing, our calendar view takes advantage of the canvas widget to change color based on migraine severity to represent log entries that vary by the severity of the log.
Finally, We used the health API, which connects to the Apple health app and fetches data from it in order to present steps walked visually in a graph; the graph maps the steps someone walks to the day they walked that number of steps.
Regarding inclusive design, we ensured that our text has a high enough contrast color against the background color, to achieve the necessary contrast ratio for those with low vision to be able to see and read text. In addition, we followed the guideline to have text that is of the necessary size to match accessibility guidelines for those with low vision.

- Cite anything (website or other resource) or anyone that assisted you in creating your solution to this assignment, Remember to include all resources you used to solve this assignment.
- Please acknowledge any help you got from TAs, instructors, or students by name.
- You do not need to include links to lecture/section material or flutter docs. However you do need to mention which Flutter classes or packages you viewed.
  I viewed the fl charts package,
- You must mention if you used significant portions of of the starter code given to you for one or more assignments (and list which assignments)

I(Sneha) used a portion of my journal project, journalEntry.dart file

- You must include links to all StackOverflow, Medium, blogs, or other articles you used.
- If you used any Generative AI (ChatGPT, Gemini, CodePilot, or the like), please include the prompt(s) you used and how the result was or was not helpful.
- If you did not use any resources beyond classroom/flutter docs, please state so explicitly.

  We did not use any resources beyond classroom/flutter docs.

- Discuss how doing this project challenged and/or deepened each of your understanding of these topics.

Implementing a language toggle between English and Spanish (implementing internationalization) challenged us to think about accessibility for diverse language users. We used Flutter’s localization framework and ARB files to provide translations. This helped us understand how software can better serve a wider range of audience.
Building undo and redo features for the entry editing view required us to manage complex app state.
We used Isar to store log entries locally. Working with this NoSQL database gave us hands-on experience with schema definition, asynchronous data operations, and reactive updates. We learned how to efficiently persist and retrieve data in Flutter without compromising performance or user experience.
In the calendar view, we drew custom icons using the Canvas API to represent different log entry severities. This required understanding how to render shapes programmatically and dynamically based on user data. It also helped us explore Flutter's low-level painting capabilities, which are not often covered in high-level tutorials.
We integrated the Apple Health API to fetch step count data. This challenged us to navigate platform-specific permissions, data syncing, and asynchronous health data fetching. Displaying the data visually in a bar graph also helped reinforce our understanding of data visualization libraries like fl_chart.

- Describe what changed from your original concept to your final implementation and explain why your group made those changes from your original design vision.
  One thing that changed from our initial implementation to our final was that we were not initially going to connect to the health app on iphones to access step data. However, we realized that it is helpful to correlate data that is already being recorded by other apps, like the Apple Health App. Therefore, we decided to use the step data so a user can view multiple sources of data all in the same place instead of having everything in multiple different apps. This is something that we could also add to later, to incorporate different forms of data and add analysis, so this was an important starting point. Hence, why we chose to incorporate it.
- Describe two areas of future work for your app, including how you could increase the accessibility and usability of this app.

One area of future work for the app is to allow for more health data to be accessed, and for the app itself to tell the user that there is a correlation between something like their sleep duration, and the frequency of their migraine. That would be helpful since the user will be given further analysis. Another idea for future work is to allow the user to input in other data, along with migraine data, such as sleep times, mood, period duration etc., and have this be correlated to the migraine data to give the user further input on what could be causing their migraines.
Finally: thinking about CSE 340 as a whole:

What do you feel was the most valuable thing you learned in CSE 340 that will help you beyond this class, and why?
I found that the ui part was very valuable, along with using git to keep track of changes. I learned so much about figuring out how to create widgets that display exactly what we want, and also create ui that allows for the functionality that I intended for.

If you could go back and give yourself 2-3 pieces of advice at the beginning of the class, what would you say and why? (Alternatively: what 2-3 pieces of advice would you give to future students who take CSE 340 and why?)

I would give myself advice to start projects early, which I did, and it was helpful, to use the flutter documentation, and secondly, to go to office hours often whenever any part of the project/section was confusing.
