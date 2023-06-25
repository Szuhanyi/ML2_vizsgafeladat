module DataCfgs
    export tdsc_dir, defog_dir, notype_dir
    export events_path

    data_dir  = "input"

    train_dir = joinpath(data_dir, "train")
    tdsc_dir  = joinpath(train_dir, "tdscfog")
    defog_dir = joinpath(train_dir, "defog")
    notype_dir = joinpath(train_dir, "notype")

    events_path = joinpath(data_dir, "events.csv")
end #   DataCfgs


module ModelCfgs
    export D, K, hidden_dim

    D = 512
    K = 3
    hidden_dim₁ = 64
    maxpool_dim = 2
    hidden_dim₂ = 32
    hidden_dim₃ = 16
end # ModelCfgs