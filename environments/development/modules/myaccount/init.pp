class myaccount {

  if(!defined(Package['git'])) {
    package {
      'git':
        ensure => present;
    }
  }

  ensure_resource('package',
                    ['curl',
                    'build-essential',# solves error when running npm install
                    ],
                    { 'ensure' => 'present'
                    })

  package { 'ubuntu-desktop':
    ensure          => installed
    #install_options => ['--no-install-recommends'],
  }

  package { 'virtualbox-guest-additions-iso':
    ensure          => installed
  }

  exec {
    'nodesource':
      command => 'curl --silent --location https://deb.nodesource.com/setup_4.x | bash -',
      path    => ['/bin', '/usr/bin'],
      unless  => 'grep -r /etc/apt/sources.list.d/ -e "node_4.x"',
      require => Package['curl'],
      notify  => Exec['apt-get update'];
  }

  ensure_resource('package',
                    ['nodejs', # cloud server - will include npm
                    ],
                    { 'ensure' => 'present', 'require' => 'Exec[nodesource]'
                    })

  exec { 'set node version':
    command => 'n 4.6.0',
    path    => ['/bin', '/usr/bin'],
    require => Package['n']
  }

  ensure_resource('package',
                  ['bower',     # Web client
                  'http-server',# Web client
                  'grunt',      # cloud server
                  'forever',    # cloud server - run as a service
                  'n',          # node version manager
                  ],
                  { 'provider' => 'npm',
                  'ensure' => 'present',
                  'require' => 'Package[nodejs]'
                  }
  )

  user {
    'myaccount':
      ensure     => present,
      shell      => '/bin/bash',
      home       => '/home/myaccount',
      managehome => 'yes',
      # password is myaccount
      password   => '$1$NUEqnKvH$j.oNAabDwkUSprkKtb1At/';
  }

  file {
    '/etc/sudoers.d/myaccount':
    source => 'puppet:///modules/myaccount/sudoers',
    owner => 'root',
    group => 'root',
    mode => '0644';
  }

  file {
    '/home/myaccount':
      ensure  => directory,
      owner   => 'myaccount',
      group   => 'myaccount',
      mode    => '0755',
      require => User['myaccount'];
    '/home/myaccount/.ssh':
      ensure  => directory,
      owner   => 'myaccount',
      group   => 'myaccount',
      mode    => '0700',
      require => User['myaccount'];
  }

 file {
    "/var/lib/locales/supported.d/local":
    content => "en_US UTF-8\n",
    notify  => Exec["generate-locales"];
    "/etc/default/locale":
      source => "puppet:///modules/myaccount/locale";
  }
  
  exec {
    "generate-locales":
     command => "/usr/sbin/dpkg-reconfigure --frontend=noninteractive locales",
     refreshonly => true;
  }
}