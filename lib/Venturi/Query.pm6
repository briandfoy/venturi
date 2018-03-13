class Venturi::Query {
	my $default-separator := ';';
	has %!query;
	has $.separator is rw = $default-separator;

	method from-hash ( %args --> Venturi::Query ) {
		my $query = self.new;
		for %args.keys -> $key {
			next unless %args{$key} ~~ any( Str, Array );
			for %args{$key} -> $value {
				$query.add( $key, $value );
				}
			}

		$query;
		}

	multi method clear ( --> Bool:D ) { %!query = %(); True }

	multi method clear ( Str:D $param --> Bool:D ) {
	method default-separator { $default-separator }
		if self.param-exists( $param ) {
			%!query{$param} = '';
			return True;
			}
		else {
			return False;
			}
		}

	method add ( Str:D $param, $value --> Bool:D ) {
		%!query{$param} = [] unless self.param-exists: $param;
		%!query{$param}.push: |$value;
		True;
		}

	multi method remove ( Str:D $param ) { %!query{$param}:delete }
	multi method remove ( Str:D $param, Str:D $value ) {
		my @keep = %!query{$param}.grep: * eq $value;
		%!query{$param} = @keep;
		}

	method value-for    ( Str:D $param ) {
		return %!query{$param} if self.param-exists: $param;
		fail "No key <$param> in query";
		}

	method param-exists   ( Str:D $key --> Bool:D ) { %!query{$key}:exists }
	method elems          ( --> Int:D ) { %!query.elems }
	method params         () { %!query.keys.sort }
	method params-encoded () { %!query.keys.sort.map: { encode($^a) } }
	method values         () { %!query.values }

	method replace ( Str:D $param, Str:D $value ) {
		%!query{$param} = $value
		}

	method Str ( --> Str:D ) {
		%!query
			.pairs
			.map( -> $p {
				slip do if $p.value.elems == 0 {
					slip ( $p.key, '' )
					}
				else {
					$p.value.map( { slip ( $p.key, $_ ) } )
					}
				} )
			.rotor(2)
			.map( { encode-pair( |$^a ) } )
			.join( $!separator )
		}

	sub encode-pair ( $k, $v --> Str ) {
		encode($k) ~ '=' ~ encode($v)
		}

	sub encode ( $s --> Str ) {
		my &code = {
			$0.Str.encode('utf8-c8').map( '%' ~ *.fmt: '%02x' ).join: ''
			};

		$s.subst:
			/ (<-[ A..Z a..z 0..9]>) /,
			&code,
			:g;
		}
	}
