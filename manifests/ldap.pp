# == Class: nss::ldap
#
# Installs and enables NSS with LDAP support
# This involves installing the nss-ldap package as well
# as defining ldap as databases for the passwd, group and shadow services
#
# === Parameters
#
# [*ensure*]
#   Controls the software installation
#   Valid values: <tt>present</tt>, <tt>absent</tt>, <tt>purge</tt>
#
# [*autoupgrade*]
#   If Puppet should upgrade the software automatically
#   Valid values: <tt>true</tt>, <tt>false</tt>
#
# === Sample usage
#
# include nss::ldap
#
# === Author
#
# Johan Lyheden <johan.lyheden@artificial-solutions.com>
#
class nss::ldap ( $ensure = $nss::params::ensure,
                  $autoupgrade = $nss::params::autoupgrade ) inherits nss::params {
  
  # Manages automatic upgrade behavior
  if $ensure == 'present' and $autoupgrade == true {
    $ensure_package = 'latest'
  } else {
    $ensure_package = $ensure
  }

  package { $nss::params::nss_ldap_package:
    ensure  => $ensure_package
  }

  nss::directive { 'passwd_ldap':
    ensure    => $ensure,
    database  => 'passwd',
    service   => 'ldap'
  }

  nss::directive { 'group_ldap':
    ensure    => $ensure,
    database  => 'group',
    service   => 'ldap'
  }

  nss::directive { 'shadow_ldap':
    ensure    => $ensure,
    database  => 'shadow',
    service   => 'ldap'
  }

}
