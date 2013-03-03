# == Define: nss::directive
#
# This ressource type define an entry into /etc/nsswitch.conf
# file. For example you can add ldap for group database into
# /etc/nsswitch.conf and ensure file isn't present.
#
# The solution here has some drawbacks, for example it's not
# possible to control order of the services declared in each
# database. Complex setups should be controlled by managing
# nsswitch.conf via the nss class
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
define nss::directive (
  $database,
  $service,
  $ensure = 'present'
) {

  include nss::params

  # Input validation
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
