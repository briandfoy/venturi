need Venturi;
need Venturi::Path;
need Venturi::Fragment;
need Venturi::Port::Unix;

class Venturi::http is Venturi {
	has $.host;
	has $!port;
	has $!path;
	has $!fragment;
	has %!query;

	method scheme           { 'http' }
	method default-port     { state $p = Venturi::Port::Unix.new: 80; $p }
	method default-path     { state $p = Venturi::Path.new: '/'; $p }
	method default-fragment { Any }

	proto method new (|) {*}
	multi method new ( *%args --> Venturi::http:D ) {
		self.bless: |%args;
		}
	submethod BUILD ( :$!host, :$!port, :$!path, :$!fragment ) {
		$!host     := Venturi::Host.new: $!host if $!host.defined;
		$!port     := $!port.defined ?? Venturi::Port::Unix.new( $!port ) !! self.default-port;
		$!path     := $!path.defined ?? Venturi::Path.new( $!path ) !! self.default-path;
		$!fragment := $!fragment.defined ?? Venturi::Fragment.new( $!fragment.Str ) !! self.default-fragment;
		}

	multi method port ( --> Venturi::Port::Unix:D ) { $!port }
	multi method port ( Any:D $new-port --> Venturi::Port::Unix:D ) {
		my $old-port = $!port;
		$!port := $new-port ~~ Venturi::Port::Unix
			?? $new-port !! Venturi::Port::Unix.new: $new-port;
		$old-port;
		}

	multi method path ( --> Venturi::Path:D ) { $!path }
	multi method path ( Any:D $new-path --> Venturi::Path:D ) {
		my $old-path = $!path;

		$!path := $new-path ~~ Venturi::Path
			?? $new-path !! Venturi::Path.new: $new-path;
		$old-path;
		}

	method Str ( --> Str:D ) {
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
