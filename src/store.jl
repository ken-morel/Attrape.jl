getappdatadir(a::Application) = joinpath(datadir(), a.id)
getappcachedir(a::Application) = joinpath(cachedir(), a.id)
getappconfigdir(a::Application) = joinpath(configdir(), a.id)

getdatastore(a::Application, name::String = "datastore") = datastore(joinpath(getappdatadir(a), name))
getcachestore(a::Application, name::String = "datastore") = datastore(joinpath(getappcachedir(a), name))
getconfigstore(a::Application, name::String = "datastore") = datastore(joinpath(getappconfigdir(a), name))
