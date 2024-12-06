This README_model_validation_sensitive.txt file was generated on 2022-02-21

Data on bird abundances from standardized breeding bird monitoring schemes (line transects and point count routes) from 1975-2016 from Norway, Sweden and Finland

IMPORTANT!! The original bird survey data set includes 63 species whose occurrence and location information are classified as “sensitive” according to Scandinavian laws and regulations, and thus cannot be openly shared as such. Therefore, in the openly shared data set the coordinates for the survey sites have been made coarser (observations_coarse.csv) by giving several survey sites within a 50 x 50 km grid cell the same coordinates. The original, accurate data are available from the corresponding author upon reasonable request. Therefore, it is not possible to replicate the results of the original research (or to run the R-code included as such).

GENERAL INFORMATION

1. Title of Dataset: Time series of bird abundances, land cover and temperature from standardized breeding bird monitoring schemes (line transects and point count routes) from Norway, Sweden and Finland, for 1975-2016.

2. Author Information: Sirke Piirainen, University of Helsinki, sirke.piirainen@helsinki.fi; Aleksi Lehikoinen, University of Helsinki, aleksi.lehikoinen@helsinki.fi

3. Date of data collection (single date, range, approximate date): bird data have been collected in years 1975-2016, land cover and climate data have been extracted from their corresponding online webpages approximately in 2017-11-01

4. Geographic location of data collection: Finland, Sweden and Norway

5. Information about funding sources that supported the collection of the data: The Swedish Bird Survey is supported by grants from the Swedish Environmental Protection Agency, with additional financial and logistic support from the Regional County Boards (Länsstyrelsen). The censuses were carried out within the framework of the Linneaus-project Centre for Animal Movement Research (CAnMove) and the strategic research environment Biodiversity and Ecosystem Services in a Changing Climate (BECC). The Norwegian Climate and Environment Ministry and the Norwegian Environment Agency finances the Norwegian bird monitoring. 


SHARING/ACCESS INFORMATION

1. Licenses/restrictions placed on the data: 

2. Links to publications that cite or use the data: 

3. Links to other publicly accessible locations of the data: 

4. Links/relationships to ancillary data sets: 

5. Was data derived from another source? Yes, temperature data: https://www.ecad.eu/dailydata/index.php, land cover data: https://land.copernicus.eu/pan-european/corine-land-cover

6. Recommended citation for this dataset: 


DATA & FILE OVERVIEW

1. File List: 

observations.csv 						Data table listing records from bird surveys 
output.nex							Phylogeny of the 120 study species
traits_table.csv 						Table listing traits for the study species
model_validation_static_change_code.R		R-code for running the models and following analysis
model_validation_static_change_single_code.R	R-code for running single models and comparing the results to jsdm results

2. Relationship between files, if important: 
observations_coarse.csv are used as the input data in the model_validation_static_change_code.R to create species distribution models which are in turn used to make predictions and those predictions are compared to observations.
output.nex is used in the statistical testing of factors that affect model's predictive performance, as well as traits_table.csv.

3. Additional related data collected that was not included in the current data package: 
The raw files containing all recorded information from the bird surveys are not included here.

4. Are there multiple versions of the dataset? yes/no
	A. If yes, name of file(s) that was updated: 
		i. Why was the file updated? 
		ii. When was the file updated? 


METHODOLOGICAL INFORMATION

1. Description of methods used for collection/generation of data: 
Bird data come from two types of surveys. Most data come from systematic national land bird monitoring surveys where volunteers survey either line transects (Finland) or a combination of line transects and point count stations (Sweden and Norway) once a year during the breeding season. Survey routes were 6 km (Finland and Norway) or 8 km (Sweden) in total length, each typically a square or rectangle and covered the countries at approximately 20-40 km distance of each other. Smaller fraction of the data come from more randomly located point count stations (Sweden and Norway) and line transects (Finland).

The total numbers of individuals (Sweden) or pairs (Norway and Finland) detected were recorded per species for each route. Surveys were carried out early morning and in good weather conditions. Birds were detected by both auditory and visual cues by trained observers using standardized field protocols. If a species is not detected when slowly walking along the transect line, it is reported as absent (its abundance is zero).
Not all study sites were visited each year. Records with insufficient accuracy or associated information were cleaned out. In total, the data consisted of 2591 bird survey sites (Norway 486, Sweden 1197, Finland 908). We considered each visit to each survey site (line transect or point count survey) as one sampling unit (19 753 visits in total). In Finland waterbirds were not monitored in surveys until from 2006 onwards. 
General information on the systematic national bird surveys and their detailed methods can be found online; Sweden: www.fageltaxering.lu.se, Norway: https://tov-e.nina.no/, Finland: www.luomus.fi/en/bird-monitoring.
Climate data come from the E-OBS weather data (version 15, 0.25 degree resolution) by the European Climate Assessment & Dataset project, ECA&D: https://www.ecad.eu/download/ensembles/download.php#datafiles. 
Land cover data comes from the Corine land cover data (100-meter resolution) by the European Environment Agency:  https://land.copernicus.eu/pan-european/corine-land-cover.

2. Methods for processing the data: 
For each study site climate variables were counted by overlapping study sites (line transect or point count routes) with the E-OBS gridded daily mean temperature dataset and extracting temperature variables from the grid. For each study site the climate variables (mean temperatures of current year spring (April and May), previous winter (December, January and February), and previous summer (June and July of the preceding year) were counted as an average of corresponding daily mean temperatures.
To describe the habitat where birds were observed, we drew a 300-metre-wide buffer (with software QuantumGIS) around each line transect and group of points in point count route and determined the land cover (44 classes) inside the buffer from the Corine land cover data. We then aggregated the land cover types into six classes and calculated their proportions (value range 0–1) on the buffer. See the variable listing for further details on the aggregation of the classes.
For each survey a method (point or line) and effort (number of points belonging to a point count survey or length of line in meters for a line transect survey, log-transformed) variable was recorded.

3. Instrument- or software-specific information needed to interpret the data: 
Data include a script (.R) that works with R software.

4. Standards and calibration information, if appropriate: 

5. Environmental/experimental conditions: 

6. Describe any quality-assurance procedures performed on the data: 

7. People involved with sample collection, processing, analysis and/or submission: 
Bird survey data has been gathered by numerous volunteers using detailed protocols.


DATA-SPECIFIC INFORMATION FOR: observations_coarse.csv

1. Number of variables: 

2. Number of cases/rows: 

3. Variable List: 

Route	Route identification number, unique to each route.
The Finnish line transect survey routes are numbered 1-610.
The randomly place Finnish (Metla’s) line transect survey routes are numbered 100548-101258.
The Norwegian point count survey routes are numbered 2101-4079 (TOV-E) and 10101-71001 (TOV-I).
The Swedish line transect survey routes are numbered 1001-1716. Swedish point count survey routes are numbered 180926101-951119101.

Year	Year when the route was surveyed.

y	y-coordinate indicating the location of the route, LAEA Europe -coordinate system (epsg:3035).
In the Finnish transect line survey the location is the starting point of the route which is usually the top-right corner of the route but can vary. 
In Metla’s transect line surveys the routes were not regularly shaped neither continuous, their coordinates refer to the centroid of the route.
For Norwegian and Swedish point count routes the location coordinates refer to the centroid of the route. 

x	x-coordinate of the starting point of the route, LAEA Europe -coordinate system (epsg:3035).

Effort	The length of the route in metres (for line transects) or the number of observation points (for point count routes). 
The Finnish line transect survey routes are approximately 6000 meters in length, and located on a grid, approximately 25 km apart from each other.  
Metla’s line transect routes are non-systematically located and can be of any shape and length. 
The length of a route might have changed throughout the years as routes have been modified.

Method	P=point count route or L=line transect route

JunJul	The mean temperature of June and July of the preceding year. Counted from daily mean temperatures (ECA&D/E-OBS data set from Copernicus Climate Change Service, resolution 0.25 degrees).

DJF	The mean temperature of December (preceding year), January and February (survey year). Counted from daily mean temperatures.

AprMay	The mean temperature of April and May of the survey year. Counted from daily mean temperatures.

Country	Country where the route is located. Finland (FIN), Sweden (SWE) or Norway (NOR).

Urb	Percentage of land cover classified as ‘urban’ around a 300-meter buffer around the route. 
For line transects the buffer extends 300 meters on both sides around the transect/all parts of the transect. For point counts the buffer extends 300 meters around each point.
Counted from three Corine land cover data sets from years 2000 (covering years 1975-2003), 2006 (covering years 2004-2009) and 2012 (covering years 2010-2016) at the 100x100m resolution, in LAEA Europe coordinate system (epsg:3035). 
Variable includes Corine classes containing artificial surfaces and agricultural areas. 

Br	Percentage of land cover classified as ‘broad-leaved and mixed forest’.  Variable includes Corine classes containing broad-leaved and mixed forests.

Co	Percentage of land cover classified as ‘coniferous forest’.  Variable includes Corine classes containing coniferous forests.

Op	Percentage of land cover classified as ‘mountain and shrub’.  Variable includes Corine classes containing scrub and/or herbaceous vegetation or no vegetation, and open spaces with little or no vegetation, except beaches, dunes and sands.

Ma	Percentage of land cover classified as ‘marine’.  Variable includes Corine classes containing maritime wetlands, marine waters and beaches, dunes and sands.

We	Percentage of land cover classified as ‘wetlands’.  Variable includes Corine classes containing inland wetlands and inland waters.

Species	Species specific number of individuals (Sweden) or pairs (Norway and Finland) observed in the survey  


4. Missing data codes: 
NA (abundances of waterbirds were not recorded in the surveys in Finland before the year 2006)

5. Specialized formats or other abbreviations used: 
Delimiter “;”

DATA-SPECIFIC INFORMATION FOR: traits_table.csv

1. Number of variables: 5

2. Number of cases/rows: 128

3. Variable List: 

Species		name of the species
Mig		migration behaviour (L, long-distance migrant; S, short-distance migrant; R, resident)
Hab		habitat preference (FO, forests; WE, wetlands; CU, cultural environments; MM, mires and mountains)
Mass		body mass in grams
Prev 		species prevalence in the data set

4. Missing data codes: 
No missing data

5. Specialized formats or other abbreviations used:
Delimiter “;”

