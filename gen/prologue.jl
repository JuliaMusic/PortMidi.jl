to_c_type(::Type{<:AbstractString}) = Cstring # or Ptr{Cchar}
to_c_type(t::Type{<:Union{AbstractArray,Ref}}) = Ptr{eltype(t)}