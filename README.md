# puppet-squid

Based on https://forge.puppetlabs.com/thias/squid3

Manages Squid instalaltion and configuration.

## Notes

* Only tested with Squid 2.6. In order to install other versions, a few changes are required, i.e. indicating a new template for squid.conf.
* Executed on CentOS 6.4. Dependencies are manually installed for this OS:
    compat-openldap.x86_64
    openssl098e
* This module installs Squid 2.6 on CentOS using the corresponding RMP.
* This module configures Squid 2.6 on accelerator mode. The port can be set accordingly.
* In general, there are a few hardcoded options within the ERB template used, which you may want to check and adjust to your installation.

## Usage

### The Squid RPM

squid::filestore:           'puppet:///files/squid'

squid::package_file:        'squid-2.6.STABLE21-6.el5.x86_64.rpm'


### Logging

squid::access_log:          '/var/log/squid/access.log squid'

squid::cache_log:           '/var/log/squid/cache.log'

squid::cache_store_log:     '/var/log/squid/store.log'

### Caching rules
Use this to force certain objects to never be cached using ACLs

squid::cache:               'allow all'

### Communitation with other peers

squid::cache_peers: [
  'balancer.mytomcatservers.mydomain.org parent 8080 0 no-query default'
  'the_other_peer.mydomain.org sibling 3128 3130'
]

### URL rewriting

squid::url_rewrite_program: '/usr/java/latest/bin/java -cp %CLASSPATH% foo.MainClass %param1% ... %paramN%'

squid::url_rewrite_children: 10

squid::url_rewrite_concurrency: 10

### Miscelaneous

squid::default_site: 'balancer.mytomcatservers.mydomain.org'

squid::user:         'squid'

squid::http_port:    '3128'

squid::cache_mem:    '1536 MB'


## Support

License: Apache License, Version 2.0

GitHub URL: http://erwbgy.github.com/puppet-logscape
