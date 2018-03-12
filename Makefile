.PHONY: test
test: clean
	prove -r -e 'perl6 -Ilib' t

.PHONY: clean
clean:
	rm -rf lib/.precomp
