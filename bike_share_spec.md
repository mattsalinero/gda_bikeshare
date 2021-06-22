# Google Data Analytics Capstone Project 1 (Bike Share)

Creator: Matt Salinero

Created: 2021-05-12

Last Updated: 2021-06-21

---
## Project Overview

This case study focused on using an open dataset of bikeshare ride data to identify distinctions between the usage patterns of paying members and casual riders using the bikeshare. To perform the analysis, the raw data was initially cleaned using excel and then imported into a PostgreSQL database. Next, SQL was used to perform exploratory analysis and pull targeted/aggregated data for visualization in Tableau Public. Ultimately, the results of the analysis were presented in a [Tableau Public presentation](https://public.tableau.com/shared/DW443RHCY?:display_count=n&:origin=viz_share_link). Generally, the data shows that members use the bikeshare as a means of transportation (short frequent trips spread throughout the city center) while casual riders mainly use the bikeshare for recreation (longer rides disproportionally involving tourist attractions or parks).

---
## Task

This analysis will examine the difference between the usage patterns of bikeshare members (paying an annual membership) and casual riders (riders who pay on a per-ride or per-day basis) of a city-wide bikeshare company. This information will ultimately be used to inform a marketing campaign aiming to convert casual riders into members.

The stakeholders for this project include management in the marketing analytics team and company executives of the bikeshare.

---
## Data Source

For this project, the primary data source is [this](https://divvy-tripdata.s3.amazonaws.com/index.html) open dataset from a bikeshare provider. This data set includes bikeshare ride data organized as monthly or quarterly datasets stored in individual .csv files. 

- For the purpose of this analysis, the data will be treated as first-party/internal data and is assumed to be reliable and original.
- This analysis will focus on the most recent 12 months of data (as of 2021-05-12), which includes data from 2020-05-01 to 2021-04-30.
- The data is currently divided into 12 separate files, each containing data for a single month. These files will eventually be merged to perform overall analysis for the entire year.
- On initial inspection, the dataset appears to contain data for all rides taken with the system, with no obvious missing data or omissions. 
  - Each row of the dataset includes information for one ride, including start and stop locations and times.
- Some days have no rides listed for them - but this may have been for days when the bikeshare was not operational.
- As data on every ride during the time period is included the data shouldn't be overly biased towards any one type of rider. 
- The data doesn't include any PII (Personally Identifiable Information) for riders, so access does not raise privacy concerns. (also this is using an open dataset, so the data here is technically already public)
	- this is also a limitation - no way to link multiple rides to the same user
- Round trip rides (rides starting and ending at the same station) are listed with the same start and end station
	- some rides don't have start or end stations, indicating an out of dock start or end to ride?
- Includes data for different categories of bikes, including "docked bikes," "electric bikes" (first appearing Jul. 2020), and "classic bikes" (first appearing Dec. 2020).

---
## Data Cleaning

Preliminary data cleaning and transformation was performed in the per-month .csv files in preparation for analysis using SQL. This stage was mainly performed using Excel as data cleaning was performed individually for each monthly file (keeping row counts down enough for Excel to be performant).

### Data Cleaning Steps:
1. Convert monthly data .csv files to .xlsx
2. Confirm basic column formatting and data types
	- started_at and ended_at should be treated as time values
	- id columns should be treated as text (as eventually they include alphanumeric values)
3. Create additional columns for future analysis
	- ride_length (using started_at and ended_at to determine overall time of ride)
	- day_of_week (based on started_at)
4. Check for and remove rows with out of bounds ride length 
	- remove any row with a negative ride length (i.e. where ride_end is before ride_start)
5. Check for and remove rows improperly missing a start or end station based on rideable_type
	- "docked bikes" and "classic bikes" appear to need to start at a station, but rides are sometimes outside a station (maybe for an additional fee?)
	- stations aren't required for "electric bike" pickup/dropoff
6. Convert all cleaned data back to .csv
7. Import monthly data into postgres database for analysis

---
## Analysis

Analysis looked at rider type (member vs. casual) across date, days of week, times of day, station location, and bike type (docked vs. electric vs. classic). The analysis looked at the total number of rides, proportion of rides taken by members, average ride length, and average member ride length for each of these aspects.

- The analysis revealed measurable separation between members and casual riders across each target aspect
- Created an additional dimension table to store station locations (calculated using the average location of rides started at that station)
- Analysis was performed by querying the postgres database (of roughly 3.5 million rides)
	- the SQL queries used to aggregate and combine the data are available in the project folder
	- aggregated data was exported to .csv for visualization and presentation (also available in project folder)
		- Tableau Public doesn't support database connection, hence the use of .csv files to hold target data for visualization

---
## Key Findings/Visualization

The findings (and corresponding visualizations) for this project are presented in a [Tableau Public presentation](https://public.tableau.com/shared/DW443RHCY?:display_count=n&:origin=viz_share_link).

### Key Findings
- Members take the majority of rides but on average take shorter trips
- Members use the bikeshare as a means of transportation
	- members tend to ride more consistently throughout the year
		- disproportionate member ridership during "off-peak" hours (weekdays and mornings)
		- member ridership experiences less of a dropoff during winter
	- members seem to use the bikes for regular intracity trips (errands or commuting)
		- noticeable "morning commute" bump in member ridership from 6AM-10AM
		- members disproportionally use the less popular stations in the city center
		- much shorter average ride time supports use of the bikeshare for short trips or commuting
- Casual riders use the service for recreation (for example for leisure or tourism)
	- casual riders dominate the stations far out from the city center and in the immidiate vicinity of tourist attractions
	- much longer average ride time supports use for recreation or leisurely sightseeing rides

---
## Recommendations/Takeaways

### Recommendations
- A possible next step is the development of methods to identify potential members in the population of casual riders
	- potential members can be identified by looking for indications that the bikeshare is being used as a means of transportation
	- indications include short, frequent rides, use during the morning and weekdays, and travel between city stations outside tourist areas
- One limitation of this analysis was the inability to analyze multiple rides from the same user
	- the conclusions from this analysis could be reinforced using ride data that linked to the riding user
- Additionally, outside location data, such as data on tourist attractions and public transit stops could be used to develop a better understanding of how and why members and casual riders choose to ride
