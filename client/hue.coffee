Lights = new Mongo.Collection("lights")

currentPage = "lightList"

Template.body.helpers
  pageTemplate: currentPage

Template.lightList.helpers
  lights: ->
    return Lights.find({}, {sort: {name: 1}})