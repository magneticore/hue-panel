Lights = new Mongo.Collection("lights")
Meteor.subscribe("lights")

Session.set("currentPage", "lightList")
Session.set("currentBulb", null)

Template.body.helpers
  currentPage: ->
    return Session.get("currentPage")

Template.lightList.helpers
  lights: ->
    return Lights.find({}, {sort: {name: 1}})

Template.bulbPanel.helpers
  bulb: ->
    return Lights.findOne( {id: Session.get("currentBulb")})

Template.body.events
  'click header h1': ->
    Session.set("currentBulb", null)
    Session.set("currentPage", "lightList")

  'click a.all-on': (evt) ->
    evt.preventDefault()
    Meteor.call 'allOn'

  'click a.all-off': (evt) ->
    evt.preventDefault()
    Meteor.call 'allOff'

  'click a.all-default': (evt) ->
    evt.preventDefault()
    Meteor.call 'allDefault'

  'click #light-list a': (evt) ->
    evt.preventDefault()
    Session.set("currentBulb", this.id)
    Session.set("currentPage", "bulbPanel")

Template.bulbPanel.events
  'change input[type=range]': ->
    data = {
      id: Session.get "currentBulb"
      state: {
        hue: parseInt($('.hue-range').val(), 10)
        sat: parseInt($('.saturation-range').val(), 10)
        bri: parseInt($('.brightness-range').val(), 10)
      }
    }
    Meteor.call "setBulb", data

  'click a.bulb-on': (evt) ->
    evt.preventDefault()
    Meteor.call "bulbOn", Session.get("currentBulb")

  'click a.bulb-off': (evt) ->
    evt.preventDefault()
    Meteor.call "bulbOff", Session.get("currentBulb")

  'click a.bulb-default': (evt) ->
    evt.preventDefault()
    Meteor.call "bulbDefault", Session.get("currentBulb")
