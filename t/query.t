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

subtest 'one-key-one-value', {
	my $key   = 'Hamadryas';
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems keys values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $key, $value );

	is $q.elems,      1,   'Has one element';
	is $q.params.elems, 1,   'keys has one element';
	is $q.params.[0], $key,  'Key is correct';
	is $q.values.elems, 1, 'values has one element';
	isa-ok $q.values.[0], Array;
	is $q.values.[0].elems, 1, 'Value has one element';

	is ~$q, 'Hamadryas=perlicus', 'Query string is correct'
	}

subtest 'one-key-clear-all', {
	my $key   = 'Hamadryas';
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems keys values Str clear>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $key, $value );

	is $q.elems,      1,   'Has one element';
	is $q.params.elems, 1,   'keys has one element';
	is $q.params.[0], $key,  'Key is correct';
	is $q.values.elems, 1, 'values has one element';
	isa-ok $q.values.[0], Array;
	is $q.values.[0].elems, 1, 'Value has one element';

	is ~$q, 'Hamadryas=perlicus', 'Query string is correct';

	$q.clear;
	is $q.elems,      0,   'Has no elements after clear';
	is $q.params.elems, 0,   'keys has no elements after clear';
	}

subtest 'one-utf8-key-one-value', {
	my $key   = 'φ';
	my $value = 'phi';

	can-ok $class, $_ for <add elems keys values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $key, $value );

	is $q.elems,      1,   'Has one element';
	is $q.params.elems, 1,   'keys has one element';
	is $q.params.[0], $key,  'Key is correct';
	is $q.values.elems, 1, 'values has one element';
	isa-ok $q.values.[0], Array;
	is $q.values.[0].elems, 1, 'Value has one element';

	is ~$q, '%cf%86=phi', 'Query string is correct'
	}

subtest 'one-key-two-values', {
	my $key    = 'Hamadryas';
	my @values = <perlicus sixus>;

	can-ok $class, $_ for <add elems keys values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $key, $_ ) for @values;

	is $q.elems,      1,   'Has one element';
	is $q.params.elems, 1,   'keys has one element';
	is $q.params.[0], $key,  'Key is correct';
	is $q.values.elems, 1, 'values has one element';
	isa-ok $q.values.[0], Array;
	is $q.values.[0].elems, 2, 'Value has two elements';

	is ~$q, 'Hamadryas=perlicus;Hamadryas=sixus', 'Query string is correct'
	}

subtest 'two-keys-one-value', {
	my @keys  = <Hamadryas Juonia>.sort;
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems keys values Str>;

	my $q = $class.new;
	isa-ok $q, $class;
	ok $q.DEFINITE, "It's an object";

	$q.add( $_, $value ) for @keys;

	is $q.elems,      2,   'Has two elements';
	is $q.params.elems, 2,   'keys has two elements';
	is $q.params.[0], @keys.[0],  'Key 0 is correct';
	is $q.params.[1], @keys.[1],  'Key 1 is correct';
	is $q.values.elems, 2, 'values has two elements';
	isa-ok $q.values.[$_], Array for ^$q.values.elems;
	is $q.values.[$_].elems, 1, 'Value has 1 element' for ^$q.values.elems;

	is ~$q, 'Hamadryas=perlicus;Juonia=perlicus', 'Query string is correct'
	}

subtest 'two-keys-remove-one', {
	my @keys  = <Hamadryas Juonia>.sort;
	my $value = 'perlicus';

	can-ok $class, $_ for <add elems keys values Str remove>;

	my $q = $class.new;
	isa-ok $q, $class;
	$q.add( $_, $value ) for @keys;

	is $q.elems,      2,   'Has two elements';
	is $q.params.elems, 2,   'keys has two elements';
	is $q.params.[0], @keys.[0],  'Key 0 is correct';
	is $q.params.[1], @keys.[1],  'Key 1 is correct';

	$q.remove( @keys.[1] );

	is $q.elems,      1,   'Has one element';
	is $q.params.elems, 1,   'keys has one element';
	is $q.params.[0], @keys.[0],  'Key 0 is correct';
	}

subtest 'from-hash', {
	can-ok $class, $_ for <from-hash keys>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia' => 'sixus',
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;

	is $q.params.elems, 2, 'Has the right number of keys';
	}

subtest 'from-hash-with-array', {
	can-ok $class, $_ for <from-hash>;

	my %hash = %(
		'Hamadryas' => 'perlicus',
		'Juonia'    => [ <foo bar baz> ],
		);

	my $q = $class.from-hash( %hash );
	isa-ok $q, $class;

	is $q.params.elems, 2, 'Has the right number of keys';
	ok $q.DEFINITE, "It's an object";

	ok $q.DEFINITE, "It's an object";

	ok $q.DEFINITE, "It's an object";

	}

done-testing();
	ok $q.DEFINITE, "It's an object";
	ok $q.DEFINITE, "It's an object";
	ok $q.DEFINITE, "It's an object";
