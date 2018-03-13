#!/Applications/Rakudo/bin/perl6

use lib $*PROGRAM.parent.parent.child( 'lib' );
use Venturi;
use Test;

my %form = %(
	dog => 'Fido',
	cat => 'Sylvester',
	bird => 'Woody',
	);

my $url = Venturi.new:
	:scheme('http'),
	:host('www.example.com'),
	:port(8080),
	:form-hash(%form)
	;

ok $url.scheme, 'http';
ok $url.host, 'www.example.com';
ok $url.port, 8080;
isa-ok $url.query, Venturi::Query;
is $url.query.param( 'dog' ), 'Fido';

say $url.Str;
