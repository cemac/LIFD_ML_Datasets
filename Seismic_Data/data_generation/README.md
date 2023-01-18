# Data gathering script for ATI Hackathon

## Introduction
This directory contains a script to download data for the purposes of
running a hackathon where participants use seismic data to predict the
earthquake location and time given a set of seismic recordings.

## Installation
0. Install Julia v1.8+
1. In this directory, run `julia --project -e 'import Pkg; Pkg.instantiate()'`

## Running the scripts
Scripts are placed in `bin/` and can be run from anywhere by doing
`julia bin/script_name.jl [script_arguments]`.

Because Julia is a just-ahead-of-time compiled language, it often makes
sense to open a Julia REPL once, and then run scripts within that.

To do that, just run `julia` from the command line.  Then in the REPL
run

```julia
julia> include("bin/script_name.jl")
```

Each script will automatically set the correct environment and load any
dependencies.

## Possible data selection criteria
The default scripts assume that we're interested in southern California and
want stations which are recording for the whole time over many years.
This will make data selection and analysis much easier, but probably
represents a more difficult problem in terms of cleaning up the data.  Not
many stations were recording for the entire time and many will have problems
or even have been changed during the time.  A more uniform set of stations
may be easier to deal with.

### New Madrid Seismic Zone
It may also be worth trying to look at the New Madrid seismic zone (NMSZ).
This is on the border of Arkansas, Missouri, Kentucky and Tennessee and is a
slightly mysterious region of earthquakes.  There have been several
temporary deployments of seismometers around the region, and lots of small
earthquakes.  The script `bin/new_madrid.jl` contains the search parameters
which were used to narrow down on a period of time (2020-01-01 to 2023-01-01)
during where there were lots of stations and events.

A downside to this is that because the recording period is shorter, and
since the NMSZ is not as active as California, there are not many larger
earthquakes that are well recorded on all the stations.  For most events
(since there are exponentially more smaller events than larger) therefore,
only a few stations show clear arrivals.  However, perhaps this can be learned
by some method which identifies near stations based around the shape and
amplitude of the waveform.  This might also then lead to the possibility
of predicting the magnitude as well!
