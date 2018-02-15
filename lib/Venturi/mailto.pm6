need Venturi;

class Venturi::mailto is Venturi {
	method scheme           { 'ftp' }
	method default-port     { state $p = Venturi::Port::Unix.new: 21; $p }
	method default-path     { '/' }
	}
