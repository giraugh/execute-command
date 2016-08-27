{exec} = require 'child_process'
fs = require 'fs'
{CompositeDisposable} = require 'atom'

module.exports = ExecuteCommand =
   subscriptions: null

   config:
      command:
         type: 'string'
         default: 'run.cmd'
      showOutputNotifications:
         type: 'boolean'
         default: 'true'
      showErrorNotifications:
         type: 'boolean'
         default: 'true'
      muteNotificationRegex:
         type: 'string'
         default: ''
      regexUnmutesInstead:
         type: 'boolean'
         default: 'false'

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
      outNt = atom.config.get 'execute-command.showOutputNotifications'
      mute = atom.config.get 'execute-command.muteNotificationRegex'
      unmute = atom.config.get 'execute-command.regexUnmutesInstead'
      com = comName

      # Execute the command
      console.log "Executing #{com}"
      exec com, (error, stdout, stderr)->
         if stderr? and errorNt
            show = true
            if mute is "" or not RegExp(mute).test(stderr) then show = true
            if unmute and RegExp(mute).test(stderr) then show = true else show = false
            atom.notifications.addWarning "Error while executing command", {detail: stderr, dismissable: true} if show

         if stdout? and outNt
            if mute is "" or not RegExp(mute).test(stdout) then show = true
            if unmute and RegExp(mute).test(stdout) then show = true else show = false
            atom.notifications.addSuccess "Command Output", {detail: stdout, dismissable: true} if show
            
         if error?
            console.error "Fatal error while executing command:", error
