include("prepare_data.jl")
include("ml_utils.jl")


# return files_dict(cotain all files with data), events dataframe(with adjusted indexes for times), 
# and all the events(episods) cut out as they marked by the indexis (Init,Completion)
# labeled_episodes = contains all files, and the episodes belonging to them (filename- > episodes )
function create_events_dict()
    files_dict, events_dataframe = loadFilesAndEvents()
    #create a dictionary with all the events and then transform the ones which are needed 
    # filename => all events belonging to it 
    labeled_episodes = Dict{String,Array{Any}}()
    for episode in eachrow(events_dataframe)
        episode_name = episode.Id
        # file_data(filename) will return ->  (Matrix, frequency)
        file_data = files_dict[episode_name]        
        start_index = abs(convert(Int32,episode.Init))
        completion_index = abs(min(size(file_data[1])[1],convert(Int32,episode.Completion)))

        data = Matrix(file_data[1][start_index:completion_index,:])
        if file_data[2] == 100 && size(data)[1] > 0
            #transform to 128
            new_data = Array{Any}(undef,0)
            # we only have 3 colls ? right ? 
            for col_ind = 1:3
                push!(new_data,transform(data[:,col_ind],100,128))
            end
            data = hcat(new_data...)
        end
        
        if ((item = get(labeled_episodes,episode_name,nothing)) !== nothing)
            push!(labeled_episodes[episode_name],data)
        else
            new_array = Array{Any}(undef,0)
            push!(new_array,data)
            push!(labeled_episodes,episode_name=>new_array)
        end


    end

    files_dict,events_dataframe,labeled_episodes    

end

# all_files, events_dataframe, events_only_dict = create_events_dict()