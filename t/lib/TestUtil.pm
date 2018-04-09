unit module TestUtils:ver<0.0.1>:auth<github:briandfoy>;

use Test;

sub object-ok ( $object, $label = 'Is an object' )
	is export(:DEFAULT) {
	$object.DEFINITE ?? pass( $label ) !! flunk( $label );
	}

sub type-object-ok ( $object, $label = 'Is a type object' )
	is export(:DEFAULT) {
	! $object.DEFINITE ?? pass( $label ) !! flunk( $label );
	}

sub method-invocant-type-ok ( ) {

	}

sub method-arity-type-ok ( ) {

	}

sub method-candidate-capture-ok ( $class, Str:D $method-name, Capture $c )
	is export(:DEFAULT) {
	subtest "$method-name: {$c.gist}", {
		can-ok( $class, $method-name );

		my @candidates = $class
			.can( $method-name )
			.flatmap( *.candidates )
			.grep( *.cando: $c )
			.unique
			.grep( {.signature.params.[0].type ~~ $class} )
			;

		ok @candidates.elems > 0, "There's a {$class.^name} candidate for {$c.gist}";
		}

	}

=begin finish

class Foo {
	multi method new ( Str:D $s, *%_ () ) { 1 }
	multi method new ( Int $n ) { 1 }
	}

my $capture = \(Foo, 5);
for Foo.can( 'new' )
	.flatmap( *.candidates )
	.grep( *.cando: $capture )
	-> $candidate {
    put join "\t",
        $candidate.package.^name,
        $candidate.name,
        $candidate.signature.perl;
    }

=begin finish

Mu	new	:(Mu $: *%attrinit)
Mu	new	:(Mu $: $, *@, *%_)
Foo	new	:(Foo $: Str:D $s, *%_)
Foo	new	:(Foo $: Int:D $n, *%_)
Mu	new	:(Mu $: *%attrinit)
Mu	new	:(Mu $: $, *@, *%_)


