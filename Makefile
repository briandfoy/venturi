.PHONY: test
test:
	prove -r -e 'perl6 -Ilib' t
