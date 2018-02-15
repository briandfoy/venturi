need Venturi;
need Venturi::Port::Unix;

class Venturi::http is Venturi {
	has $.host;
	has $.port;
	has $.fragment;

	method scheme           { 'http' }
	method default-port     { state $p = Venturi::Port::Unix.new: 80; $p }
	method default-path     { '/' }
	method default-fragment { Any }

	proto method new (|) {*}
	multi method new ( *%args --> Venturi::http:D ) {
		self.bless: |%args;
		}
	submethod BUILD ( :$!host, :$!port, :$!fragment ) {
		$!host     := Venturi::Host.new: $!host if $!host.defined;
		$!port     := $!port.defined ?? Venturi::Port::Unix.new( $!port ) !! self.default-port;
		$!fragment := $!fragment.defined ?? Venturi::Fragment.new( $!fragment.Str ) !! self.default-fragment;
		}

	method Str (  --> Str:D ) {
		join '',
			self.scheme,
			'://',
			( self.host // '' ),
			( (self.port // -1) == self.default-port ?? '' !! ":{self.port}" ),
			( self.path.defined ?? self.path !! self.default-path ),
			( self.fragment.defined ?? "#{self.fragment}" !! '' ),
		}
	method gist ( --> Str:D ) { self.Str }
	}
