# == Class: nss::params
#
class nss::params {

  $valid_databases = [
    'aliases',
    'ethers',
    'group',
    'hosts',
    'netgroup',
    'networks',
    'passwd',
    'protocols',
    'publickey',
    'rpc',
    'services',
    'shadow'
  ]

  $config_file = '/etc/nsswitch.conf'
  $template = ''
  $source = ''
  $ensure = 'present'
  $autoupgrade = false

  case $::operatingsystem {
    'Ubuntu','Debian': {
      $nss_ldap_package = 'libnss-ldapd'
    }
    default: {
      fail ("Unsupported operatingsystem ${::operatingsystem}")
    }
  }

}
