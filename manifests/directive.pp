# == Define: nss::directive
#
#   This ressource type define an entry into /etc/nsswitch.conf
#   file. For example you can add ldap for group database into
#   /etc/nsswitch.conf and ensure file isn't present.
#
# === Parameters
#
# [*ensure*]
#   Define if the directive should be present (default) or 'absent'
#
# [*database*]
#   Database to used (Like passwd, group, shawdow).
#   man nsswitch.conf provide a full list of avariable database.
#
# [*service*]
#   Service to add to database.
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
# Inspired by https://github.com/lermit/puppet-nss/blob/master/manifests/directive.pp
# Johan Lyheden <johan.lyheden@artificial-solutions.com>
#
define nss::directive ( $database, $service, $ensure = 'present') {
  
  # input validation
  validate_re($database, $nss::params::valid_databases)

  if $ensure == 'absent' {
    exec { "nss_remove_${database}_${service}":
      command => "sed -i 's/^\\(${database}:.*\\)${service}\\(.*\\)$/\\1\\2/g' ${nss::params::config_file}",
      onlyif  => "grep '^${database}:' ${nss::params::config_file} | grep '${service}'",
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }
  } else {
    exec { "nss_add_${database}_${service}":
      command => "sed -i 's/^${database}:\\(.*\\)/${database}:\\1 ${service}/g' ${nss::params::config_file}",
      unless  => "grep '^${database}:' ${nss::params::config_file} | grep '${service}'",
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }
  }

}
