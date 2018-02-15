use Test;

constant package-name = 'Venturi::http';
use-ok package-name or bail-out "{package-name} did not compile";\
use ::(package-name);
my $class = ::(package-name);

use Venturi::Port::Unix;

my $scheme = package-name.subst: / .* '::' /, '';
note "scheme is $scheme";

subtest 'defaults', {
	my $u = $class.new;
	isa-ok $u, $class;
	can-ok $u, 'default-port';
	ok $u.default-port.defined, 'Default port is defined';
	isa-ok $u.default-port, Venturi::Port;
	}

subtest 'no-host', {
	my $url = Venturi.new: :scheme($scheme);
	isa-ok $url, $class;
	is $url.scheme, $scheme, "Scheme is $scheme";
	}

subtest 'host', {
	my $host = 'www.example.com';
	my $new-port = 8080;

	my $url = Venturi.new: :scheme($scheme), :host($host);

	isa-ok $url, $class;
	is $url.scheme, $scheme, "Scheme is $scheme";
	is $url.host, $host, 'Host is correct';
	is $url.Str, "$scheme://$host/", 'stringified URL is right';

	is $url.port, $url.default-port, 'Default port is the default';
	is $url.port( $new-port ), $url.default-port, 'Changing port returns previous report';
	is $url.port, $new-port, 'Changing port set new port';
	is $url.Str, "$scheme://$host:$new-port/", 'stringified URL is right';
	}

subtest 'host-port', {
	my $host = 'www.example.com';
	my $port = 137;

	my $url = Venturi.new: :scheme($scheme), :host($host), :port($port);

	isa-ok $url, $class;
	is $url.scheme, $scheme, "Scheme is $scheme";
	is $url.host, $host, 'Host is correct';
	is $url.port, $port, 'Port is correct';
	is $url.Str, "$scheme://$host:$port/", 'stringified URL with non-standard is right';

	is $url.port( $url.default-port ), $port, 'Changing port returns previous report';
	is $url.Str, "$scheme://$host/", 'stringified URL with standard port is right';

	}

done-testing;
