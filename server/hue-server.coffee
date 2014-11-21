Lights = new Mongo.Collection("lights");

# Cotainer for bridge connection details
Bridge = {}
Bridge.hue_user = "huepaneluser"

# Set some pre-programmed light states
defaultState = JSON.stringify({
  alert: "none",
  hue: 14922,
  effect: "none",
  sat: 60,
  bri: 254,
  on: true
})

onState = JSON.stringify({
  on: true
})

offState = JSON.stringify({
  on: false
})

Meteor.methods
  getBridgeData: ->
    return Meteor.http.call "GET", "http://www.meethue.com/api/nupnp"

  setLightsData: ->
    return Meteor.http.call "GET", "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights"


  allOn: ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/groups/1/action"
    Meteor.http.call "PUT", url, { content: onState }

  allOff: ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/groups/1/action"
    Meteor.http.call "PUT", url, { content: offState }

  allDefault: ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/groups/1/action"
    Meteor.http.call "PUT", url, { content: defaultState }


  bulbOn: (bulb) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{bulb}/state"
    Meteor.http.call "PUT", url, { content: onState }

  bulbOff: (bulb) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{bulb}/state"
    console.log Meteor.http.call "PUT", url, { content: offState }

  bulbDefault: (bulb) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{bulb}/state"
    Meteor.http.call "PUT", url, { content: defaultState }


  setBulb: (data) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{data.id}/state"
    Meteor.http.call "PUT", url, { content: JSON.stringify data.state }




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
