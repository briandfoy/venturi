class Venturi::http is Venturi {
	has Str:D $!scheme is ro = 'http';
	has Int:D $!default-port is ro = 80;

	}
