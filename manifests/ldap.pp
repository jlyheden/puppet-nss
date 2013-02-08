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