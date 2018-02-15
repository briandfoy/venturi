#!/Applications/Rakudo/bin/perl6

use lib </Users/brian/Desktop/URI.d/lib>;
need Venturi;

{
put 'http ', '-' x 50;
my $url = Venturi.new:
	:scheme('http'),
	:host('www.example.com'),
	:port(8080)
	;

put $url;
put "Fragment is {$url.fragment // '(no fragment)'}";
}

{
put 'http ', '-' x 50;
my $url = Venturi.new:
	:scheme('http'),
	:host('www.example.com'),
	:port(8080),
	:fragment('monkey'),
	;

put $url;
put "Fragment is {$url.fragment // '(no fragment)'}";
}

{
put 'https ', '-' x 50;
my $url = Venturi.new:
	:scheme('https'),
	:host('www.example.com'),
	;
put $url;
}

{
put 'ftp ', '-' x 50;
my $url = Venturi.new:
	:scheme('ftp'),
	:host('www.example.com'),
	;
put $url;
}
