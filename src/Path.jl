
struct Point2 <: FieldVector{2,T}
    x::T
    y::T
end

struct Point3 <: FieldVector{3,T}
    x::T
    y::T
    z::T
end

struct Point4 <: FieldVector{4,T}
    x::T
    y::T
    z::T
    w::T
end

struct Particle2{Tp,Ts,N}
    position::Point2{Tp}
    scalars::MVector{N,T}
end

struct Particle3{Tp,Ts,N}
    position::Point3{Tp}
    scalars::MVector{N,T}
end

struct Particle4{Tp,Ts,N}
    position::Point4{Tp}
    scalars::MVector{N,T}
end

const Point2Path{Tp,Ts,N} = Vector{Point2{Tp,Ts,N}}
const Point3Path{Tp,Ts,N} = Vector{Point3{Tp,Ts,N}}
const Point4Path{Tp,Ts,N} = Vector{Point4{Tp,Ts,N}}

const Particle2Path{Tp,Ts,N} = Vector{Particle2{Tp,Ts,N}}
const Particle3Path{Tp,Ts,N} = Vector{Particle3{Tp,Ts,N}}
const Particle4Path{Tp,Ts,N} = Vector{Particle4{Tp,Ts,N}}



