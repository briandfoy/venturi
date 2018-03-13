class Venturi::Path {
	has Str $!path;

	proto method new (|) {*}
	multi method new ( Any:D $path, *%_ () --> Venturi::Path:D ) {
		my $str = $path.Str;
		$str = "/$str" unless $str ~~ /^ '/' /;
		self.bless: :path($str);
		}
	submethod BUILD ( :$!path ) { }

	multi method path ( *%_ () ) { $!path }
	multi method path (
		Any:D $new-path,
		*%_ ()
		--> Str:D
		) {
		my $old-path = $!path;
		$!path = $new-path.Str;
		$old-path;
		}

	method delete-path ( *%_ () --> Str ) {
		my $old-path = $!path;
		$!path = Str;
		$old-path;
		}

	method Str  ( *%_ () --> Str:D ) { $!path }
	method gist ( *%_ () --> Str:D ) { self.Str   }
	}
