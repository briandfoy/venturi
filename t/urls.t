use Test;

constant package-name = 'Venturi';
use-ok package-name or bail-out "{package-name} did not compile";
use ::(package-name);
my $class = ::(package-name);

can-ok $class, 'parse';

# http://cpansearch.perl.org/src/SRI/Mojolicious-7.72/t/mojo/url.t

subtest 'simple', {
	my $hash = $class.parse: 'HtTp://Example.Com';
	is $hash.<scheme>,   'HtTp',        'right scheme';
	is $hash.<protocol>, 'http',        'right protocol';
	is $hash.<host>,     'Example.Com', 'right host';
	is $hash.<ihost>,    'Example.Com', 'right internationalized host';
	};

# Advanced
subtest 'advanced', {
	my $hash = $class.parse:
		'https://sri:foobar@example.com:8080/x/index.html?monkey=biz&foo=1#/!%?@3';
	is $hash.<scheme>,     'https',                          'right scheme';
	is $hash.<protocol>,   'https',                          'right protocol';
	is $hash.<userinfo>,   'sri:foobar',                     'right userinfo';
	is $hash.<username>,   'sri',                            'right username';
	is $hash.<password>,   'foobar',                         'right password';
	is $hash.<host>,       'example.com',                    'right host';
	is $hash.<port>,       '8080',                           'right port';
	is $hash.<path>,       '/x/index.html',                  'right path';
	is $hash.<query>,      'monkey=biz&foo=1',               'right query';
	is $hash.<path_query>, '/x/index.html?monkey=biz&foo=1', 'right path and query';
	is $hash.<fragment>,   '/!%?@3',                         'right fragment';
	}

# Advanced userinfo and fragment roundtrip
subtest 'websocket', {
	my $hash = $class.parse:
	  'ws://AZaz09-._~!$&\'()*+,;=:@localhost#AZaz09-._~!$&\'()*+,;=:@/?';
	is $hash.<scheme>,   'ws',                         'right scheme';
	is $hash.<userinfo>, 'AZaz09-._~!$&\'()*+,;=:',    'right userinfo';
	is $hash.<username>, 'AZaz09-._~!$&\'()*+,;=',     'right username';
	is $hash.<password>, '',                           'right password';
	is $hash.<host>,     'localhost',                  'right host';
	is $hash.<fragment>, 'AZaz09-._~!$&\'()*+,;=:@/?', 'right fragment';
	};

# Parameters
subtest 'parameters', {
	my $hash = $class.parse:
		'http://sri:foobar@example.com:8080?_monkey=biz%3B&_monkey=23#23';
	is $hash.<scheme>,   'http', 'right scheme';
	is $hash.<userinfo>, 'sri:foobar', 'right userinfo';
	is $hash.<host>,     'example.com', 'right host';
	is $hash.<port>,     '8080', 'right port';
	is $hash.<path>,     '', 'no path';
	is $hash.<query>,    '_monkey=biz%3B&_monkey=23', 'right query';
	}

# Query string
subtest 'query string', {
	my $hash = $class.parse:
	  'wss://sri:foo:bar@example.com:8080?_monkeybiz%3B&_monkey;23#23';
	is $hash.<scheme>,   'wss',                      'right scheme';
	is $hash.<userinfo>, 'sri:foo:bar',              'right userinfo';
	is $hash.<username>, 'sri',                      'right username';
	is $hash.<password>, 'foo:bar',                  'right password';
	is $hash.<host>,     'example.com',              'right host';
	is $hash.<port>,     '8080',                     'right port';
	is $hash.<path>,     '',                         'no path';
	is $hash.<query>,    '_monkeybiz%3B&_monkey;23', 'right query';
	todo 'Check this';
	is $hash.<query>, '_monkeybiz%3B=&_monkey%3B23=', 'right query';
	is $hash.<fragment>, '23', 'right fragment';

	$hash = $class.parse: 'https://example.com/0?0#0';
	is $hash.<scheme>,    'https', 'right scheme';
	is $hash.<userinfo>,  Any, 'no userinfo';
	is $hash.<username>,  Any, 'no username';
	is $hash.<password>,  Any, 'no password';
	is $hash.<host>,      'example.com', 'right host';
	is $hash.<port>,      Any, 'no port';
	is $hash.<host_port>, 'example.com', 'right host and port';
	is $hash.<path>,      '/0', 'no path';
	is $hash.<query>,     '0', 'right query';
	is $hash.<fragment>,  '0', 'right fragment';
	};


# No authority
subtest 'no authority', {
	my $hash = $class.parse: 'DATA:image/png;base64,helloworld123';
	is $hash.<scheme>,   'DATA',                            'right scheme';
	is $hash.<protocol>, 'data',                            'right protocol';
	is $hash.<userinfo>, Any,                               'no userinfo';
	is $hash.<host>,     Any,                               'no host';
	is $hash.<port>,     Any,                               'no port';
	is $hash.<path>,     'image/png;base64,helloworld123',  'right path';
	is $hash.<query>,    Any,                               'no query';
	is $hash.<fragment>, Any,                               'no fragment';

	$hash = $class.parse: 'mailto:sri@example.com';
	is $hash.<scheme>,   'mailto',          'right scheme';
	is $hash.<protocol>, 'mailto',          'right protocol';
	is $hash.<path>,     'sri@example.com', 'right path';

	$hash = $class.parse: 'foo:/test/123?foo=bar#baz';
	is $hash.<scheme>,   'foo',       'right scheme';
	is $hash.<protocol>, 'foo',       'right protocol';
	is $hash.<path>,     '/test/123', 'right path';
	is $hash.<query>,    'foo=bar',   'right query';
	is $hash.<fragment>, 'baz',       'right fragment';

	$hash = $class.parse: 'file:///foo/bar';
	is $hash.<scheme>,   'file',     'right scheme';
	is $hash.<protocol>, 'file',     'right protocol';
	is $hash.<path>,     '/foo/bar', 'right path';

	$hash = $class.parse: 'foo:0';
	is $hash.<scheme>,   'foo', 'right scheme';
	is $hash.<protocol>, 'foo', 'right protocol';
	is $hash.<path>,     '0',   'right path';
	}

# Relative
subtest 'relative', {
	my $hash = $class.parse: 'foo?foo=bar#23';
	is $hash.<path_query>, 'foo?foo=bar', 'right path and query';

	$hash = $class.parse: '/foo?foo=bar#23';
	is $hash.<path_query>, '/foo?foo=bar', 'right path and query';
	}


# Relative without scheme
subtest 'relative without scheme', {
	my $hash = $class.parse: '//localhost/23/';
	is $hash.<scheme>,   Any,         'no scheme';
	is $hash.<protocol>, Any,         'no protocol';
	is $hash.<host>,     'localhost', 'right host';
	is $hash.<path>,     '/23/',      'right path';

	$hash = $class.parse: '///bar/23/';
	is $hash.<host>, Any,         'no host';
	is $hash.<path>, '/bar/23/', 'right path';

	$hash = $class.parse: '////bar//23/';
	is $hash.<host>, Any,           'no host';
	is $hash.<path>, '//bar//23/', 'right path';
	}


# Clone (advanced)
subtest 'clone (advanced)', {
	my $hash = $class.parse:
	  'ws://sri:foobar@example.com:8080/test/index.html?monkey=biz&foo=1#23';
	is $hash.<scheme>,   'ws', 'right scheme';
	is $hash.<userinfo>, 'sri:foobar', 'right userinfo';
	is $hash.<host>,     'example.com', 'right host';
	is $hash.<port>,     '8080', 'right port';
	is $hash.<path>,     '/test/index.html', 'right path';
	is $hash.<query>,    'monkey=biz&foo=1', 'right query';
	is $hash.<fragment>, '23', 'right fragment';
	}


# IPv6
subtest 'IPv6', {
	my $hash = $class.parse: 'wss://[::1]:3000/';
	is $hash.<scheme>,    'wss',        'right scheme';
	is $hash.<authority>, '[::1]:3000', 'right authority';
	is $hash.<host>,      '[::1]',      'right host';
	is $hash.<port>,      3000,         'right port';
	is $hash.<path>,      '/',          'right path';
	}

# Escaped host
subtest 'Escaped host', {
	my $hash = $class.parse: 'http+unix://%2FUsers%2Fsri%2Ftest.sock/index.html';
	is $hash.<scheme>,    'http+unix', 'right scheme';
	is $hash.<host>,      '/Users/sri/test.sock', 'right host';
	is $hash.<port>,      Any, 'no port';
	is $hash.<host_port>, '/Users/sri/test.sock', 'right host and port';
	is $hash.<path>,      '/index.html', 'right path';
	}

# IDNA
subtest 'IDNA', {
	my $hash = $class.parse: 'http://bücher.ch:3000/foo';
	is $hash.<scheme>,     'http', 'right scheme';
	is $hash.<host>,       'bücher.ch', 'right host';
	is $hash.<ihost>,      'xn--bcher-kva.ch', 'right internationalized host';
	is $hash.<port>,       3000, 'right port';
	is $hash.<host_port>,  'xn--bcher-kva.ch:3000', 'right host and port';
	is $hash.<path>,       '/foo', 'right path';
	is $hash.<path_query>, '/foo', 'right path and query';

	$hash = $class.parse: 'http://bücher.bücher.ch:3000/foo';
	is $hash.<scheme>, 'http', 'right scheme';
	is $hash.<host>,   'bücher.bücher.ch', 'right host';
	is $hash.<ihost>,  'xn--bcher-kva.xn--bcher-kva.ch', 'right internationalized host';
	is $hash.<port>, 3000,   'right port';
	is $hash.<path>, '/foo', 'right path';

	$hash = $class.parse: 'http://bücher.bücher.bücher.ch:3000/foo';
	is $hash.<scheme>, 'http', 'right scheme';
	is $hash.<host>,   'bücher.bücher.bücher.ch', 'right host';
	is $hash.<ihost>,  'xn--bcher-kva.xn--bcher-kva.xn--bcher-kva.ch', 'right internationalized host';
	is $hash.<port>, 3000,   'right port';
	is $hash.<path>, '/foo', 'right path';
	}

# IDNA (escaped userinfo and host)
subtest 'IDNA (escaped userinfo and host)', {
	my $hash = $class.parse: 'https://%E2%99%A5:%E2%99%A5@kr%E4ih.com:3000';
	is $hash.<userinfo>, '♥:♥',          'right userinfo';
	is $hash.<username>, '♥',              'right username';
	is $hash.<password>, '♥',              'right password';
	is $hash.<host>,     "kr\xe4ih.com",     'right host';
	is $hash.<ihost>,    'xn--krih-moa.com', 'right internationalized host';
	is $hash.<port>,     3000,               'right port';
	}

# IDNA (snowman)
subtest 'IDNA (snowman)', {
	my $hash = $class.parse: 'http://☃:☃@☃.☃.de/☃?☃#☃';
	is $hash.<scheme>,   'http', 'right scheme';
	is $hash.<userinfo>, '☃:☃', 'right userinfo';
	is $hash.<host>,     '☃.☃.de', 'right host';
	is $hash.<ihost>,    'xn--n3h.xn--n3h.de', 'right internationalized host';
	is $hash.<path>,     '/%E2%98%83', 'right path';
	is $hash.<query>,    '%E2%98%83', 'right query';
	is $hash.<fragment>, '☃', 'right fragment';
	}

# IRI/IDNA
subtest 'IRI/IDNA', {
	my $hash = $class.parse: 'http://☃.net/♥/?q=♥☃';
	is $hash.<path>,  '/%E2%99%A5/',          'right path';
	is $hash.<query>, 'q=%E2%99%A5%E2%98%83', 'right query';

	$hash = $class.parse: 'http://☃.Net/♥/♥/?♥=☃';
	is $hash.<scheme>, 'http', 'right scheme';
	is $hash.<host>,   '☃.Net', 'right host';
	is $hash.<ihost>,  'xn--n3h.Net', 'right internationalized host';
	is $hash.<path>,   '/%E2%99%A5/%E2%99%A5/', 'right path';

	$hash = $class.parse:
	  'http://xn--n3h.net/%E2%99%A5/%E2%99%A5/?%E2%99%A5=%E2%98%83';
	is $hash.<scheme>, 'http', 'right scheme';
	is $hash.<host>,   'xn--n3h.net', 'right host';
	is $hash.<ihost>,  'xn--n3h.net', 'right internationalized host';
	is $hash.<path>,   '/%E2%99%A5/%E2%99%A5/', 'right path';
	}

# "0"
subtest '0', {
	my $hash = $class.parse: 'http://0@foo.com#0';
	is $hash.<scheme>,   'http',    'right scheme';
	is $hash.<userinfo>, '0',       'right userinfo';
	is $hash.<username>, '0',       'right username';
	is $hash.<password>, Any,     'no password';
	is $hash.<host>,     'foo.com', 'right host';
	is $hash.<fragment>, '0',       'right fragment';
	}

# Empty path elements
subtest 'empty path elements', {
	my $hash = $class.parse: 'http://example.com/foo//bar/23/';
	is $hash.<path>, '/foo//bar/23/', 'right path';

	$hash = $class.parse: 'http://example.com//foo//bar/23/';
	is $hash.<path>, '//foo//bar/23/', 'right path';

	$hash = $class.parse: 'http://example.com/foo///bar/23/';
	is $hash.<path>, '/foo///bar/23/', 'right path';
	}

# Merge relative path
subtest 'merge relative path', {
	my $hash = $class.parse: 'http://foo.bar/baz?yada';
	is $hash.<scheme>,   'http',    'right scheme';
	is $hash.<userinfo>, Any,     'no userinfo';
	is $hash.<host>,     'foo.bar', 'right host';
	is $hash.<port>,     Any,     'no port';
	is $hash.<path>,     '/baz',    'right path';
	is $hash.<query>,    'yada',    'right query';
	is $hash.<fragment>, Any,     'no fragment';
	}

# Merge relative path with directory
subtest 'merge relative path with directory', {
	my $hash = $class.parse: 'http://foo.bar/baz/index.html?yada';
	is $hash.<scheme>,   'http',            'right scheme';
	is $hash.<userinfo>, Any,             'no userinfo';
	is $hash.<host>,     'foo.bar',         'right host';
	is $hash.<port>,     Any,             'no port';
	is $hash.<path>,     '/baz/index.html', 'right path';
	is $hash.<query>,    'yada',            'right query';
	is $hash.<fragment>, Any,             'no fragment';
	}

# Merge absolute path
subtest 'merge absolute path', {
	my $hash = $class.parse: 'http://foo.bar/baz/index.html?yada';
	is $hash.<scheme>,   'http',            'right scheme';
	is $hash.<userinfo>, Any,             'no userinfo';
	is $hash.<host>,     'foo.bar',         'right host';
	is $hash.<port>,     Any,             'no port';
	is $hash.<path>,     '/baz/index.html', 'right path';
	is $hash.<query>,    'yada',            'right query';
	is $hash.<fragment>, Any,             'no fragment';
	}

# Merge absolute path without query
subtest 'merge absolute path without query', {
	my $hash = $class.parse: 'http://foo.bar/baz/index.html?yada';
	is $hash.<scheme>,   'http',            'right scheme';
	is $hash.<userinfo>, Any,             'no userinfo';
	is $hash.<host>,     'foo.bar',         'right host';
	is $hash.<port>,     Any,             'no port';
	is $hash.<path>,     '/baz/index.html', 'right path';
	is $hash.<query>,    'yada',            'right query';
	is $hash.<fragment>, Any,             'no fragment';
	}

# Merge absolute path with fragment
subtest 'Merge absolute path with fragment', {
	my $hash = $class.parse: 'http://foo.bar/baz/index.html?yada#test1';
	is $hash.<scheme>,   'http',            'right scheme';
	is $hash.<userinfo>, Any,             'no userinfo';
	is $hash.<host>,     'foo.bar',         'right host';
	is $hash.<port>,     Any,             'no port';
	is $hash.<path>,     '/baz/index.html', 'right path';
	is $hash.<query>,    'yada',            'right query';
	is $hash.<fragment>, 'test1',           'right fragment';
	}

# Merge relative path with fragment
subtest 'Merge relative path with fragment', {
	my $hash = $class.parse: 'http://foo.bar/baz/index.html?yada#test1';
	is $hash.<scheme>,   'http',            'right scheme';
	is $hash.<userinfo>, Any,             'no userinfo';
	is $hash.<host>,     'foo.bar',         'right host';
	is $hash.<port>,     Any,             'no port';
	is $hash.<path>,     '/baz/index.html', 'right path';
	is $hash.<query>,    'yada',            'right query';
	is $hash.<fragment>, 'test1',           'right fragment';
	}

# Merge absolute path without fragment
subtest 'Merge absolute path without fragment', {
	my $hash = $class.parse: 'http://foo.bar/baz/index.html?yada#test1';
	is $hash.<scheme>,   'http',            'right scheme';
	is $hash.<userinfo>, Any,             'no userinfo';
	is $hash.<host>,     'foo.bar',         'right host';
	is $hash.<port>,     Any,             'no port';
	is $hash.<path>,     '/baz/index.html', 'right path';
	is $hash.<query>,    'yada',            'right query';
	is $hash.<fragment>, 'test1',           'right fragment';
	}

# Hosts
subtest 'hosts', {
	my $hash = $class.parse: 'http://mojolicious.org';
	is $hash.<host>, 'mojolicious.org', 'right host';

	$hash = $class.parse: 'http://[::1]';
	is $hash.<host>, '[::1]', 'right host';

	$hash = $class.parse: 'http://127.0.0.1';
	is $hash.<host>, '127.0.0.1', 'right host';

	$hash = $class.parse: 'http://0::127.0.0.1';
	is $hash.<host>, '0::127.0.0.1', 'right host';

	$hash = $class.parse: 'http://[0::127.0.0.1]';
	is $hash.<host>, '[0::127.0.0.1]', 'right host';

	$hash = $class.parse: 'http://mojolicious.org:3000';
	is $hash.<host>, 'mojolicious.org', 'right host';

	$hash = $class.parse: 'http://[::1]:3000';
	is $hash.<host>, '[::1]', 'right host';

	$hash = $class.parse: 'http://127.0.0.1:3000';
	is $hash.<host>, '127.0.0.1', 'right host';

	$hash = $class.parse: 'http://0::127.0.0.1:3000';
	is $hash.<host>, '0::127.0.0.1', 'right host';

	$hash = $class.parse: 'http://[0::127.0.0.1]:3000';
	is $hash.<host>, '[0::127.0.0.1]', 'right host';

	$hash = $class.parse: 'http://foo.1.1.1.1.de/';
	is $hash.<host>, 'foo.1.1.1.1.de', 'right host';

	$hash = $class.parse: 'http://1.1.1.1.1.1/';
	is $hash.<host>, '1.1.1.1.1.1', 'right host';
	}

# Heavily escaped path and empty fragment
subtest 'Heavily escaped path and empty fragment', {
	my $hash = $class.parse:
	  'http://example.com/mojo%2Fg%2B%2B-4%2E2_4%2E2%2E3-2ubuntu7_i386%2Edeb#';
	is $hash.<scheme>,   'http',         'right scheme';
	is $hash.<userinfo>, Any,            'no userinfo';
	is $hash.<host>,     'example.com',  'right host';
	is $hash.<port>,     Any,            'no port';
	is $hash.<query>,    Any,            'no query';
	is $hash.<fragment>, Any,            'right fragment';
	is $hash.<path>,     '/mojo%2Fg%2B%2B-4.2_4.2.3-2ubuntu7_i386.deb', 'right path';
	}

# "%" in path
subtest '% in path', {
	my $hash = $class.parse: 'http://mojolicious.org/100%_fun';
	is $hash.<path>, '/100%25_fun', 'right path';

	$hash = $class.parse: 'http://mojolicious.org/100%fun';
	is $hash.<path>, '/100%25fun', 'right path';

	$hash = $class.parse: 'http://mojolicious.org/100%25_fun';
	is $hash.<path>, '/100%25_fun', 'right path';
	}


# Trailing dot
subtest 'Trailing dot', {
	my $hash = $class.parse: 'http://☃.net./♥';
	is $hash.<ihost>, 'xn--n3h.net.', 'right internationalized host';
	is $hash.<host>,  '☃.net.',     'right host';
	}


done-testing();
