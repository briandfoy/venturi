use Test;

constant package-name = 'Venturi::Path';
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
	my $start-path  = '/dir1/dir2/file.txt';
	my $new-path    = '/dir1/dir3/index.shtml';

	my $f = $class.new: $start-path;
	isa-ok $f, $class;
	isa-ok $f.path, Str;
	ok $f.path.defined, '.path is defined';
	is $f.path, $start-path, '.path returns the same thing it was given';

	is $f.path( $new-path ), $start-path, '.path(Str) returns the original path';
	is $f.path, $new-path, '.path returns the new path';
	}

subtest 'delete', {
	my $path = '/dir1/dir2/file.txt';

	my $f = $class.new: $path;
	isa-ok $f, $class;
	isa-ok $f.path, Str;
	is $f.path, $path, '.path returns the same thing';

	my $result = $f.delete-path;
	isa-ok $result, Str;
	ok $result.defined, '.delete-path returns the defined previous path';
	is $result, $path, '.delete-path returns the previous path';

	isa-ok $f.path, Str;
	ok ! $f.path.defined, 'Blank path returns undefined';
	}

done-testing();
