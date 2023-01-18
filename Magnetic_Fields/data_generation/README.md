annotations_creators:
- no-annotation
language:
- en
language_creators:
- other
license:
- mit
multilinguality:
- monolingual
pretty_name: LIFD Magnetic Fields
size_categories: []
source_datasets: [gufm1 model]
tags: []
task_categories:
- feature-extraction
- image-to-image
- time-series-forecasting
- object-detection
- unconditional-image-generation
task_ids:
- multivariate-time-series-forecasting
You will need the package
https://chaosmagpy.readthedocs.io/en/master/


A description of the dataset:

The gufm1 model is a global geomagnetic model based on spherical harmonics, covering the period 1590 - 1990, and is described in the publication:
Andrew Jackson, Art R. T. Jonkers and Matthew R. Walker (2000), “Four centuries of geomagnetic secular variation from historical records”, Phil. Trans. R. Soc. A.358957–990, http://doi.org/10.1098/rsta.2000.0569

The native model representation is converted into a discrete dataset in physical space and time, using the Python package https://chaosmagpy.readthedocs.io/en/master/

The dataset has dimension (181, 361, 401) whose axes represent co-latitude, longitude, time, and whose values are the radial magnetic field at the core-mantle boundary (radius 3485km) in nT.
The colatitude takes values (in degrees):  0,1,2,3,…180;  longitude (degrees) takes values -180,-179,….180; and time is yearly 1590, 1591, …1990.