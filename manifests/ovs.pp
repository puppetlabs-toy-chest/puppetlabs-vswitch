class vswitch::ovs(
  $package_ensure = 'present'
) {

  include 'vswitch::params'

  case $::osfamily {
    'Debian': {
      service {'openvswitch':
        ensure      => true,
        enable      => true,
        name        => $::vswitch::params::ovs_service_name,
        hasstatus   => false, # the supplied command returns true even if it's not running
        # Not perfect - should spot if either service is not running - but it'll do
        status      => "/etc/init.d/openvswitch-switch status | fgrep 'is running'",
      }
    }
    'Redhat': {
      service {'openvswitch':
        ensure      => true,
        enable      => true,
        name        => $::vswitch::params::ovs_service_name,
      }
    }
  }

  package { $::vswitch::params::ovs_package_name:
    ensure  => $package_ensure,
    before  => Service['openvswitch'],
  }

  Service['openvswitch'] -> Vs_port<||>
  Service['openvswitch'] -> Vs_bridge<||>
}
