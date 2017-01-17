
<hr>
  ##Three Cases Studies
  ### (1) Predict fire risk for building safety
  >New York City has about a million buildings, and each year 3,000 of them erupt in a major fire. Can officials predict which ones will go up in flames? The New York City Fire Department thinks it can use data mining to do that. Analysts at the department say that some buildings are linked to characteristics that make them more likely to have a fire than others.
\t - [Wall Street Journal (2014)](http://blogs.wsj.com/digits/2014/01/24/how-new-yorks-fire-department-uses-data-mining/)

In 2007, a skyscraper in Downtown Manhattan in New York City known as the [Deutsche Bank Building caught fire](http://cityroom.blogs.nytimes.com/2007/08/18/2-firefighters-are-dead-in-deutsche-bank-fire/?_r=0).  The New York City Fire Department ([FDNY](www.nyc.gov/fdny)) responded with hundreds of firefighters. But this was no common fire. The building was in the process of being dismantled and remediated for various hazards (e.g. asbestos) due to the damage it had sustained during the 9/11 attacks. Thus, temporary containment walls blocked modes of egress, air moved in an abnormal fashion throughout the building, and standpipes were not functional. As a result, two firefighters perished while navigating the deathly labyrinth. 

A retrospective review found that city agencies failed to share pertinent information so that ground crews could safely respond. Among the recommendations of this review was the creation of a risk-based inspection system with the ability to *accurately* direct firefighters to buildings of the greatest risk of fire in order to give fire fighters the best chance to respond to fires. In response, FDNY developed the Risk-Based Inspection System (RBIS) designed to schedule fire units to conduct building inspections on a regular basis. However, scheduling just any inspection is not sufficient. With over 300,000 inspectable buildings in NYC, a risk-based system needs to prioritize buildings in a way that is reflective of fire risk. 

[Image of fires in NYC goes here]

#####Coordinating a data science strategy
Both the NYC Mayor's Office and FDNY wanted to develop a fire prediction capability.The Assistant Commissioner of FDNY working with the Fire Commissioner and the Deputy Mayor for Operations established the FDNY Analytics Unit, an office with the mission of developing data science products to drive evidence-based and deployed decision making. This team was then tasked with (1) building and integrating the algorithmic engine the RBIS system using the MODA dataset, and (2) liaise with the fire ranks to ensure accurate deployment.

##### Data science
Version 1.0 of the FireCast model was built upon two years of annual-level, building-level data. Under this design, each of the 330,000 inspectable buildings as identified from the NYC Department of Buildings database were represented by two records -- one for each year in the analysis period. This master list of 660,000 records is known as the 'backbone' or 'universe' to which all data is added. Data were collected and integrated from the National Fire Incident Reporting System ([NFIRS](https://www.nfirs.fema.gov/)), the NYC Department of Buildings database, and FDNY's inspection database. NFIRS contained fire incidents, which were coded as Y = 1 for when a building experienced a fire in a given year and Y = 0 when none was experienced. It is important to note that prediction models only work if both the factual (e.g. fires) and the counterfactual (e.g. no fires) are captured  in the 'target' or 'dependent' variable; it's the only way to determine when 'co-variates' or 'independent' variables can help distinguish a building that will likely experience fires from one that will not. Building characteristics were derived from the NYC Buildings Database, such as building type (e.g. elevator building with semi-fireproof floor, one family home), building age, sub-neighborhood, owner type, among other characteristics. Most variables (both continuous and discrete) were converted into binary so that combinations of characteristics could allow for construction of an interpretable building profile. While there are many sophisticated machine learning models that could be applied, V1 of the model was developed as a logistic regression as it lends itself to narrative development and trust building. The logistic model was trained on a randomly selected 70% of the buildings, validated on 15% and tested on 15% of data. The result was a model that achieved an Area Under the Curve (AUC) or 'concordance' of over 85%. With this promising result, the model formulation was then integrated into the RBIS system by FDNY application developers. On a nightly basis, the RBIS system would run FireCast to automatically rank buildings for the highest risk of fire. Through a Oracle-based user interface, fire officers were provided the top 15 most recommended buildings for inspection in a given district in the city.
[Firecast images goes here]

#####Moving into operations
As the model was developed, it was important to communicate the mechanics of the model to fire officers and firefighters as they ultimately need to believe the outputs of such a model. Beyond the algorithm stage, the successful adoption by a user becomes a matter of user experience and design. A highly accurate model will not be adopted if the product team does not account for user needs and interaction. In the case of the fire service, it's necessary to be able to explain why a building is risky, which is something that is not easily inferred from more sophisticated machine learning models. However, logistic regression models, while often times less powerful in prediction accuracy, allow for interpretable of factors in terms of odds ratios. For example, a multi-storied building may has a fire risk that is X-times greater than a single family home. 
3. <u>Impact</u>: The result of these efforts was increased hit rates in fire code violations.[pre-arrival rate, inspection rates]

In subsequent versions of FireCast, the model was greatly expanded as the field operations grew to understand the promise of data science. By version 2, the model was tested machine learning algorithms such as Random Forests and L1/L2 Regularization with a particular focus on feature selection on an expanded three year rolling quarter dataset with a three-year time horizon containing over 7,500 variables, including 311 phone-based complaints and building owner financial records. 

####Further reading
For more detail on the FDNY Firecast project, read this [NFPA article](http://www.nfpa.org/news-and-research/publications/nfpa-journal/2014/november-december-2014/features/in-pursuit-of-smart)

### (2) Estimating impact of minimum wage on employment
>On April 1, 1992, New Jersey's minimum wage rose from $4.25 to $5.05 per hour. To evaluate the impact of the law we surveyed 410 fast-food restaurants in New Jersey and eastern Pennsylvania before and after the rise. Comparisons of employment growth at stores in New Jersey and Pennsylvania (where the minimum wage was constant) provide simple estimates of the effect of the higher minimum wage. We also compare employment changes at stores in New Jersey that were initially paying high wages (above $5) to the changes at lower-wage stores. We find no indication that the rise in the minimum wage reduced employment. - [Card and Krueger (1994)](http://davidcard.berkeley.edu/papers/njmin-aer.pdf)

####How does this work?
- <u>Behind the scenes</u>:  [How was this organized?]
- <u>Data Science</u>:  [The technical]

### (3) Monitoring Global Deforestation
>Wonderful advances in recent years in the use of satellite data and technology have empowered communities to monitor their own forests. Global Forest Watch connects the best of these systems, pulling all of this technology together on a single platform that provides access to high-quality data for the entire world. It will dramatically benefit all those working to protect our forests, and help us identify new threats to chimpanzees and prioritize our conservation efforts. -[Jane Goodall](http://www.janegoodall.at/global-forest-watch/)

Every year, between 46 to 58 thousand square miles of forest are cleared -- approximately 48 soccer fields per minute[^1]. But the information used to generate these estimates often take time. Knowing where deforestation occurs sometimes requires a manual survey of locations or tedious search of satellite images. As a result, the clearing of an entire forest may only be known once its too late and options to mitigate the environmental loss are often significantly limited. 

With advances in data science and technology, this information latency and filtering problem can be addressed. Originally launched in 1997 and later enhanced and augmented in 2013, Global Forest Watch (GFW) is an interactive online platform that offers data and tools to help monitor forests around the world. As the result of a partnership headed by the World Resources Institute (WRI) and partners, [description of platform]

####How does this work?
- <u>Behind the scenes</u>:  [How was this organized?]
- <u>Data Science</u>:  [The technical]
[code](https://github.com/wri/forma-clj/blob/master/src/clj/forma/classify/logistic.clj)

###How do these examples compare?
In all three cases, models take on the form of 
[^1]: [WWF Site ](http://www.worldwildlife.org/threats/deforestation)] 