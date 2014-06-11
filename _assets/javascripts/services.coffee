PTB.Services = do ->
  loadedServices = {}

  inject: (serviceName)->
    loadedServices[serviceName] ||= new PTB.Services[serviceName]
    loadedServices[serviceName]

