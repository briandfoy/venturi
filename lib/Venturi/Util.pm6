unit module Venturi::Util;

sub utf8_encode ( Str:D $string --> Str:D ) is export {
	!!!
	}

sub utf8_decode ( Str:D $string --> Str:D ) is export {
	my $buf = Buf.new(
		$string.comb.map: { $^a.ord < 255 ?? $^a.ord !! $^a.encode('utf8-c8').Slip }
		);
	my $d = $buf.decode( 'utf-8' );
	$d;
	}

sub url_unescape ( Str:D $string --> Str:D ) is export {
	return $string.subst:
		rx/ '%' ( <[0..9 a..f A..F]> ** 2 ) /,
		{ :16(~$0).chr },
		:g;
	}

sub url_escape_path ( Str:D $string --> Str:D )  is export {
	$string.subst:
		/ ( <-[A .. Z a .. z 0 .. 9 . _ ~  ! $ & ' () * , ; = : @ - ]> ) /,
		{
		my $m = $0;
		$m.Str.ord < 255 ??
			$m.Str.ord.fmt( '%%' ~ '%02X' )
				!!
			$m.Str.encode('utf8-c8').map( *.fmt( '%%' ~ '%02X' ) ).join: ''
		},
		:g;
	}
