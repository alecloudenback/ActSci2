using OffsetArrays

abstract type MortalityTable end

# use traits for Balducci v UDD vs Constant Force

struct Ultimate <: MortalityTable
    ultimate::OffsetArray{Float64,1,Array{Float64,1}}
    Ultimate(q::Array{<:Real,1},start_age) = new(OffsetArray(q,start_age - 1))

    "if no `start_age` given, assume table starts at 0"
    Ultimate(q::Array{<:Real,1}) = new(OffsetArray(q,-1))
end

struct SelectUltimate <: MortalityTable
    select::Array{Union{Missing, Float64},2}
    ultimate::Ultimate
end

"""
ₜp₍ₓ₎₊ₛ , or the probability that a life aged `x + s` who was select
at age `x` survives to at least age `x+s+t`
"""
function p(table::Ultimate,x,s,t)
    prod(1.0 .- table.ultimate[x+s:x+s+t-1])
end

"""
ₜpₓ , or the probability that a life aged `x` survives to at least age `t`
"""
function p(table::Ultimate,x,t)
    prod(1.0 .- table.ultimate[x:x+t-1])
end

"""
pₓ , or the probability that a life aged `x` survives through age `x+1`
"""
function p(table::Ultimate,x)
    1.0 - q(table,x)
end

"""
ₜq₍ₓ₎₊ₛ , or the probability that a life aged `x + s` who was select
at age `x` dies by least age `x+s+t`
"""
function q(table::Ultimate,x,s,t)
    1.0 - p(table,x,s,t)
end

"""
ₜqₓ , or the probability that a life aged `x` dies by age `x+t`
"""
function q(table::Ultimate,x,t)
    1.0 - p(table,x,t)
end

"""
qₓ , or the probability that a life aged `x` dies by age `x+1`
"""
function q(table::Ultimate,x)
    table.ultimate[x]
end
