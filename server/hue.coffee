Lights = new Mongo.Collection("lights");

Bridge = {}

Meteor.methods
  getBridgeData: ->
    return Meteor.http.call "GET", "http://www.meethue.com/api/nupnp"
  setLightsData: ->
    return Meteor.http.call "GET", "http://#{Bridge.local_ip}/api/#{Bridge.hue_user}/lights"

Meteor.startup ->

  Bridge.hue_user = "huepaneluser"

  Meteor.call "getBridgeData", (error, results) ->
    Bridge.local_ip = results.data[0].internalipaddress

    Meteor.call "setLightsData", (error, results) ->
      for k,v of results.data
        v.id = k
        Lights.upsert({id: k}, v)

