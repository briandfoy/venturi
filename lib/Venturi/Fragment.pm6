class Venturi::Fragment {
	has Str $!fragment;

	proto method new (|) {*}
	multi method new ( Any:D $fragment, *%_ () --> Venturi::Fragment:D ) {
		self.bless: :fragment($fragment.Str);
		}
	submethod BUILD ( :$!fragment ) { }

	multi method fragment ( *%_ () ) { $!fragment }
	multi method fragment (
		Any:D $new-fragment,
		*%_ ()
		--> Str:D
		) {
		my $old-fragment = $!fragment;
		$!fragment = $new-fragment.Str;
		$old-fragment;
		}

	method delete-fragment ( *%_ () --> Str ) {
		my $old-fragment = $!fragment;
		$!fragment = Str;
		$old-fragment;
		}

	method Str  ( *%_ () --> Str:D ) { $!fragment }
	method gist ( *%_ () --> Str:D ) { self.Str   }
	}
