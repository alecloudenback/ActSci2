abstract type InterestRate end

struct ConstantInterest <: InterestRate
    i::Real
end

struct VectorInterest <: InterestRate
    i::Array{<:Real,1}
end

struct FunctionalInterest <: InterestRate
    f
end

mutable struct MutableInterest <: InterestRate
    iv::Array{<:Real,1}
    f
end

"""
Construct an interest rate that is constant in all periods
"""
function InterestRate(i::Real)
    return ConstantInterest(i)
end

"""
Construct an interest rate that is constant in all periods
"""
function InterestRate(i::Array{<:Real,1})
    return VectorInterest(i)
end

"""
Construct an interest rate that is has the function signature
    f(n) -> i 
    where `n` is the period number and `i` is the interest rate in that period.
    This function cannot be dependent on prior or future periods.
"""
function InterestRate(f)
    return FunctionalInterest(f)
end


"""
Construct an interest rate that is has the function signature
    f(n,iv) -> i 
    where `n` is the period number, `iv` is a vector of floats for each prior interest
    and `i` is the interest rate in that period.
    This function can refer to prior periods by self reference and a negative period as `n`
"""
function InterestRate(f,i::Real)
    return MutableInterest([i],f)
end


"""
Return the interest rate in period n
"""
function i(ci::ConstantInterest,n)
    return ci.i
end

function i(vi::VectorInterest,n)
    return vi.i[n]
end

function i(fi::FunctionalInterest,n)
    return fi.f(n)
end

function i(mi::MutableInterest,n)
    if n < 0
        # looking for periods at end of vector
        return mi.iv[end + n + 1]
    elseif n > length(mi.iv)
        append!(mi.iv,mi.f(length(mi.iv)+1))
        return i(mi,n)
    else
        return mi.iv[n]
    end

end

## OLD CODE BELOW THIS LINE

# the discount rate from time x to x+t
function tvx(iv::InterestRate,t,x, v=1.0)
    if t > 0
        return tvx(iv,t-1,x+1,v / (1.0 + i(iv,x)))
    else
        return v
    end
end

# ω (omega), the ultimate end of the given table 
function ω(i::InterestRate)
    if length(i.ix) == 0
        return Inf
    else    
        return length(i.ix)
    end
end
w(iv::InterestRate) = ω(iv)

### Convienence functions

# the discount rate at time x
vx(iv::InterestRate,x) = tvx(iv,1.0,x,1.0)

# the discount rate at time 1
v(iv::InterestRate) = vx(iv,1)