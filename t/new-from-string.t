use Test;
use lib <t/lib>;
use TestUtil;

constant package-name = 'Venturi';
use-ok package-name or bail-out "{package-name} did not compile";
use ::(package-name);
my $class = ::(package-name);

my $capture = \($class, 'url-string');
can-ok $class, 'new';
method-candidate-capture-ok $class, 'new', $capture;

subtest 'https://www.example.com', {
	my $object = $class.new: 'https://www.example.com';
	isa-ok $object, $class;
	}
