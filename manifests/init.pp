# Class: nss
#
# This module manages nss
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class nss ( $source = $nss::params::source,
            $template = $nss::params::template ) inherits nss::params {

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  file { $nss::params::config_file:
    ensure  => file,
    owner   => root,
    group   => root,
    content => $manage_file_content,
    source  => $manage_file_source
  }
}