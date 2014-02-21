role :app, %w{192.168.1.62}
role :web, %w{192.168.1.62}
role :db,  %w{192.168.1.62}

server '192.168.1.62',
  roles: %w{app},
  ssh_options: {
    user: 'deployer',
    keys: %w(/home/deployer/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(password),
    password: 'mingming1'
  }
