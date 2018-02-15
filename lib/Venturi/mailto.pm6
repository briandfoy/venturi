need Venturi;

class Venturi::mailto is Venturi {
	has $.user;
	has $.host;

	method scheme           { 'mailto' }
	method default-port     { state $p = Venturi::Port::Unix.new: 21; $p }
	method default-path     { '/' }

	proto method new (|) {*}
	multi method new ( *%args --> Venturi::mailto:D ) {
		self.bless: |%args;
		}
	submethod BUILD ( :$!user, :$!host ) {
		$!host     := Venturi::Host.new: $!host if $!host.defined;
		}

	method Str ( --> Str:D ) {
		join '', self.user, '@', self.host;
		}

	method gist ( --> Str:D ) { self.Str }
	}
