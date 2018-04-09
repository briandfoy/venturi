use Test;
use lib <t/lib>;
use TestUtil;

constant package-name = 'Venturi::Query';
use-ok package-name or bail-out "{package-name} did not compile";
use ::(package-name);
my $class = ::(package-name);


my $capture = \($class, 'url-string');
can-ok $class, 'new';
method-candidate-capture-ok $class, 'from-string', $capture;


done-testing();
