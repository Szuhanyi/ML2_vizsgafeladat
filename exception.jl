module PExcpts
    export BadIdError

    struct BadIdError <: Exception
        id::AbstractString
        msg::AbstractString
    end
end