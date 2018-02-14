class Venturi::Query {
	has %!query;

	# Every entry needs to be a hash of hashes
	method new ( *%query ) {
		my $obj = self.bless;
		$obj;
		}

	submethod BUILD () { }
	}
