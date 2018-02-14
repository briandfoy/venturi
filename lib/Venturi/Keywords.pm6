class Venturi::Keywords {
	has %!keywords;

	method new ( *@keywords ) {
		my $obj = self.bless;
		$obj.add-keywords: @keywords;
		$obj;
		}

	submethod BUILD () { }

	method keywords ( --> List ) { %!keywords.keys.List }

	method add-keywords ( *@keywords ) {
		%!keywords{$_}++ for @keywords
		}
	method remove-keywords ( *@keywords ) {
		%!keywords{$_}:delete for @keywords
		}
	method clear-keywords () {
		%!keywords = %()
		}
	method elems () { %!keywords.keys.elems }
	}
