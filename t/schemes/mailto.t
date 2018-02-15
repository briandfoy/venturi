use Test;

constant package-name = 'Venturi::mailto';
use-ok package-name or bail-out "{package-name} did not compile";\
use ::(package-name);
my $class = ::(package-name);

my $scheme = package-name.subst: / .* '::' /, '';
note "scheme is $scheme";

subtest 'no-host', {
	my $url = Venturi.new: :scheme($scheme);
	isa-ok $url, $class;
	is $url.scheme, $scheme, "Scheme is $scheme";
	}

done-testing;
