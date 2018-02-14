use Test;

constant package-name     = 'Venturi::Port';
constant sub-package-name = 'Venturi::Port::Unix';

use-ok package-name     or bail-out "{package-name} did not compile";
use-ok sub-package-name or bail-out "{sub-package-name} did not compile";

use ::(package-name);
use ::(sub-package-name);

my $class    = ::(package-name);
my $subclass = ::(sub-package-name);

subtest 'new', {
	subtest 'good-argument', {
		my $u1 = $subclass.new: 80;
		isa-ok $u1, $subclass;
		my $u2 = $subclass.new: '80';
		isa-ok $u2, $subclass;
		}

	subtest 'bad-argument', {
		try { $ = $subclass.new };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for no arguments';

		try { $ = $subclass.new: 80, 90 };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for multiple arguments';

		try { $ = $subclass.new: '80i' };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for non-integer numeric string argument';

		try { $ = $subclass.new: '1.5' };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for floating-point argument';

		try { $ = $subclass.new: 'Hello' };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for no-digit string arguments';
		}
	}

subtest 'port', {
	my $int = 80;
	my $u = $subclass.new: $int;
	isa-ok $u, $subclass;
	is $u.port, $int, '.port returns the same thing it was given';
	}

subtest 'change', {
	my $start-port      = 137;
	my $new-port        =  23;
	my $string-port     = '39';
	my $bad-string-port = 'Hello';

	my $u = $subclass.new: $start-port;
	isa-ok $u, $subclass;
	is $u.port, $start-port, '.port returns the same thing it was given';

	is $u.port( $new-port ), $start-port, '.port(Int) returns the original port';
	is $u.port, $new-port, '.port returns the new port';

	is $u.port( $string-port ), $new-port, '.port(Str) returns the original port';
	is $u.port, +$string-port, '.port returns the string port';

	try { $u.port( $bad-string-port ) }
	isa-ok $!, X::Multi::NoMatch;

	is $u.port, +$string-port, '.port returns the string port after failed call';
	}

subtest 'privileged', {
	my $privileged-port     = 1;
	my $non-privileged-port = 1059;

	ok   $subclass.new( $privileged-port ).is-privileged, "$privileged-port is privileged";
	ok ! $subclass.new( $non-privileged-port ).is-privileged, "$non-privileged-port is not privileged";
	}

subtest 'limits', {
	subtest 'base-class-is-stub', {
		try { $class.minimum-port };
		isa-ok $!, X::StubCode;

		try { $class.maximum-port };
		isa-ok $!, X::StubCode;

		try { $class.highest-privileged-port };
		isa-ok $!, X::StubCode;
		}

	subtest 'derived-class', {
		isa-ok $subclass.minimum-port, Int;
		ok $subclass.minimum-port.defined, 'minimum-port is defined';

		isa-ok $subclass.maximum-port, Int;
		ok $subclass.maximum-port.defined, 'maximum-port is defined';

		isa-ok $subclass.highest-privileged-port, Int;
		ok $subclass.highest-privileged-port.defined, 'highest-privileged-port is defined';

		ok $subclass.minimum-port < $subclass.maximum-port, 'Minimum is less than maximum';
		ok $subclass.minimum-port < $subclass.highest-privileged-port < $subclass.maximum-port,
			'Highest privileged port is in the middle';
		}
	}

subtest 'port-range', {
	subtest 'base-class', {
		try { $class.port-range };
		isa-ok $!, X::StubCode;
		}

	subtest 'derived-class', {
		my $range = $subclass.port-range;
		isa-ok $range, Range;
		is $range.min, $subclass.minimum-port, 'range minimum is right';
		is $range.max, $subclass.maximum-port, 'range maximum is right';
		}

	}

subtest 'stringify', {
	my $u = $subclass.new: 999;
	isa-ok $u, $subclass;

	isa-ok $u.Str, Str, '.Str returns a string';
	ok $u.Str.defined, '.Str returns a defined value';

	isa-ok $u.gist, Str, '.gist returns a string';
	ok $u.gist.defined, '.gist returns a defined value';
	}

done-testing();
