{exec, execSync} = require 'child_process'
fs = require 'fs'
{CompositeDisposable} = require 'atom'

module.exports = ExecuteCommand =
   subscriptions: null

   config:
      command:
         type: 'string'
         default: 'run.cmd'
      executeSynchronously:
         type: 'boolean'
         default: 'true'
      logErrors:
         type: 'boolean'
         default: 'false'
      errorLogFilename:
         type: 'string'
         default: 'error.txt'
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
      comName = atom.config.get('execute-command.command')
      sync = atom.config.get('execute-command.executeSynchronously')
      logErrors = atom.config.get('execute-command.logErrors')
      errorFn = atom.config.get('execute-command.errorLogFilename')
      errorNt = atom.config.get('execute-command.showErrorNotifications')
      com = comName

      # Check if we create an error log
      if logErrors
         com += " 2>#{errorFn}"
         # Delete the old error file
         exec "del #{errorFn}"

      # Execute the command
      console.log "Executing #{com}"
      unless sync
         exec com
      else
         execSync com

      # Does the error file exist
      if logErrors and errorNt
         try
            stats = fs.statSync errorFn
            data = fs.readFileSync errorFn, 'utf-8'
            console.warn "error while executing command: " + data
            atom.notifications.addWarning "Execute Command Error", {detail: data, dismissable: true}
