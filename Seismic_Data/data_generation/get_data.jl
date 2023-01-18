# Script to download data for a set of earthquakes.

import Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Dates: DateTime, Second
using DelimitedFiles: writedlm
import Seis
using SeisRequests: get_data, get_stations
import Serialization

"""
    download_stations(events; channel="EHZ,SHZ,HHZ,BHZ", radius=5) -> stations::Vector{Seis.Station}

Find stations recording during the time span of the origin times of the
`events`, and which lie within the longitude-latitude box defined by the
extrema of longitude and latitude of the events, with an extra `radius`°
padding on the bounding box.

`channel` determines which stations are returned.  The default code gives
gives so-called only the vertical component of so-called 'short-period' and
'broadband' seismometers which are most often used to locate regional
earthquakes.  The set of codes searched for ensures the sample rate is
sufficient for our needs (≥ 10 Hz).
"""
function download_stations(events;
    channel = join(("E","S","H","B").*"HZ", ','),
    radius = 5,
)
    # All stations that were active for the whole time period
    starttime, endtime = extrema(events.time) .+ (Second(0), Second(60))

    # Event bounding box with `radius` padding
    minlongitude, maxlongitude = extrema(events.lon) .+ radius.*(-1, 1)
    minlatitude, maxlatitude = extrema(events.lat) .+ radius.*(-1, 1)

    stations = get_stations(;
        startbefore=starttime, endafter=endtime,
        minlongitude, maxlongitude,
        minlatitude, maxlatitude,
        channel)
end

"""
    download_data(events, stations; outdir="Data", starttime=-30, endtime=600) -> data::Vector{Vector{Seis.Trace}}

Using a catalogue of earthquakes `events` and a list of `stations`,
download data for each event at each station.

The `data` are returned as a vector of vectors of `Seis.Trace`s.  Each
item in `data` is the vector of `Trace`s corresponding to the event with
the same index.  Note that it is possible no data are recorded for some
events, in which case that vector is empty.
"""
function download_data(events, stations; save=true, outdir="Data", starttime=-30, endtime=600)
    if !isdir(outdir)
        mkpath(outdir)
    end

    data = map(events) do event
        try
            traces = get_data(event, stations, starttime, endtime)
            if save
                try
                    save_data(outdir, event, traces; make_dir=true)
                catch err
                    @warn "Error saving data to disk: $err"
                end
            end
            traces
        catch err
            @warn "Error getting data for event $(event.id): $err"
            Seis.Trace{Float64,Vector{Float64},Seis.Geographic{Float64}}[]
        end
    end
end

"""
    write_stations(io, stations)

Write the information stored in `stations` (an abstract array of `Seis.Station`s)
to `io`, which may be an `IO` object or file name (an `AbstractString`).

The file is written as a comma-separated-variable (CSV) file.

If `io` is not present, values are written to stdout.
"""
function write_stations(io::IO, stations)
    code = Seis.channel_code.(stations)
    lon = stations.lon
    lat = stations.lat
    elev = stations.elev

    println(io, "code,longitude[deg],latitude[deg],elevation[m]")
    writedlm(io, [code lon lat elev], ',')
    nothing
end
write_stations(file, stations) = open(io -> write_stations(io, stations), file, "w")
write_stations(stations) = write_stations(stdout, stations)

"""
    save_data(root_dir, event, traces)

Write all `traces` (a collection of `Seis.Trace`s) to a subdirectory of
`root_dir` whose name is based on the event origin time.  Each trace is
saved as a separate SAC file, whose name is just the station name with
`".sac"` appended.

!!! note
    If the network code of a trace is empty, then its channel code and
    thus the filename begins with `.`.  On Unix systems, this means the
    file is hidden when using `ls` with default settings, so you may need
    to use `ls -a` to see such files.
"""
function save_data(root_dir, event, traces; make_dir=false)
    event_dir = joinpath(root_dir, "Event_$(event.time)")
    if !isdir(event_dir) && make_dir
        mkpath(event_dir)
    end

    for t in traces
        file = joinpath(event_dir, Seis.channel_code(t) * ".sac")
        Seis.write_sac(t, file)
    end
end

if !isinteractive() && (abspath(PROGRAM_FILE) == abspath(@__FILE__))
    @info "Loading event catalogue..."
    events = Serialization.deserialize("catalogue.jlserialized")
    @info "Done ($(length(events)) events).  Downloading station data..."
    stations = download_stations(events)
    @info "Done ($(length(stations)) stations). Writing station info to disk..."
    write_stations("stations.csv", stations)
    @info "Done. Downloading data and writing files..."
    data = download_data(events, stations)
    @info "Done ($(sum(length, data)) traces total)"
end
