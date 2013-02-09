# Module: nss

This is the Puppet module for managing NSS - Name Service Switch
Via NSS it's possible to control which data sources should be used
for different databases, such as user account database.

## Dependencies

* puppet-stdlib: https://github.com/puppetlabs/puppetlabs-stdlib

### Usage: nss

Including the nss in it self will not do much since it's installed
by default. It however allows you to manage /etc/nsswitch.conf if
you like.

	class { 'nss':
		source => 'puppet:///mymodule/nsswitch.conf'
	}

Or you can simply include it:

	include nss


### Usage: nss::ldap

Manages the ldap component of nss. If you include this module
then ldap will be added to the passwd, group and shadow nss
database

	include nss::ldap

You can also override some parameters:

	class { 'nss::ldap':
		ensure      => present,
		autoupgrade => true
	}

### Usage: nss::directive

Manages individual entries in nsswitch.conf - the nss::ldap class
uses this define to add the three entries. It can be used to add
additional entries if necessary:

	nss::directive { 'passwd_mysql':
		ensure   => present,
		database => 'passwd',
		service  => 'mysql'
	}

