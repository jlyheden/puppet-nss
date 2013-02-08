# == Define: nss::directive
#
#   This ressource type define an entry into /etc/nsswitch.conf
#   file. For example you can add ldap for group database into
#   /etc/nsswitch.conf and ensure file isn't present.
#
# === Parameters
#
# [*ensure*]
#   Define if the directive should be present
#   Valid values: <tt>present</tt>, <tt>absent</tt>
#
# [*database*]
#   Database to used (like passwd, group, shawdow)
#   Valid values: see nss::params::valid_databases or man nsswitch.conf
#
# [*service*]
#   Service to add to database
#   Valid values: see man nsswitch.conf
#
# === Sample usage
#
# nss::directive { 'passwd_ldap':
#   ensure    => present,
#   database  => 'passwd',
#   service   => 'ldap'
# }
#
# === Author
#
# Johan Lyheden <johan.lyheden@artificial-solutions.com>
# Inspired by https://github.com/lermit/puppet-nss/blob/master/manifests/directive.pp
#
define nss::directive ( $database, $service, $ensure = 'present') {
  
  # input validation, however it should be technically impossible
  # to insert any invalid database in the sed script
  validate_re($database, $nss::params::valid_databases)

  case $ensure {
    absent: {
	    exec { "nss_remove_${database}_${service}":
	      command => "sed -i 's/^\\(${database}:.*\\)${service}\\(.*\\)$/\\1\\2/g' ${nss::params::config_file}",
	      onlyif  => "grep '^${database}:' ${nss::params::config_file} | grep '${service}'",
	      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
	    }
    }
    present: {
	    exec { "nss_add_${database}_${service}":
	      command => "sed -i 's/^${database}:\\(.*\\)/${database}:\\1 ${service}/g' ${nss::params::config_file}",
	      unless  => "grep '^${database}:' ${nss::params::config_file} | grep '${service}'",
	      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
	    }
    }
    default: {
      fail("Unsupported ensure parameter value ${ensure}")
    }
  }

}