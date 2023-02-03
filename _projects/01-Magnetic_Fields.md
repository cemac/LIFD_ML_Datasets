---
number: 1
title: Magnetic Fields
pis:
  - Phil Livermore

# Comment these lines to hide these elements
contributors:
  - Helen Burns 1 (Institution 1)
github: cemac/LIFD_ML_Datasets

---

## Magnetic Fields

* [Data download (Kaggle)](https://www.kaggle.com/datasets/hlburns/lifd-magnetic-field-data)
* [Tools/Data generation](https://github.com/cemac/LIFD_ML_Datasets/tree/main/Magnetic_Fields/data_generation)
* [Solutions]()

*Solutions link to repo or Kaggle or huggingface model*

### About

This dataset contains 400 years of radial magnetic field (in nT) data at the core-mantle boundary (radius 3485km) from the  gufm1 model. This has been converted into a discrete data set in space and time described below.

The gumf1 model is a global geomagnetic model based on spherical harmonics, covering the period 1590 - 1990, and is described in the publication:

Andrew Jackson, Art R. T. Jonkers and Matthew R. Walker (2000), “Four centuries of geomagnetic secular variation from historical records”, Phil. Trans. R. Soc. A.358957–990, http://doi.org/10.1098/rsta.2000.0569

The dataset has dimensions (181, 361, 401) whose axes represent co-latitude, longitude, time, and whose values are the radial magnetic field at the core-mantle boundary (radius 3485km) in nT.

* Colatitude take:  0 - 180 (degrees);  
* Longitude: -180 - 180 (degrees)
* Time: 1590 -1990 (yearly)

## File format

python .npz file format contains numpy arrays of:

* Br:  Radial magnetic field in nT (3D array in (phi, theta, time))
* phi: longitude in degrees (1D array)
* theta: colatitude in degrees (1D array)  
* times: year  (1D array)  
* radius: core-mantle boundary (float in km)

License: MIT



- References here
- ...
