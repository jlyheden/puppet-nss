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
#   Valid values: <tt>present</tt>, <tt>absent</tt>, <tt>purged</tt>
#
# [*autoupgrade*]
#   If Puppet should upgrade the software automatically
#   Valid values: <tt>true</tt>, <tt>false</tt>
#
# === Sample usage
#
# include nss::ldap
#
class nss::ldap (
  $ensure       = 'UNDEF',
  $autoupgrade  = 'UNDEF'
) {

  include nss::params

  $ensure_real = $ensure ? {
    'UNDEF' => $nss::params::ensure,
    default => $ensure
  }
  $autoupgrade_real = $autoupgrade ? {
    'UNDEF' => $nss::params::autoupgrade,
    default => $autoupgrade
  }
  $ensure_directive = $ensure_real ? {
    'purged'  => 'absent',
    default   =>  $ensure_real
  }

  # Input validation
  validate_re($ensure_real,$nss::params::valid_ensure_values)
  validate_bool($autoupgrade_real)

  # Manages automatic upgrade behavior
  if $ensure_real == 'present' and $autoupgrade_real == true {
    $ensure_package = 'latest'
  } else {
    $ensure_package = $ensure_real
  }

  package { 'nss_ldap':
    ensure  => $ensure_package,
    name    => $nss::params::nss_ldap_package
  }

  Nss::Directive {
    require => Package['nss_ldap'],
    service => 'ldap'
  }

  nss::directive { 'passwd_ldap':
    ensure    => $ensure_directive,
    database  => 'passwd'
  }

  nss::directive { 'group_ldap':
    ensure    => $ensure_directive,
    database  => 'group'
  }

  nss::directive { 'shadow_ldap':
    ensure    => $ensure_directive,
    database  => 'shadow'
  }

}
