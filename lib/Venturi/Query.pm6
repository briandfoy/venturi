class Venturi::Query {
	my $default-separator := ';';
	has %!query;
	has $.separator is rw = $default-separator;

	method from-hash ( %args, *%_ () --> Venturi::Query ) {
		my $query = self.new;
		for %args.keys -> $key {
			next unless %args{$key} ~~ any( Numeric, Str, Array );
			for %args{$key} -> $value {
				$query.add( $key, ~$value );
				}
			}

		$query;
		}

	method default-separator { $default-separator }

	multi method clear ( *%_ () --> Bool:D ) { %!query = %(); True }
	multi method clear ( Str:D $param, *%_ () --> Bool:D ) {
		if self.param-exists( $param ) {
			%!query{$param} = '';
			return True;
			}
		else {
			return False;
			}
		}

	method add ( Str:D $param, $value, *%_ () --> Bool:D ) {
		%!query{$param} = [] unless self.param-exists: $param;
		%!query{$param}.push: |$value;
		True;
		}

	multi method remove ( Str:D $param, *%_ () ) { %!query{$param}:delete }
	multi method remove ( Str:D $param, Str:D $value, *%_ () ) {
		my @keep = %!query{$param}.grep: * eq $value;
		%!query{$param} = @keep;
		}

	method value-for ( Str:D $param, *%_ () ) {
		return %!query{$param} if self.param-exists: $param;
		fail "No key <$param> in query";
		}

	method param ( Str:D $key, *%_ () ) {
		if self.param-exists: $key { %!query{$key} }
		else { fail "No such parameter <$key>" }
		}

	method has-params     ( *%_ () --> Bool:D ) { %!query.elems ?? True !! False }
	method param-exists   ( Str:D $key, *%_ () --> Bool:D ) { %!query{$key}:exists }
	method elems          ( *%_ () --> Int:D ) { %!query.elems }
	method params         ( *%_ () ) { %!query.keys.sort }
	method params-encoded ( *%_ () ) { %!query.keys.sort.map: { encode($^a) } }
	method values         ( *%_ () ) { %!query.values }

	method replace ( Str:D $param, Str:D $value ) {
		%!query{$param} = $value
		}

	method Bool ( *%_ () --> Bool:D ) {
		self.elems ?? True !! False;
		}

	method Numeric ( *%_ () --> Failure:D ) {
		fail "Method Numeric doesn't work for { $?CLASS.^name }";
		}

	method www-form-urlencoded ( *%_ () --> Str:D ) { self.Str }

	multi method Str ( Any:U : --> Str:D ) { $?CLASS.^name }
	multi method Str ( Any:D : *%_ () --> Str:D ) {
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

	method gist ( *%_ () --> Str:D ) {
		my Str:D $string = "=========== {$?CLASS.^name} gist ===========\n";
		my $length = $string.chars;

		for %!query.keys -> $param {
			$string ~= "「$param」" ~ "\n";
			for %!query{$param}.List -> $value {
				$string ~= "\t「$value」\n";
				}
			}
		$string ~= [~]
			'-' x $length, "\n",
			"Encoded:\n",
			"\t「", self.www-form-urlencoded, "」\n",
			'=' x $length, "\n";

		$string;
		}

	method Hash ( *%_ () --> Hash:D ) {
		# the trick here is to sever all connections between the object
		# and the Hash I return. Besides that, if there's only 0 or 1
		# value for a param, we don't want that to be an array. I'm
		# mostly thinking about how this can support .json where web
		# APIs probably don't like array objects everywhere
		my %new-hash;
		for %!query.keys -> $param {
			if %!query{$param}.elems == 1 {
				%new-hash{$param} = %!query{$param}.[0].clone;
				}
			elsif %!query{$param}.elems > 1 {
				%new-hash{$param} = [];
				for %!query{$param}.values -> $v {
					%new-hash{$param}.push: $v.clone;
					}
				}
			elsif %!query{$param}.elems == 0 {
				%new-hash{$param} = ''
				}
			}

		%new-hash;
		}

	method json ( :$compact = False, *%_ () --> Str:D ) {
		my %hash = self.Hash;
		use JSON::Fast;
		do if $compact { to-json( %hash, :!pretty ) }
		   else { to-json( %hash ) }
		}

	sub encode-pair ( Str:D $k, Str:D $v, *%_ () --> Str ) {
		encode($k) ~ '=' ~ encode($v)
		}

	sub encode ( Str:D $s, *%_ () --> Str:D ) {
		my &code = {
			$0.Str.encode('utf8-c8').map( '%' ~ *.fmt: '%02x' ).join: ''
			};

		$s.subst:
			/ (<-[ A..Z a..z 0..9]>) /,
			&code,
			:g;
		}
	}
