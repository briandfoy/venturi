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
	has $!scheme;

	method new ( :$scheme! is copy --> Venturi:D ) {
		my $subclass = join '::', 'Venturi', $scheme.lc;
		try {
			CATCH {
				default { fail "No Venturi handler for $scheme: $_" }
				}
			require ::($subclass);
			}
		my $venturi = ::($subclass).new: |%_;

		$venturi;
		}

	method not-concrete {
		fail "{Backtrace.new.[*-3].subname} is not implemented for {self.^name}";
		}
	method authority { self.not-concrete }
	method userinfo  { self.not-concrete }
	method path      { self.not-concrete }
	method query     { self.not-concrete }
	method keywords  { self.not-concrete }
	method fragment  { self.not-concrete }

	method uri-pattern () {
		state $pattern = rx/
			^
			    [ $<scheme> = ( <-[:/?#]>+ ) ':' ]?
			    [ '//' $<authority> = ( <-[/?#]>* ) ]?
			$<path>      = ( <-[?#]>* )
			    [ '?' $<query> = (<-[#]>*) ]?
			    [ '#' $<fragment>  = (\N*) ]?
			/;

		$pattern;
		}

	method parse ( ::?CLASS:U : Str:D $url ) {

=begin rfc3986

https://tools.ietf.org/html/rfc3986

^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
 12            3  4          5       6  7        8 9

    http://www.ics.uci.edu/pub/ietf/uri/#Related

results in the following subexpression matches:

	$1 = http:
	$2 = http
	$3 = //www.ics.uci.edu
	$4 = www.ics.uci.edu
	$5 = /pub/ietf/uri/
	$6 = <undefined>
	$7 = <undefined>
	$8 = #Related
	$9 = Related

	scheme    = $2
	authority = $4
	path      = $5
	query     = $7
	fragment  = $9

=end rfc3986

		$url ~~ $?CLASS.uri-pattern;

  		return $/;
		}

	method Str (  --> Str:D ) { !!! }
	method gist ( --> Str:D ) { !!! }
	}
