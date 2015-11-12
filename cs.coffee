cs = {
    # Array to hold host objects
    hosts: []

    # Add a new host
    addHost: (name) ->
      @.hosts[name] = {buffer: undefined} if !@.hosts[name]

}

module.exports = cs
