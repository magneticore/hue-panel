Lights = new Mongo.Collection("lights");

Template.body.helpers
  pageTemplate: "lightList"  

Template.lightList.helpers
  lights: ->
    return Lights.find({}, {sort: {name: 1}})