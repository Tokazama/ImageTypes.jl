using StaticArrays, ImageMetadata

"""
Point{1,Int,1,Int}(Point{1,Int}(1), SVector(1))
"""
struct Point{Np,Tp,Ns,Ts}
    position::SVector{Np,Tp}
    scalars::SVector{Ns,Ts}
    function Point{Np,Tp,Ns,Ts}(p::SVector{Np,Tp}, s::SVector{Ns,Ts}) where {Np,Tp,Ns,Ts}
        new(p, s)
    end
end

function Point(p::P, s::S) where {P<:SVector, S<:SVector}
    Point{length(p),eltype(p),length(s),eltype(s)}(p, s)
end

function Point(p::P, s::S) where {P<:SVector, S<:NTuple{N,T} where {N,T}}
    Point{length(p),eltype(p),length(s),eltype(s)}(p, SVector{length(s),eltype(s)}(s))
end

function Point(p, s) where {P<:NTuple{Np,Tp}, S<:SVector where {Np,Tp}}
    Point{length(p),eltype(p),length(s),eltype(s)}(SVector{length(p),eltype(p)}(p), SVector{length(s),eltype(s)}(s))
end

function Point(p, s) where {P<:NTuple{Np,Tp, S<:NTuple{Ns,Ts} where {Np,Tp,Ns,Ts}}}
    Point{length(p),eltype(p),length(s),eltype(s)}(SVector{length(p),eltype(p)}(p), SVector{length(s),eltype(s)}(s))
end

function Point(p, s)
    Point{length(p),eltype(p),length(s),eltype(s)}(SVector{length(p),eltype(p)}(p), SVector{length(s),eltype(s)}(s))
end

Point(p::NTuple{Np,Tp}, s::NTuple{Ns,Ts}) where {Np,Tp,Ns,Ts} = Point{Np,Tp,Ns,Ts}(SVector{Np,Tp}(p), SVector{Ns,Ts}(s))
Point(p::NTuple{Np,Tp}, s::NTuple{0}) where {Np,Tp} = Point{Np,Tp,0,UInt8}(SVector{Np,Tp}(p), SVector{0,UInt8}(s))

Base.ndims(p::Point{Np,Tp,Ns,Ts}) where {Np,Tp,Ns,Ts} = Np

"""
PathMeta{V}

A is any subtype of AbstractVector.


```
tmpvec = [Point((1,1),()),Point((1,1),())]
tmpdict = Dict{String,Any}()
PathMeta(tmpvec, tmpdict)
```

"""
const PathMeta{V} = ImageMeta{T,1,V} where {V<:AbstractVector, T<:Point{Np,Tp,Ns,Ts} where {Np,Tp,Ns,Ts}}
function PathMeta(data::AbstractVector{<:Point}, props::Dict{String,Any})
    ImageMeta(data, props)
end

function load(s, ::Type{PathMeta{Vector}})
    ImageMeta(load(s, fieldtype(PathMeta, :data)))
end

"""
const Point2{N,T} = Point{2,Int,N,T}
Point2(p::NTuple{2,Int}, s::NTuple{N,T}) where {N,T} = Point{2,Int,N,T}(p, s)

const Point2f0{N,T} = Point{2,Float32,N,T}
Point2(p::NTuple{2,Float32}, s::NTuple{N,T}) where {N,T} = Point2f0{N,T}(SVector{2,Float32}(p), SVector{N,T}(s))


const Point3{N,T} = Point{3,Int,N,T}
Point3(p::NTuple{3,Int}, s::NTuple{N,T}) where {N,T} = Point{N,T}(SVector{3,Int}(p), SVector{N,T}(s))

const Point3f0{N,T} = Point{3,Float32,N,T}
Point2(p::NTuple{3,Float32}, s::NTuple{N,T}) where {N,T} = Point3f0{N,T}(SVector{3,Float32}(p), SVector{N,T}(s))
function SPathMeta(data::SVector{L,Point{Sp,Tp,Ss,Ts}},  props::Dict{String,Any}) where {Sp,Tp,Ss,Ts,L}
    SPathMeta{Sp,Tp,Ss,Ts,L}(data, props)
end

function MPathMeta(data::MVector{L,Point{Sp,Tp,Ss,Ts}},  props::Dict{String,Any}) where {Sp,Tp,Ss,Ts,L}
    MPathMeta{Sp,Tp,Ss,Ts,L}(data, props)
end
"""





