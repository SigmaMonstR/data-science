#### Section 1: Fundamentals

Data science is about designing and building data products that derive insight. This first section will focus on developing fundamental skills required to build effective products.

##### Lecture 1: Preliminaries

The objective of the first lecture is to overcome the coefficient of static friction in using R for data science.  Students will learn to execute simple R scripts to read, write, and extract data elements.


###### Lecture objectives

1. Why code matters
2. Set up, edit, and save RMarkdown 
3. Getting started with Github
4. Read data from CSV and JSON
5. Data types and classes, including matrix, data.frame, list, and vectors
6. Extracting rows, columns, and specific elements from a data frame
7. Basic operations (e.g., sum, mean) on rows; useful as consistency checks.
8. Write data to CSV and JSON


###### Example application

- Health from the Demographic and Health Surveys or Census data.


##### Lecture 2: Data manipulation

The objective of this lecture is to present the most important and fundamental elements of data manipulation.  These core operations include sort, merge, reshape, and collapse.  We will also present loops through multiple rows or columns, and other alternatives to operate on partitions of data frames.

###### Lecture objectives

1. Mastery of data manipulation makes for good data scientists
2. Sort data based on column values
3. Subset data frames
4. Reshape data table, wide ⇔ long
5. Merge data frames
6. Collapse data frames
7. Text processing: capitalization, substring, regex
8. Looping through basic operations (bonus: same idea without loops)


###### Example application

- Collapse data at the county level to state level
- Process NYC 311 data from point level to Census tract level


##### Lecture 3: Data quality and re-usable code

The objective of this lecture is to handle missing values appropriately and script visual checks to find errors introduced in data input/output.  We will also start to view computational optimization techniques, like taking advantage of multiple cores for heavy duty operations (parallel processing).


###### Lecture objectives

1. A data scientist’s work is only as good as data quality
2. Handling missing values and their properties
3. Replacing values by condition
4. Visual checks: hist(), plot(), ggplot2
5. Writing functions

###### Example applications	

- GHCN-M: Missing values analysis in matrix of weather anomalies from 1880 to Present
- Weather: Matching human-reported weather events to radar events over time and space


##### Section 2: Data Analysis + Modeling

The use case drives the technique. In public policy, data can be used to support evaluation of programs to understand causal mechanisms (e.g. retrospective focus) or enable the creation of data-rooted products that drive action (e.g. deployed applications). Machine learning and data analysis enables both uses of data and will be the focus of the next five courses

###### Lecture 4: Introduction to Supervised Learning 

Supervised learning is the most relied upon class of techniques that enable causal inference but also deployed precision policy. How does changing one variable independently impact another variable?  We begin to introduce basic regression analysis, correlation coefficients, ordinary least squares, and the relationship between the concepts.  Note that this is a very cursory review, and the deep assumptions are not tested or expounded upon.

###### Lecture objectives

1. Three common data science problems in public policy: 
2. Supervised: Scoring or prediction for application
3. Supervised: Causal inference and evaluation for understanding
4. Unsupervised: Clustering for structure
5. What is supervised learning?
6. Structure of a supervised learning project
7. Target variables, Input variables, Objective function and evaluation measures, model experiment design, Cross validation versus train/validate/test,  Regression versus classifiers
8. Ordinary Least Squares (OLS): Graphical illustration 
9. Linear models in `R`
10. Exporting results tables
11. The limits of correlation coefficients and R-squared statistics
12. Introduction to scoring and prediction: train/validate/test

###### Example application	

- Labor and wage analysis, innate ability. (David Card data set.)
- Economic data from BEA

##### Lecture 5: Simulations, selection bias 

Formal statistics offers methods to calculate closed-form, analytical answers to the limits of OLS regression.  Data science offers a more immediate and arguably a more accessible solution: simulate conditions and examine the outcomes.  We begin to use the early visualizations techniques taught in a previous lecture for analysis.

###### Lecture objectives
1. Simulating OLS and identifying p-values
2. For-loops versus `apply` for simulations
3. Visualizing distributions with ggplot

###### Example application	

- TBD

##### Lecture 6: Regression discontinuity and difference-in-difference estimation

An introduction to assessing the causal impact of public policy.

###### Lecture objectives

1. Interpretation of dummy variables
2. Difference-in-differences (DiD) as a causal estimator
3. Assumptions and potential issues with DiD
4. Regression discontinuity (RD) analysis
5. Visualizing RD analysis

###### Example application	

- TBD

##### Lecture 7: Classification techniques 

Classification models are one of the workhorses of data science. Classifiers enables data-driven applications such as risk scoring, lawsuit outcome prediction, marketing lead generation, facial detection and computer vision, spam filtering, among other use cases.  This session will focus on the fundamentals of classification models, types of models, and daily applications.

###### Lecture objectives
1.	Three common problems using classifiers
2.	Structure of a classification project
Target variables, Input variables, Objective function and evaluation measures, model experiment design, Cross validation versus train/validate/test
Confusion matrix, TPR, TNR, AUC
3.	Framing dataset
4.	Models: statistical assumptions and mechanics, risks/strengths, implementation, non-technical explanation, Decision trees, Logistic Regression, K-Nearest Neighbors
5.	Appropriate uses of classification techniques, Scoring, prediction and prioritization, Propensity score matching


###### Example application	

- Credit Card Default Dataset (UCI/Kaggle)

##### Lecture 8: Unsupervised learning 

No, this is not an independent study session. Unsupervised learning techniques such as clustering and principal components analysis helps to identify recognizable patterns when no labels are provided. In sales and recruitment offices, customer segmentation may use current customer data, then use clustering techniques to identify k-number of distinct customer profiles. In resourceful law firms, data scientists may develop topic modeling algorithms to automatically tag and cluster hundreds of thousands of documents for improved search. This session will focus on clustering methodologies that are commonly employed in applied research.

###### Lecture objectives

1.	Three common problems using unsupervised learning 
2.	Structure of unsupervised learning project, Input variables, optimization methods
3.	Framing dataset
4.	Models: statistical assumptions and mechanics, risks/strengths, implementation, sanity checks, non-technical explanation, K-means clustering (K-means), Principal Components Analysis (PCA)/Dimensionality Reduction, Hierarchical clustering (if time permits)
5.	Appropriate uses of k-means and PCA

###### Example application(s)

- Univariate clustering application: k-means
- Multivariate clustering application: Customer segmentation using Census American Community Survey


#### Section 3: Data enhancement and visualization

Beyond the data preparation and modeling, the ‘presentation layer’ is the glue that will allow a data science project stick with target audiences. Often times, presentation is graphical and relies upon a rich ecosystem of visualization, web services, and interactive applications to communicate pertinent issues.

##### Lecture 9: Data storytelling through graphical representation

Often times, the model is not enough to communicate the value of the data analysis. A well-designed visualization can illustrate patterns and allow target audiences to establish a connection with the analytical effort at hand. 

###### Lecture objectives

1. Three examples of the presentation layer
2. Static visualizations: ggplot2
3. Interactive visualizations: dygraphs, plotly, networkd3, threejs

###### Example application	

- Phone gyroscopic data: time series
- Global trade flows: network map


##### Lecture 10: Web service APIs and spatial data

There are many cases where you will rely on data or services that aren’t stored or build on your local machine, but rather are exposed as web service application programming interfaces (APIs).  These are the components of modern software development, and we will teach how to find and utilize these services from within the R programming environment.  We use this lecture as an opportunity to introduce spatial data within R by interacting with an API for geographic data.

###### Lecture objectives

1. 	Three examples of APIs and why they matter
2.	Interacting with web service APIs from R
3.	Writing a client-side function to simplify the remote interaction
4.	Batch request for elevation data from the Google Elevation API
5.	Viewing the spatial data in R


###### Example application	

- Extracting elevation data from the Google Elevation API
- Identifying the characteristics of farmers’ markets in the Southwest United States.


##### Lecture 11:  Spatial Data and Maps

The state of data is rapidly expanding in two principal directions: transactional-level and spatially. Maps are the principal mode of representing spatial data, which relies upon different types of GIS formats (e.g. shapefiles, raster, GeoJSON) and presentation medium. This lecture dives into spatial considerations in data science.

###### Lecture objectives

1. 	Three examples of spatial data
2.	A framework for approaching GIS
3. 	Preliminaries of GIS data, File types (shp, .nc, .tif, .json), Projections, Feature type (point, line, polygons, grids), Visualizations (choropleth, dot density, proportional)
4.	Mapping choropleth maps using polygon shapefiles
5.	Geoprocessing of points to polygon
6.	Displaying multiple layers

###### Example application	

- Chicago crime data


##### Lecture 12:  Export results and interactivity

Often times, users like to interact with a product as opposed to reading curated results. Enter interactivity -- a well-proven mode of displaying results.

###### Lecture objectives

1. 	Three examples of interactive data science
2.	An Intro to R Shiny 
3. 	Building a simple interactive tool

###### Example application	

- TBD
					


