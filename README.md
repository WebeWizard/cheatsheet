####Installing and running the server

Requires Node
 Install global dependencies
 - ```npm install -g coffee-script```
 - ```npm install -g nodemon``` (restarts the server on file change)

 Then install project dependencies
 - ```npm install```

Start the server with ```npm start``` or ```coffee app.coffee```

####Example plugin for Oh-My-Zsh (Cntrl+K sends buffer to local server)
~/.oh-my-zsh/custom/plugins/cheatsheet/cheatsheet.plugin.zsh
```
#!/bin/zsh

function sendBuffer {
  curl  "http://localhost:4321/$HOST" --data-urlencode "buffer=$BUFFER" > /dev/null 2>&1
}
zle -N sendBuffer
bindkey '^K' 'sendBuffer'
```
