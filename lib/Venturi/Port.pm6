class Venturi::Port {
	has $!port;

	method minimum-port            { !!! }
	method maximum-port            { !!! }
	method highest-privileged-port { !!! }

	proto method new (|) {*}

	multi method new (
		Int:D $port where self.minimum-port <= * <= self.maximum-port,
		*%_ ()
		--> Venturi::Port:D
		) { self.bless: :$port }
	multi method new (
		Str:D $port where { val($^a) ~~ Int:D },
		*%_ ()
		--> Venturi::Port:D
		) { self.new: $port.Int }

    submethod BUILD( :$!port ) { }

	method is-privileged     ( *%_ () --> Bool:D ) { $!port <= $.highest-privileged-port }
	method is-not-privileged ( *%_ () --> Bool:D ) { ! self.is-privileged }

	multi method port ( *%_ () --> Int:D ) { $!port }
	multi method port (
		Int:D $new-port where self.minimum-port <= * <= self.maximum-port,
		*%_ ()
		--> Int:D
		) {
		my $old-port = $!port; $!port := $new-port; $old-port
		}
	multi method port (
		Str:D $new-port where { val($^a) ~~ Int:D },
		*%_ ()
		--> Int:D
		) {
		self.port: $new-port.Int
		}

	method port-range ( *%_ () --> Range:D ) { self.minimum-port .. self.maximum-port }

	method Numeric ( *%_ () --> Int:D ) { $!port   }
	method Str     ( *%_ () --> Str:D ) { ~ $!port }
	method gist    ( *%_ () --> Str:D ) { self.Str }
	}
