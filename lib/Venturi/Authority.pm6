need Venturi::Host;
need Venturi::Port;

class Venturi::Authority {
	has Venturi::Host $!host;
	has Venturi::Port $!port;

	multi method new ( Venturi::Host:D :$host, Venturi::Port:D :$port ) {
		put "new with Host and Port";
		self.bless: :$host, :$port
		}
	multi method new ( Venturi::Host:D :$host, Int:D  :$int  ) {
		put "new with Host and Int";
		my $port = Venturi::Port::Unix.new: $int;
		self.bless: :$host, :$port
		}
	multi method new ( Str:D  :$str, Venturi::Port:D :$port ) {
		put "new with Str and Port";
		my $host = Venturi::Host.new: $str;
		self.bless: :$host, :$port
		}
	multi method new ( Str:D  :$str, Int:D :$int   ) {
		put "new with Str and Int";
		my $host = Venturi::Host.new: $str;
		my $port = Venturi::Port::Unix.new: $int;
		self.bless: :$host, :$port
		}

	submethod BUILD ( :$!host, :$!port ) { }

	multi method host (                       --> Venturi::Host:D ) { $!host }
	multi method host ( Venturi::Host:D $host --> Venturi::Host:D ) { $!host = $host }
	multi method host ( Str:D  $host          --> Venturi::Host:D ) { $!host = Venturi::Host.new: $host }

	multi method port (                       --> Venturi::Port:D ) { $!port }
	multi method port ( Venturi::Port:D $port --> Venturi::Port:D ) { $!port = $port }
	multi method port ( Int:D  $port          --> Venturi::Port:D ) { $!port = Venturi::Port::Unix.new: $port }

	method Str (  --> Str:D ) { join ':', $!host, $!port }
	method gist ( --> Str:D ) { self.Str }
	}
