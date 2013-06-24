# == Class: squid
class squid (
  $filestore               = 'puppet:///files/squid',
  $package_file            = 'squid-2.6.STABLE21-6.el5.x86_64.rpm',
  # Options are in the same order they appear in squid.conf
  $squid_user              = 'squid',
  $http_port               = '3128',
  $default_site            = undef,
  $cache_peers             = [],
#  $acl                     = [],
#  $http_access             = [],
#  $icp_access              = [],
#  $tcp_outgoing_address    = [],
  $cache_mem               = '256 MB',
#  $cache_dir              = [],
  $access_log              = [ '/var/log/squid/access.log squid' ],
  $cache_log               = '/var/log/squid/cache.log',
  $cache                   = ['allow all'],
  $cache_store_log         = '/var/log/squid/store.log',
#  $via                    = 'on',
#  $ignore_expect_100      = 'off',
#  $cache_mgr              = 'root',
#  $client_persistent_connections = 'on',
#  $server_persistent_connections = 'on',
#  $forwarded_for          = 'on'
  $url_rewrite_program     = undef,
  $url_rewrite_children    = undef,
  $url_rewrite_concurrency = undef,
)
{

  if ! $default_site {
    fail( 'a default_site MUST be set for Squid' )
  }

  # include dependencies for squid 2.6
  package { 'compat-openldap.x86_64':
    ensure   => present,
  }

  package { 'openssl098e':
    ensure   => present,
  }

  package { 'squid':
#    name     => $package_file,
    ensure   => present,
    provider => 'rpm',
    source   => "/root/squid/rmp/${package_file}",
    require  => [ Package['openssl098e'], Package['compat-openldap.x86_64'] ],
  }

  service { 'squid':
    enable    => true,
    ensure    => running,
    restart   => '/sbin/service squid reload',
    hasstatus => true,
    require   => Package['squid'],
  }

  file { '/etc/squid/squid.conf':
    require => Package['squid'],
    notify  => Service['squid'],
    content => template('squid/squid27/squid.conf.erb'),
  }

  file { '/root/squid':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  file { '/root/squid/rmp':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => File['/root/squid'],
  }

  file { 'squid-rpm':
    ensure  => file,
    path    => "/root/squid/rmp/${package_file}",
    source  => "${filestore}/${package_file}",

  }
}
