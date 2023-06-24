
module Model
    include("./config.jl")
    import .ModelCfgs
    import Flux

    export model

    model = Flux.Chain(
        Flux.LSTM(ModelCfgs.D => ModelCfgs.hidden_dim₁),
        Flux.LSTM(ModelCfgs.hidden_dim₁ => ModelCfgs.hidden_dim₂),
        Flux.flatten,
        Flux.Dense(ModelCfgs.hidden_dim₂ * ModelCfgs.K => ModelCfgs.K),
        Flux.softmax
    )
end # Model