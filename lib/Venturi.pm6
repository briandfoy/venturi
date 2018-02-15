#!/Applications/Rakudo/bin/perl6
need Venturi::Authority;
need Venturi::Path;
need Venturi::Query;
need Venturi::Fragment;
need Venturi::Keywords;

class Venturi {
	has Venturi::Authority $!authority;
	has Venturi::Path      $!path;
	has Venturi::Query     $!query;
	has Venturi::Fragment  $!fragment;
	has Venturi::Keywords  $!keywords = Venturi::Keywords.new;

	method new (
		Venturi::Authority:_ :$authority is copy,
			:$scheme    is copy where * ~~ Str:D   | Any,
			:$host      is copy where * ~~ Str:D   | Venturi::Host:D   | Any,
			:$port      is copy where * ~~ Int:D   | Venturi::Port:D   | Any,
			:$path      is copy where * ~~ Str:D   | Venturi::Path:D   | Any,
			:$query     is copy where * ~~ Hash:D  | Any,
			:$keywords  is copy where * ~~ Array:D | List:D | Any,
			:$fragment  is copy where * ~~ Str:D   | Venturi::Fragment:D | Any,
		--> Venturi
		) {

		$scheme   = Venturi::Scheme   if $scheme   ~~ Any;
		$path     = Venturi::Path     if $path     ~~ Any;
		$query    = Venturi::Query    if $query    ~~ Any;
		$keywords = Venturi::Keywords if $keywords ~~ Any;
		$fragment = Venturi::Fragment if $fragment ~~ Any;

			put "1. Host is {$host.^name} | Port is {$port.^name}";

		$host = Venturi::Host.new:       $host if $host ~~ Str;
		$port = Venturi::Port::Unix.new: $port if $port ~~ Int;

		$path     = Venturi::Path.new:     $path     if $path     ~~ Str;
		$fragment = Venturi::Fragment.new: $fragment if $fragment ~~ Str;

		if $authority {
			if ( $port or $host ) and $authority {
				warn "Authority specified, ignoring host and port";
				}
			}
		elsif $host and $port {
			put "2. Host is {$host.^name} | Port is {$port.^name}";
			$authority = Venturi::Authority.new: :$host, :$port;
			}


		self.bless:
			:$scheme, :$authority, :$path,
			:$query, :$keywords, :$fragment
			;
		}

	submethod BUILD (
		#:$!scheme,
		:$!authority,
		:$!path,
		:$!query,
		:$!keywords,
		:$!fragment
		) { }

	method Str (  --> Str:D ) { 'Some URL string' }
	method gist ( --> Str:D ) { self.Str }
	}
