need Venturi::Port;

class Venturi::Port::Unix is Venturi::Port {
	method minimum-port            { 1 }
	method maximum-port            { 2**16 - 1 }
	method highest-privileged-port { 2**10 - 1 }
	}
