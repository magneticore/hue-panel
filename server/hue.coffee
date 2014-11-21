Lights = new Mongo.Collection("lights");

# Cotainer for bridge connection details
Bridge = {}
Bridge.hue_user = "huepaneluser"

Meteor.methods
  getBridgeData: ->
    return Meteor.http.call "GET", "http://www.meethue.com/api/nupnp"

  setLightsData: ->
    return Meteor.http.call "GET", "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights"

  allOn: (data) ->
    console.log "all on"

  allOff: (data) ->
    console.log "all off"

  setBulb: (data) ->
    console.log data

  setAll: (data) ->
    console.log data

Meteor.startup ->

  # We only care about the first connected bridge
  # for now, because I only have one bridge.
  Meteor.call "getBridgeData", (error, results) ->
    Bridge.local_ip = results.data[0].internalipaddress

    # Current state of lights gets stored in the DB so
    # we can easily add favorites.
    Meteor.call "setLightsData", (error, results) ->
      for k,v of results.data
        v.id = k
        Lights.upsert({id: k}, v)

  Meteor.publish "lights", ->
    Lights.find {}

  Meteor.publish "Bridge", ->
    Bridge
