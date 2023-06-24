import Flux

module Model
    export model

    model = Flux.Chain(
        Flux.LSTM(3 => 32, relu),
        Flux.Dense(32 => 3, identity),
        Flux.softmax
    )
end # Model