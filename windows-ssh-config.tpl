add-content -path C:/Users/Imranm/.ssh/config -value @'

Host ${hostname}
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityFile}
'@
