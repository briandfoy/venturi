use Test;

my @classes = <
	Venturi::Host
	Venturi::Port
	Venturi::Port::Unix
	Venturi::Path
	Venturi::Query
	Venturi::Fragment
	Venturi::Keywords
	Venturi
	Venturi::http
	Venturi::https
	Venturi::ftp
	Venturi::mailto
	Venturi::Schemes
	>;

use-ok $_ or bail-out "$_ did not compile" for @classes;

done-testing();
