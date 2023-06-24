include("./config.jl")
include("./exception.jl")

import DataFrames, CSV
import .DataCfgs, .PExcpts
import Base.length, Base.getindex


struct Recording
    frequency::Int64
    record::DataFrames.DataFrame
end


#files containing the orginal data (sensory for now, the three columns )
function loadRecording(record_id::DataFrames.InlineStrings.String15)::Recording
    frequency = 128
    file_name = "$record_id.csv"

    file_path = joinpath(DataCfgs.tdsc_dir, file_name)
    if !isfile(file_path)
        file_path = joinpath(DataCfgs.notype_dir, file_name)
        if !isfile(file_path)
            frequency = 100
            file_path = joinpath(DataCfgs.defog_dir, file_name)
            if !isfile(file_path)
                throw(PExcpts.BadIdError(record_id, "id $record_id not in train set"))
            end
        end
    end

    #load in the three columns containing the signal data, and the frequency
    # transformation should only happen later, otherwise the events.csv indexes would became obselete ??? not sure, but hey.. 
    data = CSV.read(file_path, DataFrames.DataFrame)
    data = data[:,[:AccV,:AccML,:AccAP]]

    return Recording(frequency, data)
end

function loadFilesAndEvents()
    events = CSV.read(DataCfgs.events_path, DataFrames.DataFrame)
    DataFrames.dropmissing!(events)
    files_dict = Dict{String,Recording}()

    for rec_id in unique(events.Id)
        try
            rec = loadRecording(rec_id)
            push!(files_dict, rec_id=>rec)
        catch except
            if isa(except, PExcpts.BadIdError)
                delete!(events, events.Id .== rec_id)
            else
                @show except
            end
        end
    end

    frequencies = [files_dict[rec_id].frequency for rec_id in events.Id]
    events.Init = convert.(Int64, round.(events.Init .* frequencies))
    events.Completion = convert.(Int64, round.(events.Completion .* frequencies))

    events, files_dict
end


struct DataSet
    events::DataFrames.DataFrame
    files_dict::Dict{String,Recording}
    D::Int64
end


DataSet(D::Int64) = begin
    events, files_dict = loadFilesAndEvents()
    DataSet(events, files_dict, D)
end


function length(data::DataSet)
    DataFrames.nrow(data.events)
end


function getindex(data::DataSet, idx::UnitRange{Int64})
    offset = data.D-1
    min_idx = data.events.Init[idx]
    max_idx = data.events.Completion[idx] .- offset
    start_idx = [rand(s:e) for (s, e) in Iterators.zip(min_idx, max_idx)]
    cat([
            Matrix(data.files_dict[rec_id].record[s_idx:s_idx+offset,:])
            for (s_idx, rec_id) in Iterators.zip(start_idx, data.events.Id[idx])
    ]..., dims=3)
end
