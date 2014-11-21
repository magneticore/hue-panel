Lights = new Mongo.Collection("lights")
Meteor.subscribe("lights")

currentPage = "lightList"

Template.body.helpers
  pageTemplate: currentPage

Template.lightList.helpers
  lights: ->
    return Lights.find({}, {sort: {name: 1}})

Template.body.events
  'click a.all-on': (evt) ->
    evt.preventDefault()
    Meteor.call 'allOn'

  'click a.all-off': (evt) ->
    evt.preventDefault()
    Meteor.call 'allOff'