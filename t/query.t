use Test;

constant package-name = 'Venturi::Query';
use-ok package-name or bail-out "{package-name} did not compile";\
use ::(package-name);
my $class = ::(package-name);

use-ok 'Venturi::Query';

subtest 'nothing', {
	can-ok $class, 'new';

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";
	}

subtest 'one-param-one-value', {
	my $param   = 'Hamadryas';
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems params values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $param, $value );

	is $q.elems,            1,       'Has one element';
	is $q.params.elems,     1,       'params has one element';
	is $q.params.[0],       $param,  'param is correct';
	is $q.values.elems,     1,       'values has one element';
	isa-ok $q.values.[0],   Array;
	is $q.values.[0].elems, 1,       'Value has one element';

	is ~$q, 'Hamadryas=perlicus', 'Query string is correct'
	}

subtest 'one-param-clear-all', {
	my $param   = 'Hamadryas';
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems params values Str clear>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $param, $value );

	is $q.elems,            1,       'Has one element';
	is $q.params.elems,     1,       'params has one element';
	is $q.params.[0],       $param,  'param is correct';
	is $q.values.elems,     1,       'values has one element';
	isa-ok $q.values.[0],   Array;
	is $q.values.[0].elems, 1,       'Value has one element';

	is ~$q, 'Hamadryas=perlicus', 'Query string is correct';

	$q.clear;
	is $q.elems,      0,   'Has no elements after clear';
	is $q.params.elems, 0, 'params has no elements after clear';
	}

subtest 'one-utf8-param-one-value', {
	my $param   = 'φ';
	my $value = 'phi';

	can-ok $class, $_ for <add elems params values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $param, $value );

	is $q.elems,            1,       'Has one element';
	is $q.params.elems,     1,       'params has one element';
	is $q.params.[0],       $param,  'param is correct';
	is $q.values.elems,     1,       'values has one element';
	isa-ok $q.values.[0],   Array;
	is $q.values.[0].elems, 1,       'Value has one element';

	is ~$q, '%cf%86=phi', 'Query string is correct'
	}

subtest 'one-param-two-values', {
	my $param    = 'Hamadryas';
	my @values = <perlicus sixus>;

	can-ok $class, $_ for <add elems params values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $param, $_ ) for @values;

	is     $q.elems,            1,      'Has one element';
	is     $q.params.elems,     1,      'params has one element';
	is     $q.params.[0],       $param, 'param is correct';
	is     $q.values.elems,     1,      'values has one element';
	isa-ok $q.values.[0],       Array;
	is     $q.values.[0].elems, 2,      'Value has two elements';

	is ~$q, 'Hamadryas=perlicus&Hamadryas=sixus', 'Query string is correct'
	}

subtest 'two-params-one-value', {
	my @params  = <Hamadryas Juonia>.sort;
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems params values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $_, $value ) for @params;

	is $q.elems,             2,            'Has two elements';
	is $q.params.elems,      2,            'params has two elements';
	is $q.params.[0],        @params.[0],  'param 0 is correct';
	is $q.params.[1],        @params.[1],  'param 1 is correct';
	is $q.values.elems,      2,            'values has two elements';

	isa-ok $q.values.[$_],   Array for ^$q.values.elems;
	is $q.values.[$_].elems, 1, 'Value has 1 element' for ^$q.values.elems;

	is ~$q, 'Hamadryas=perlicus&Juonia=perlicus', 'Query string is correct'
	}

subtest 'change-separator', {
	my @params  = <Hamadryas Juonia>.sort;
	my $value = 'perlicus';

	can-ok $class, $_ for <add separator Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $_, $value ) for @params;

	is ~$q, 'Hamadryas=perlicus&Juonia=perlicus',
		'Query string with default separator is correct';

	$q.separator = ';';
	is ~$q, 'Hamadryas=perlicus;Juonia=perlicus',
		'Query string with chosen separator is correct';

	$q.separator = $q.default-separator;
	is ~$q, 'Hamadryas=perlicus&Juonia=perlicus',
		'Query string with restored default separator is correct';
	}

subtest 'new-with-separator', {
	my @params  = <Hamadryas Juonia>.sort;
	my $value = 'perlicus';

	can-ok $class, $_ for <new add Str>;

	my $q = $class.new: :separator('#');
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $_, $value ) for @params;

	is ~$q, 'Hamadryas=perlicus#Juonia=perlicus',
		'Query string with constructor-specified separator is correct';
	}

subtest 'two-params-remove-one', {
	my @params  = <Hamadryas Juonia>.sort;
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems params values Str remove>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $_, $value ) for @params;

	is $q.elems,      2,   'Has two elements';
	is $q.params.elems, 2,   'params has two elements';
	is $q.params.[0], @params.[0],  'param 0 is correct';
	is $q.params.[1], @params.[1],  'param 1 is correct';

	$q.remove( @params.[1] );

	is $q.elems,      1,   'Has one element';
	is $q.params.elems, 1,   'params has one element';
	is $q.params.[0], @params.[0],  'param 0 is correct';
	}

subtest 'from-hash', {
	can-ok $class, $_ for <from-hash params>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia' => 'sixus',
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	is $q.params.elems, 2, 'Has the right number of params';
	}

subtest 'from-hash-with-array', {
	can-ok $class, $_ for <from-hash>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	is $q.params.elems, 2, 'Has the right number of params';
	}

subtest 'Str', {
	can-ok $class, $_ for <from-hash Str>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";
	}

subtest 'www-form-encoded', {
	can-ok $class, $_ for <from-hash www-form-urlencoded Str>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	is $q.Str, $q.www-form-urlencoded, 'Str is the same as www-form-urlencoded';
	}

subtest 'gist', {
	can-ok $class, $_ for <from-hash gist>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";
	}

subtest 'Hash', {
	can-ok $class, $_ for <from-hash Hash>;

	my %params = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %params );
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	my $hash = $q.Hash;
	isa-ok $hash, 'Hash', 'Assigning to scalar returns a hash';

	my %hash = $q.Hash;
	isa-ok %hash, 'Hash', 'Assigning to a hash returns a hash';
	}

subtest 'json', {
	can-ok $class, $_ for <from-hash json>;

	my %params = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %params );
	isa-ok $q, $class;

	my %hash = $q.Hash;
	isa-ok %hash, 'Hash', '.Hash returns a hash';

	ok $q.DEFINITE, "It's an object";
	}

done-testing();
