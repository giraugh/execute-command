var CompositeDisposable, ExecuteCommand, exec;

exec = require('child_process').exec;

CompositeDisposable = require('atom').CompositeDisposable;

module.exports = ExecuteCommand = {
  subscriptions: null,
  config: {
    command: {
      type: 'string',
      "default": 'run.cmd'
    }
  },
  activate: function(state) {
    atom.config.set('execute-command.command', 'run.cmd');
    this.subscriptions = new CompositeDisposable;
    return this.subscriptions.add(atom.commands.add('atom-workspace', {
      'execute-command:execute': (function(_this) {
        return function() {
          return _this.execute();
        };
      })(this)
    }));
  },
  deactivate: function() {
    return this.subscriptions.dispose();
  },
  execute: function() {
    console.log("Executing " + (atom.config.get('execute-command.command')));
    return exec(atom.config.get('execute-command.command'));
  }
};
