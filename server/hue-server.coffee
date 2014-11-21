Lights = new Mongo.Collection("lights");

Bridge = {}
Bridge.hue_user = "huepaneluser"

defaultState = JSON.stringify({
  alert: "none", hue: 14922, effect: "none",
  sat: 60, bri: 254, on: true
})

onState = JSON.stringify({ on: true })
offState = JSON.stringify({ on: false })

Meteor.methods
  getBridgeData: ->
    return Meteor.http.call "GET", "http://www.meethue.com/api/nupnp"

  getLightsData: ->
    return Meteor.http.call "GET", "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights"

  setLightsData: ->
    Meteor.call "getLightsData", (error, results) ->
      for k,v of results.data
        v.id = k
        Lights.upsert({id: k}, v)

  allOn: ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/groups/1/action"
    Meteor.http.call "PUT", url, { content: onState }
    Meteor.call "setLightsData"

  allOff: ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/groups/1/action"
    Meteor.http.call "PUT", url, { content: offState }
    Meteor.call "setLightsData"

  allDefault: ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/groups/1/action"
    Meteor.http.call "PUT", url, { content: defaultState }
    Meteor.call "setLightsData"


  bulbOn: (bulb) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{bulb}/state"
    Meteor.http.call "PUT", url, { content: onState }
    Meteor.call "setLightsData"

  bulbOff: (bulb) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{bulb}/state"
    Meteor.http.call "PUT", url, { content: offState }
    Meteor.call "setLightsData"

  bulbDefault: (bulb) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{bulb}/state"
    Meteor.http.call "PUT", url, { content: defaultState }
    Meteor.call "setLightsData"

  setBulb: (data) ->
    url = "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights/#{data.id}/state"
    Meteor.http.call "PUT", url, { content: JSON.stringify data.state }
    Meteor.call "setLightsData"


Meteor.startup ->

  # We only care about the first connected bridge
  # for now, because I only have one bridge.
  Meteor.call "getBridgeData", (error, results) ->
    Bridge.local_ip = results.data[0].internalipaddress
    Meteor.call "setLightsData"

  Meteor.publish "lights", ->
    Lights.find {}

  Meteor.publish "Bridge", ->
    Bridge
