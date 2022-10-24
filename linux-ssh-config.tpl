cat << EOF >> ~/.ssh/config

Host ${hostname}
  HostName ${hostname}
  IdentityFile ${identityFile}
  User ${user}
EOF
