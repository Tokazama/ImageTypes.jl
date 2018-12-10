module ImageTypes

using ImageCore, ImageAxes, ImageMetadata, AxisArrays
export MetaAxisArray, MetaSizedArray, MetaSArray, MetaMArray,
       MetaAxisSizedArray, MetaAxisSArray, MetaAxisMArray, AxisSizedArray,
       AxisSArray, AxisMArray
i# TODO
# - SharedArrays
# - mappedarray
# - GPUArrays
# - SparseArrays
# - GeometryTypes.mesh

# chunks
# Arrays
# only renaming for consistency with other names

const MetaAxisArray{T,N} = ImageMeta{T,N,AxisArray{T,N,Array{T,N}}}
function MetaAxisArray(A::AbstractArray, props::Dict, axes::Axis...)
    ImageMeta(AxisArray(A, axes...), props::Dict)
end

function MetaAxisArray(A::AbstractArray, props::Dict, names::Symbol...)
    ImageMeta(AxisArray(A, names...), props::Dict)
end

function MetaAxisArray(A::AbstractArray, props::Dict, names::NTuple{N,Symbol}, steps::NTuple{N,Number}, offsets::NTuple{N,Number}=map(zero, steps))
    ImageMeta(AxisArray(A, names, steps, offsets), props::Dict)
end

function MetaAxisArray(A::AbstractArray, axes::Axis...; kwargs...)
    ImageMeta(AxisArray(A, axes...); kwargs...)
end

function MetaAxisArray(A::AbstractArray, names::Symbol...; kwargs...)
    ImageMeta(AxisArray(A, names...); kwargs...)
end

function MetaAxisArray(A::AbstractArray, names::NTuple{N,Symbol}, steps::NTuple{N,Number}, offsets::NTuple{N,Number}=map(zero, steps); kwargs...)
    ImageMeta(AxisArray(A, names, steps, offsets))
end

# ImageMeta{StaticArrays}
for (newtype, arraytype) in ((:MetaSizedArray, :SizedArray),
                             (:MetaSArray, :SArray),
                             (:MetaMArray, :MArray))
    @eval begin
        const $newtype{S,T} = ImageMeta{T,N,$arraytype{S,T,N,L}} where {N,L}

        $newtype{S,T}(x::NTuple{L,T}, props::Dict) where {S<:Tuple} = ImageMeta($arraytype{S,T}(x), props)
        $newtype{S,T}(x::NTuple{L,T}; kwargs...) where {S<:Tuple} = ImageMeta($arraytype{S,T}(x); kwargs...)
    end
end

# AxisArrays{StaticArrays}
# FIXME needs Ax trait settings
for (newtype, arraytype) in ((:AxisSizedArray, :SizedArray),
                             (:AxisSArray, :SArray),
                             (:AxisMArray, :MArray))
    @eval begin
        const $newtype{S<:Tuple,T} = AxisArray{T,N,$arraytype{S,T,N,L}} where {N,L}

        $newtype{S,T}(x::NTuple{L,T}, axes::Axis...) where {S<:Tuple,T,L}
        $newtype{S,T}(x::NTuple{L,T}, names::Symbol...) where {S<:Tuple,T,L}
        $newtype{S,T}(x::NTuple{L,T},
                      names::NTuple{N,Symbol},
                      steps::NTuple{N,Number},
                      offsets::NTuple{N,Number}=map(zero, steps)) where {S<:Tuple,T,L} = AxisArray($newtype{S,T}(x), names, steps, offsets)

    end
end

# ImageMetaAxis{StaticArrays}
for (newtype, arraytype) in ((:MetaAxisSizedArray, :SizedArray),
                             (:MetaAxisSArray, :SArray),
                             (:MetaAxisMArray, :MArray))
    @eval begin
        const $newtype{S<:Tuple,T} = ImageMeta{T,N,AxisArray{T,N,$arraytype{S,T,N,L}}} where {N,L}

        function $newtype{S,T}(A::AbstractArray, props::Dict, axes::Axis...) where {S<:Tuple,T}
            ImageMeta(AxisArray($arraytype(A), axes...), props)
        end

        function $newtype{S,T}(A::AbstractArray, props::Dict, names::Symbol...) where {S<:Tuple,T}
            ImageMeta(AxisArray($arraytype(A), names...), props)
        end

        function $newtype{S,T}(A::AbstractArray, props::Dict, names::NTuple{N,Symbol}, steps::NTuple{N,Number}, offsets::NTuple{N,Number}=map(zero, steps)) where {S<:Tuple,T}
            ImageMeta(AxisArray($arraytype(A), names, steps, offsets), props)
        end

        function $newtype{S,T}(A::AbstractArray, axes::Axis...; kwargs...) where {S<:Tuple,T}
            ImageMeta(AxisArray($arraytype{S,T}(A), axes...); kwargs...)
        end

        function $newtype{S,T}(A::AbstractArray, names::Symbol...; kwargs...) where {S<:Tuple,T}
            ImageMeta(AxisArray($arraytype{S,T}(A), names...); kwargs...)
        end

        function $newtype{S,T}(x::NTuple{L,Any}, names::NTuple{N,Symbol}, steps::NTuple{N,Number}, offsets::NTuple{N,Number}=map(zero, steps); kwargs...) where {S<:Tuple,T}
            ImageMeta(AxisArray($arraytype{S,T}(x), names, steps, offsets); kwargs...)
        end

    end
end



end
