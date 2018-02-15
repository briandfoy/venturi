need Venturi;
need Venturi::Port::Unix;

class Venturi::ftp is Venturi {
	has $.host;
	has $.port;
	has $.path;

	method scheme           { 'ftp' }
	method default-port     { state $p = Venturi::Port::Unix.new: 21; $p }
	method default-path     { state $p = Venturi::Path.new: '/'; $p }

	proto method new (|) {*}
	multi method new ( *%args --> Venturi::ftp:D ) {
		self.bless: |%args;
		}
	submethod BUILD ( :$!host, :$!port ) {
		$!host := Venturi::Host.new: $!host if $!host.defined;
		$!port := $!port.defined ?? Venturi::Port::Unix.new( $!port ) !! self.default-port;
		$!path := $!path.defined ?? Venturi::Path.new( $!path ) !! self.default-path;
		}

	method Str (  --> Str:D ) {
		join '',
			self.scheme,
			'://',
			( self.host // '' ),
			( (self.port // -1) == self.default-port ?? '' !! ":{self.port}" ),
			( self.path.defined ?? self.path !! self.default-path ),
		}
	method gist ( --> Str:D ) { self.Str }
	}
