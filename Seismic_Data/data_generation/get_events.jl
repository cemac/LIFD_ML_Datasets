# Script to download a set of events and save them as a
# plain text file, and also as a serialised raw set of `Seis.Event`s,
# which is easier to deal with in later scripts.

import Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Dates: DateTime
using DelimitedFiles: writedlm
import Seis
using SeisRequests: get_events
import Serialization

"""
    download_events(; kwargs...) -> events::Vector{Seis.Event}

Download a set of `events`, which give information about earthquakes
which occurred in a seismic catalogue, subject to the search restrictions
in `kwargs`, detailed below.

# Keyword arguments
- `longitude = -116.67`: Longitude of centre point of search
- `latitude = 35.65`: Latitude of centre point of search
- `radius = 5`: Search radius around centre point in degrees
- `starttime = DateTime(2000)`: Start time of search window
- `endtime = DateTime(2010)`: Finish time of search window
- `minmagnitude = 4`: Lower magnitude limit of earthquakes.  There are
  about 30 times as many magnitude n-1 earthquakes as magnitude n-1.
- `server`: Address or name of server to which to send our request.
- `catalog = "SCEDC"`: Name of seismic catalogue from which the locations
  are taken.

# Example
Only search for events with a larger minimum magnitue:
```
julia> events = download_events(minmagnitude=5)
```
"""
function download_events(;
    longitude = -116.67,
    latitude = 35.65,
    radius = 5,
    starttime = DateTime(2000),
    endtime = DateTime(2020),
    minmagnitude = 4,
    server = "IRIS", # "https://service.scedc.caltech.edu",
    catalog = "SCEDC",
)
    get_events(; longitude, latitude, starttime, endtime,
        minmagnitude, maxradius=radius, server)
end

"""
    write_events([io,] events)

Write the information stored in `events` (an abstract array of `Seis.Event`s)
to `io`, which may be an `IO` object or file name (an `AbstractString`).

The file is written as a comma-separated-variable (CSV) file.

If `io` is not present, values are written to stdout.
"""
function write_events(io::IO, events)
    lon = events.lon
    lat = events.lat
    dep = events.dep
    time = events.time
    mag = events.meta.mag
    id = last.(split.(events.id, '='))
    println(io, "longitude[deg],latitude[deg],depth[km],time,magnitude,id")
    writedlm(io, [lon lat dep time mag id], ',')
    nothing
end
write_events(file, events) = open(io -> write_events(io, events), file, "w")
write_events(events) = write_events(stdout, events)

"""
    serialize_events(file, events)

Serialise a set of `events` to disk in `file`.

Note that serialized files may not be portable between package versions
and machine architectures and so serialized files are not suitable for
long-term storage.
"""
serialize_events(file, events) = Serialization.serialize(file, events)

# If invoked as a script from the command line
if !isinteractive() && (abspath(PROGRAM_FILE) == abspath(@__FILE__))
    @info "Downloading event information from server"
    events = download_events()
    @info "Download complete ($(length(events)) events).  Writing CSV file"
    write_events("catalogue.csv", events)
    @info "Serializing events to disk"
    serialize_events("catalogue.jlserialized", events)
    @info "Done"
end
