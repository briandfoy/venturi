use Test;

constant package-name = 'Venturi';
use-ok package-name or bail-out "{package-name} did not compile";\
use ::(package-name);
my $class = ::(package-name);

use Venturi::Port::Unix;

subtest 'http', {
	my $u = $class.new: :scheme('http');
	isa-ok $u, 'Venturi::http';
	}

subtest 'https', {
	my $u = $class.new: :scheme('https');
	isa-ok $u, 'Venturi::https';
	}

subtest 'ftp', {
	my $u = $class.new: :scheme('ftp');
	isa-ok $u, 'Venturi::ftp';
	}

subtest 'mailto', {
	my $u = $class.new: :scheme('mailto');
	isa-ok $u, 'Venturi::mailto';
	}

done-testing();
