use Test;

constant package-name = 'Venturi::http';
use-ok package-name or bail-out "{package-name} did not compile";\
use ::(package-name);
my $class = ::(package-name);

use Venturi::Port::Unix;

subtest 'defaults', {
	my $u = $class.new;
	isa-ok $u, $class;
	can-ok $u, 'default-port';
	ok $u.default-port.defined, 'Default port is defined';
	isa-ok $u.default-port, Venturi::Port;
	}

done-testing;
