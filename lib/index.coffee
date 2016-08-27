exec = require('child_process').exec
{CompositeDisposable} = require 'atom'

module.exports = ExecuteCommand =
   subscriptions: null

   config:
      command:
         type: 'string'
         default: 'run.cmd'
      logErrors:
         type: 'boolean'
         default: 'false'

   activate: (state) ->
      atom.config.set 'execute-command.command', 'run.cmd'
      atom.config.set 'execute-command.logErrors', 'false'

      # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
      @subscriptions = new CompositeDisposable

      # Register command that toggles this view
      @subscriptions.add atom.commands.add 'atom-workspace',
      'execute-command:execute': => @execute()

   deactivate: ->
      @subscriptions.dispose()

   execute: ->
      com = atom.config.get('execute-command.command')
      if atom.config.get('execute-command.logErrors')
         com += "2>error.txt"
      console.log "Executing #{com}"
      exec com
