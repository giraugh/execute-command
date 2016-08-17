exec = require('child_process').exec
{CompositeDisposable} = require 'atom'

module.exports = ExecuteCommand =
   subscriptions: null

   config:
      command:
         type: 'string'
         default: 'run.cmd'

   activate: (state) ->
      atom.config.set 'execute-command.command', 'run.cmd'

      # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
      @subscriptions = new CompositeDisposable

      # Register command that toggles this view
      @subscriptions.add atom.commands.add 'atom-workspace',
      'execute-command:execute': => @execute()

   deactivate: ->
      @subscriptions.dispose()

   execute: ->
      console.log "Executing #{atom.config.get('execute-command.command')}"
      exec atom.config.get('execute-command.command')
