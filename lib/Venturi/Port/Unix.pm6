need Venturi::Port;

class Venturi::Port::Unix is Venturi::Port {
	method minimum-port            ( --> Int:D ) { 1 }
	method maximum-port            ( --> Int:D ) { 2**16 - 1 }
	method highest-privileged-port ( --> Int:D ) { 2**10 - 1 }
	}
