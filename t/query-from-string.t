use Test;
use lib <t/lib>;
use TestUtil;

constant package-name = 'Venturi::Query';
use-ok package-name or bail-out "{package-name} did not compile";
use ::(package-name);
my $class = ::(package-name);
my $method = 'from-string';

subtest 'can call with string argument', {
	my $capture = \($class, 'url-string');
	can-ok $class, $method;
	method-candidate-capture-ok $class, 'from-string', $capture;
	}

subtest 'can call with separator', {
	my $capture = \($class, 'url-string', :separator(';') );
	can-ok $class, $method;
	method-candidate-capture-ok $class, 'from-string', $capture;
	}

subtest 'simple query with &', {
	my $string = 'keya=valuea&keyb=valueb';
	my $q = $class.from-string: $string;
	isa-ok $q, $class;
	object-ok $q;

	todo "Have not figured out round trips yet";
	is ~$q,             $string,  'Round trip works out';
	is $q.separator,    '&',      'Separator is correct';

	is $q.elems,         2,       'Has two elements';
	is $q.params.elems,  2,       'params has two elements';
	is $q.params.[0],   'keya',   'Key A is correct';
	is $q.params.[1],   'keyb',   'Key B is correct';
	is $q.value-for($q.params.[0]),   'valuea', 'Value A is correct';
	is $q.value-for($q.params.[1]),   'valueb', 'Value B is correct';
	}

subtest 'simple query with ;', {
	my $string = 'keya=valuea;keyb=valueb';
	my $q = $class.from-string: $string, :separator(';');
	isa-ok $q, $class;
	object-ok $q;

	todo "Have not figured out round trips yet";
	is ~$q,             $string,  'Round trip works out';
	is $q.separator,    ';',      'Separator is correct';

	is $q.elems,         2,       'Has two elements';
	is $q.params.elems,  2,       'params has two elements';
	is $q.params.[0],   'keya',   'Key A is correct';
	is $q.params.[1],   'keyb',   'Key B is correct';
	is $q.value-for($q.params.[0]),   'valuea', 'Value A is correct';
	is $q.value-for($q.params.[1]),   'valueb', 'Value B is correct';
	}

subtest 'guess separator', {
	my $capture = \($class, 'url-string' );
	can-ok $class, 'guess-separator';
	method-candidate-capture-ok $class, 'guess-separator', $capture;

	subtest 'ampersand', {
		my $separator = $class.guess-separator: 'keya=valuea&keyb=valueb';
		isa-ok $separator, Str;
		object-ok $separator;
		is $separator, '&', 'Separator is &';
		}

	subtest 'semicolon', {
		my $separator = $class.guess-separator: 'keya=valuea;keyb=valueb';
		isa-ok $separator, Str;
		object-ok $separator;
		is $separator, ';', 'Separator is ;';
		}

	subtest 'no separator', {
		my $separator = $class.guess-separator: 'keya=valuea';
		isa-ok $separator, Str;
		type-object-ok $separator;
		is $separator, Str, 'No separator for single pair';
		}
	}

subtest ':guess-separator with ;', {
	my $string = 'keya=valuea;keyb=valueb';
	my $q = $class.from-string: $string, :guess-separator;
	isa-ok $q, $class;
	object-ok $q;

	is $q.separator, ';', 'Separator is correct';
	}

subtest 'unescaped snowman', {
	my $string = 'q=♥☃';
	my $q = $class.from-string: $string;
	isa-ok $q, $class;
	object-ok $q;

	is $q.elems,         1,         'Has two elements';
	is $q.params.elems,  1,         'params has two elements';
	is $q.params.[0],   'q',        'q param  is correct';
	is $q.value-for($q.params.[0]), '♥☃', 'Value is correct';

	is $q.separator, $q.default-separator, 'Separator is correct';
	}

subtest 'escaped snowman', {
	my $string = 'q=%E2%99%A5%E2%98%83';
	my $q = $class.from-string: $string;
	isa-ok $q, $class;
	object-ok $q;

	is $q.elems,         1,         'Has two elements';
	is $q.params.elems,  1,         'params has two elements';
	is $q.params.[0],   'q',        'q param  is correct';
	is $q.value-for($q.params.[0]), '♥☃', 'Value is correct';

	is $q.separator, $q.default-separator, 'Separator is correct';
	}

done-testing();
