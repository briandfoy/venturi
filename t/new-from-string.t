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
	my $url = 'https://www.example.com';
	my $object = $class.new: $url;
	isa-ok $object, $class;
	isa-ok $object, ::(package-name)::https;
	is $object.scheme, 'https', "Scheme is https ($url)";
	}

subtest 'https://www.example.com', {
	my $url = 'http://www.example.com';
	my $object = $class.new: $url;
	isa-ok $object, $class;
	isa-ok $object, ::(package-name)::http;
	is $object.scheme, 'http', "Scheme is http ($url)";
	}

subtest 'ftp://www.example.com', {
	my $url = 'ftp://www.example.com';
	my $object = $class.new: $url;
	isa-ok $object, $class;
	isa-ok $object, ::(package-name)::ftp;
	is $object.scheme, 'ftp', "Scheme is ftp ($url)";
	}

subtest '/just/the/path', {
	my $url = '/just/the/path';
	my $object = $class.new: $url;
	isa-ok $object, $class;
	isa-ok $object, ::(package-name)::schemeless;
	is $object.scheme, Any, "Scheme is Any ($url)";
	}
