class Venturi::Host {
	has Str $!host;

	proto method new (|) {*}
	multi method new ( Any:D $host, *%_ () --> Venturi::Host:D ) {
		self.bless: :host($host.Str);
		}
	submethod BUILD ( :$!host ) { }

	multi method host ( *%_ () ) { $!host }
	multi method host (
		Any:D $new-host,
		*%_ ()
		--> Str:D
		) {
		my $old-host = $!host;
		$!host = $new-host.Str;
		$old-host;
		}

	method delete-host ( *%_ () --> Str ) {
		my $old-host = $!host;
		$!host = Str;
		$old-host;
		}

	method Str  ( *%_ () --> Str:D ) { $!host }
	method gist ( *%_ () --> Str:D ) { self.Str   }

	method host-is-ip-address () { !!! }
	method host-is-name ()       { !!! }
	}
