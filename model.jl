
module Model
    include("./config.jl")
    import .ModelCfgs
    import Flux

    export model

    model = Flux.Chain(
        Flux.LSTM(ModelCfgs.D => ModelCfgs.hidden_dim₁),
        Flux.MaxPool((ModelCfgs.maxpool_dim,)),
        Flux.LSTM(ModelCfgs.hidden_dim₂ => ModelCfgs.hidden_dim₃),
        Flux.flatten,
        Flux.Dense(ModelCfgs.hidden_dim₃ * ModelCfgs.K => ModelCfgs.K),
        Flux.softmax
    )
end # Model