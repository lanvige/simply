role :app, %w{10.0.0.11}
role :web, %w{10.0.0.11}
role :db,  %w{10.0.0.11}

server '10.0.0.11',
  roles: %w{app},
  ssh_options: {
    user: 'deployer',
    keys: %w(/home/deployer/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(password),
    password: 'mingming1'
  }
