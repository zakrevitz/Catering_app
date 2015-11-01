define [
  'underscore'
  'backbone'
], (_, Backbone) ->
  'use strict';

  class SessionModel extends Backbone.Model
    url: 'v1/sessions/sign_in.json'
    initialize: () ->
      self = this
      
      $.ajaxPrefilter( (options, originalOptions, jqXHR) ->
        options.xhrFields =
          withCredentials: true
        # CORS support
        options.crossDomain =
          crossDomain: true
        #if self.get('auth_token')?
        #  jqXHR.setRequestHeader('X-Auth-Token', self.get('auth_token'))
      )

    defaults: {}

    login: (params) ->
      # {email: "ivan@ivan.ivan", password: "1234567890"}
      this.save(params, 
        success: (model, response) ->
          console.log "SUCCESS"
        error: (model, response) ->
          console.log "ERROR", response
      )
       #Just for testing
      #this.set({auth: true, name: 'Ivan Dron'})

    logout: (params) ->
      self = this

      this.destroy(
        success: (model, response) ->
          model.clear()
          model.id = null

          self.set({auth: false, name: null})
      )

    getAuth: (callback) ->
      this.fetch(
        success: callback
      )

  return new SessionModel()