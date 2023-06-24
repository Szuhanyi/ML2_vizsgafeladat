
module Model
    import Flux

    export model

    model = Flux.Chain(
        Flux.LSTM(3 => 32),
        Flux.Dense(32 => 3, Flux.identity),
        Flux.softmax
    )
end # Model