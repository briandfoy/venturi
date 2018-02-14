class Venturi::https is Venturi::http {
	has Str:D $!scheme is ro = 'https';
	has Int:D $!default-port is ro = 443;


	}
