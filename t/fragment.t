use Test;

constant package-name = 'Venturi::Fragment';
use-ok package-name or bail-out "{package-name} did not compile";\
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
	my $start-fragment  = 'Hamadryas';
	my $new-fragment    = 'Willow';

	my $f = $class.new: $start-fragment;
	isa-ok $f, $class;
	isa-ok $f.fragment, Str;
	ok $f.fragment.defined, '.fragment is defined';
	is $f.fragment, $start-fragment, '.fragment returns the same thing it was given';

	is $f.fragment( $new-fragment ), $start-fragment, '.fragment(Str) returns the original fragment';
	is $f.fragment, $new-fragment, '.fragment returns the new fragment';
	}

subtest 'delete', {
	my $fragment = 'Hamadryas';

	my $f = $class.new: $fragment;
	isa-ok $f, $class;
	isa-ok $f.fragment, Str;
	ok $f.fragment.defined;
	is $f.fragment, $fragment, '.fragment returns the same thing';

	my $result = $f.delete-fragment;
	isa-ok $result, Str;
	ok $result.defined, '.delete-fragment returns the defined previous fragment';
	is $result, $fragment, '.delete-fragment returns the previous fragment';

	isa-ok $f.fragment, Str;
	ok ! $f.fragment.defined;
	}

done-testing();
