#!/Applications/Rakudo/bin/perl6
need Venturi::Authority;
need Venturi::Path;
need Venturi::Query;
need Venturi::Fragment;
need Venturi::Keywords;

# https://tools.ietf.org/html/rfc3986?

=begin notes

ftp://ftp.is.co.za/rfc/rfc1808.txt

http://www.ietf.org/rfc/rfc2396.txt

ldap://[2001:db8::7]/c=GB?objectClass?one

mailto:John.Doe@example.com

news:comp.infosystems.www.servers.unix

tel:+1-816-555-1212

telnet://192.0.2.16:80/

urn:oasis:names:specification:docbook:dtd:xml:4.1.2

URI         = scheme ":" hier-part [ "?" query ] [ "#" fragment ]

      hier-part   = "//" authority path-abempty
                  / path-absolute
                  / path-rootless
                  / path-empty

         foo://example.com:8042/over/there?name=ferret#nose
         \_/   \______________/\_________/ \_________/ \__/
          |           |            |            |        |
       scheme     authority       path        query   fragment
          |   _____________________|__
         / \ /                        \
         urn:example:animal:ferret:nose

=end notes

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

	method not-concrete {
#		my $b = Backtrace.new;
#		dd $_ for $b.List;
		#say "Backtrace has {$b.elems} elements";
		fail "{Backtrace.new.[*-3].subname} is not implemented for {self.^name}";
		}
	method authority { self.not-concrete }
	method userinfo  { self.not-concrete }
	method path      { self.not-concrete }
	method query     { self.not-concrete }
	method keywords  { self.not-concrete }
	method fragment  { self.not-concrete }
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


		}


	method Str (  --> Str:D ) { !!! }
	method gist ( --> Str:D ) { !!! }
	}
