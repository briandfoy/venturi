need Venturi;

class Venturi::schemeless is Venturi {
	has $.path;

	method scheme           { Any }

	method Str (  --> Str:D ) { self.path }
	method gist ( --> Str:D ) { self.Str }
	}
