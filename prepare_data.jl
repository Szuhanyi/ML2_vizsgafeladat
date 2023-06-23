import DataFrames, CSV
include("./config.jl")
import .DataCfgs

function loadFile(path)
    CSV.read(path, DataFrames.DataFrame)
end

#files containing the orginal data (sensory for now, the three columns )
function loadRecording(record_id)
    data = []
    frequency = 128
    try 
        data = loadFile(joinpath(DataCfgs.tdsc_dir, "$record_id.csv"))
    catch
        try
            #these files are of freq 100
            frequency = 100
            data = loadFile(joinpath(DataCfgs.defog_dir, "$record_id.csv")) 
        catch 
            #not sure what to do with no type, they are not labeld to three types , but to ONE 
            # I guess we could deduce the correct label from the events.csv file ???? 

            # no... on second hand , the info is missing from the events.csv file as well.. 
            # data = loadFile(joinpath(DataCfgs.notype_dir, "$record_id.csv")) 
        end
    end

    #load in the three columns containing the signal data, and the frequency
    # transformation should only happen later, otherwise the events.csv indexes would became obselete ??? not sure, but hey.. 
    if (size(data)[1] > 0)
        data = Matrix(data[:,2:4])
    end    
    
    (data,frequency)
end


function loadFileDict(event_df::DataFrames.DataFrame)
    file_names = unique(event_df[:,1])
    files = Dict{String,Any}()

    for f_name in file_names
        content = loadRecording(f_name)
        push!(files, f_name=>content)
        
    end

    files
end


function loadFilesAndEvents()
    events = CSV.read(DataCfgs.events_path, DataFrames.DataFrame)
    files_dict = loadFileDict(events)

    for row in eachrow(events)
        frequency = files_dict[row.Id][2]
        row.Init = round(Int, row.Init * frequency)
        row.Completion = round(Int, row.Completion * frequency)
    end

    files_dict,events
end


