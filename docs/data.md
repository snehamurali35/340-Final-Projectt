# Data Design

Describe the data structures designed to hold user data

- Log: stores a private list of entries. Each entry will include the date of the migraine, the start and end times, the severity of the migraine (a score from 1 to 10), and a text field to store notes.
- Map: stored in the log class for the migraine graph so that if the user clicks on the graph view, it doesn’t have to re-access every entry to build the graph. This map will map the time the migraine begins, to the frequency of migraines at that time. If we decide to make multiple graphs for data visualization, there will be a map field for each graph.
- Map: stored in the log class for the steps graph, to hold the number of steps walked each day for the past week and the day of the week thatcorrepsponds to that number of steps .

## Log

- Keeps a list of `LogEntry`s.
- Manages add, updating, and deleting `LogEntry`s.
- holds the map of the time to frequency.

# LogEntry

- Stores information for a single log entry
- Date - The date the migraine ocurred, of type DateTime
- Start - The time the migraine started of type DateTime
- End - The time the migraine ended of type DateTime
- Severity - An integer representation of the severity of the migraine from 0 (no severe) to 10 (worst).
- Notes - User notes about the migraine stored as a String.

# Data Flow

How the app is architected to use Provider to propagate changes to these data in a reactive way.

The app is connected to the provider since the various views access data from the provider. For instance, the weeklySteps method in the provider fetches updates data from the health app about steps walked in the last week, and the graph view then accesses that data through an instance of the provider. It graphs this data then, using the bar graph fl charts package. The graph view also accesses the provider timeFreq map in order to graph the frequency of migraine to the time of it. This also updates when a new entry is added so that the map is accurate and updated to the current state of the log entries. The views display the data configured in the provider class. The Log class also keeps track of the list of entries, which allows for us to then update this list with new entries every time a new log is added, and then use this data in our graph.
