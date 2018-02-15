need Venturi::http;
need Venturi::Port::Unix;

class Venturi::https is Venturi::http {
	method scheme           { 'https' }
	method default-port     { state $p = Venturi::Port::Unix.new: 443; $p }
	}
