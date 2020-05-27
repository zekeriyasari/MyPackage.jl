
function process!(ex)
    nex = quote
        trigger::TR = Inpin()
        handshake::HS = Outpin()
        callbacks::CB = nothing
        name::Symbol = Symbol()
        id::Int = 0
    end
    body = ex.args[3]
    append!(body.args, nex.args)

    name = ex.args[2] 
    if name isa Expr && name.head === :(<:)
        name = name.args[1]
    end
    if name isa Expr && name.head === :curly 
        append!(name.args, [:TR, :HS, :CB])
    elseif name isa Symbol
        ex.args[2] = Expr(:curly, name, [:TR, :HS, :CB]...)  # parametrize ex 
    end
    
end

function def(ex)
    # Get struct name
    name = ex.args[2]
    if name isa Expr && name.head === :(<:)
        name = name.args[1]
    end
    
    # Process struct body
    body = ex.args[3]
    kwargs = Expr(:parameters)
    callargs = Symbol[]
    _def!(body, kwargs, callargs)

    # struct has no fields
    isempty(kwargs.args) && return :( $(esc(ex)) )

    if name isa Symbol
        return quote 
            $(esc(ex))
            $(esc(name))($kwargs) = $(esc(name))($(callargs...)) 
        end
    elseif name isa Expr && name.head === :curly 
        _name = name.args[1]
        _param_types = name.args[2:end]
        __param_types = [_type_ isa Symbol ? _type_  : _type_.args[1] for _type_ in _param_types]
        return quote 
            $(esc(ex))
            $(esc(_name))($kwargs) = $(esc(_name))($(callargs...))
            $(esc(_name)){$(esc.(__param_types)...)}($kwargs) where {$(esc.(_param_types)...)} = 
                $(esc(_name)){$(esc.(__param_types)...)}($(callargs...))
        end
    end
end

function _def!(body, kwargs, callargs)
    for i in 2 : 2 : length(body.args)
        bodyex = body.args[i]
        if bodyex isa Symbol # var
            push!(kwargs.args, bodyex)
            push!(callargs, bodyex)
        elseif bodyex isa Expr 
            if bodyex.head === :(=)
                rhs = bodyex.args[2]
                lhs = bodyex.args[1] 
                if lhs isa Expr && lhs.head === :(::) # var::T = 1
                    var = lhs.args[1] 
                elseif lhs isa Symbol # var = 1
                    var = lhs
                elseif lhs isa Expr && lhs.head == :call # inner constructors
                    continue
                end
                push!(kwargs.args, Expr(:kw, var, esc(rhs)))
                push!(callargs, var)
                body.args[i] = lhs 
            elseif bodyex.head === :(::)  # var::T
                var = bodyex.args[1]
                push!(kwargs.args, var)
                push!(callargs, var)
            end
        end
    end
end

# @def struct Object 
#     x::Int = 1 
#     y::Int = rand(Int)
# end

macro defsource(ex)
    ex isa Expr && ex.head == :struct || error("Invalid source defition")
    process!(ex)
    def(ex)
end

abstract type AbstractODESystem end

@macroexpand @defsource struct LorenzSystem{IP, OP} <: AbstractODESystem
    α::Float64 = 1.
    β::Float64 = 1.
    ρ::Float64 = 1.
    γ::Float64 = 1.
    input::IP = nothing
    output::OP = Outport(3)
end
righthindside(ds::LorenzSystem, dx, x, u, t) = (dx .= -1)
readout(ds::LorenzSystem, x, u, t) = x 

ds = LorenzSystem(state=rand(3), t=0., input=nothing, output=nothing) 

@defsource struct MySystem <: AbstractODESystem 
    input = Inport() 
    output = Outport() 
end 
