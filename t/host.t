use Test;

constant package-name = 'Venturi::Host';
use-ok package-name or bail-out "{package-name} did not compile";
use ::(package-name);
my $class = ::(package-name);

subtest 'new', {
	subtest 'good-argument', {
		my $u1 = $class.new: 'String';
		isa-ok $u1, $class;
		my $u2 = $class.new: 80;
		isa-ok $u2, $class;
		}

	subtest 'bad-argument', {
		try { $ = $class.new };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for no arguments';

		try { $ = $class.new: 80, 90 };
		isa-ok $!, X::Multi::NoMatch, 'No candidate for multiple arguments';
		}
	}

subtest 'change', {
	my $start-host  = 'Hamadryas.butterflies.com';
	my $new-host    = 'Willow.trees.org';

	my $f = $class.new: $start-host;
	isa-ok $f, $class;
	isa-ok $f.host, Str;
	ok $f.host.defined, '.host is defined';
	is $f.host, $start-host, '.host returns the same thing it was given';

	is $f.host( $new-host ), $start-host, '.host(Str) returns the original host';
	is $f.host, $new-host, '.host returns the new host';
	}

subtest 'delete', {
	my $host = 'Hamadryas';

	my $f = $class.new: $host;
	isa-ok $f, $class;
	isa-ok $f.host, Str;
	is $f.host, $host, '.host returns the same thing';

	my $result = $f.delete-host;
	isa-ok $result, Str;
	ok $result.defined, '.delete-host returns the defined previous host';
	is $result, $host, '.delete-host returns the previous host';

	isa-ok $f.host, Str;
	ok ! $f.host.defined, 'Blank host returns undefined';
	}

done-testing();
