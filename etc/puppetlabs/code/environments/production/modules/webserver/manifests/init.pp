class webserver {
        if $::osfamily == 'RedHat' {
                package { 'httpd' :
                        ensure => present

		service { 'httpd' :
			ensure => running,
			enable => true,
			hasrestart => true,
			}
                }
        } elsif $::osfamily == 'Debian' {
                package { 'apache2' :
                        ensure => present
                }

		service { 'apache2' :
			ensure => running,
			enable => true,
			hasrestart => true,
			}
        } else {
                fail "This is not a valid distro."
        }

}
