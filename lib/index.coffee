{exec} = require 'child_process'
fs = require 'fs'
{CompositeDisposable} = require 'atom'

module.exports = ExecuteCommand =
   subscriptions: null

   config:
      command:
         type: 'string'
         default: 'run.cmd'
      showErrorNotifications:
         type: 'boolean'
         default: 'true'

   activate: (state) ->

      # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
      @subscriptions = new CompositeDisposable

      # Register command that toggles this view
      @subscriptions.add atom.commands.add 'atom-workspace',
      'execute-command:execute': => @execute()

   deactivate: ->
      @subscriptions.dispose()

   execute: ->
      comName = atom.config.get 'execute-command.command'
      errorNt = atom.config.get 'execute-command.showErrorNotifications'
      com = comName

      # Execute the command
      console.log "Executing #{com}"
      exec com, (error, stdout, stderr)->
         if stderr? and errorNt
            atom.notifications.addWarning "Error while executing command", {detail: stderr, dismissable: true}
