
abstract type AbstractSource end

import Base: @kwdef

macro defsource(ex) 
    nex = ex.head == :macrocall ? ex.args[end] : ex 
    defsource(nex) |> esc
end

function defsource(ex) 
    head = ex.head
    ismutable, name, args = ex.args
    if ismutable
        if name isa Symbol 
            return quote 
                Base.@kwdef mutable struct $name{TR, HS, CB} <: AbstractSource
                    $args
                    trigger::TR = 1
                    handshake::HS = 2 
                    callbacks::CB = nothing
                    name::Symbol = Symbol()
                end 
            end
        else 
            return quote 
                Base.@kwdef mutable struct $(name.args[1]){$(name.args[2:end]...), TR, HS, CB} <: AbstractSource
                    $args
                    trigger::TR = 1
                    handshake::HS = 2 
                    callbacks::CB = nothing
                    name::Symbol = Symbol()
                end 
            end
        end
    else 
        if name isa Symbol
            return quote 
                Base.@kwdef struct $name{TR, HS, CB} <: AbstractSource
                    $args
                    trigger::TR = 1
                    handshake::HS = 2 
                    callbacks::CB = nothing
                    name::Symbol = Symbol()
                end 
            end
        else
            return quote 
                Base.@kwdef struct $(name.args[1]){$(name.args[2:end]...), TR, HS, CB} <: AbstractSource
                    $args
                    trigger::TR = 1
                    handshake::HS = 2 
                    callbacks::CB = nothing
                    name::Symbol = Symbol()
                end 
            end
        end
    end 
end


@macroexpand Base.@kwdef struct Sinewave7
    amplitude::Int = 1
    phase::Int 
    gain = 1
end

