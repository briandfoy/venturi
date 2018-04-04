use Test;

constant package-name = 'Venturi';
use-ok package-name or bail-out "{package-name} did not compile";\
use ::(package-name);
my $class = ::(package-name);

my $url     = 'http://www.example.org/';
my $non-url = 'Hamadryas perlicus'; # really just the path

subtest 'can', {
	can-ok $class, 'uri-pattern';
	can-ok $class, 'parse';
	}

subtest 'not instance methods', {
	my $obj = $class.new: :scheme('http');
	isa-ok $obj, $class;
	throws-like
		{ $obj.parse( $url ) },
		X::Parameter::InvalidConcreteness,
		;
	}

subtest 'class methods with bad args', {
	throws-like { $class.parse }, X::AdHoc;
	throws-like { $class.parse( 5 ) }, X::TypeCheck::Binding::Parameter;
	throws-like { $class.parse( Str ) }, X::Parameter::InvalidConcreteness;
	throws-like { $class.parse( $url, 5 ) }, X::AdHoc;
	}

subtest 'good URL arg', {
	my $match = $class.parse: $url;
	isa-ok $match, Match;
	ok $match.defined, 'Match object is defined';
	say $match;
	}

# huh, it always has the path
subtest 'non-URL args', {
	my $match = $class.parse: $non-url;
	isa-ok $match, Match;
	ok $match.defined, 'Match object is defined';
	}

subtest 'test the parts', {
	my $match = $class.parse: $url;
	isa-ok $match, Match;
	ok $match.defined, 'Match object is defined';
	is $match<scheme>, 'http', 'Gets the HTTP scheme';
	is $match<authority>, 'www.example.org', 'Gets the right domain';
	is $match<path>, '/', 'Gets the right path';
	}

done-testing();
