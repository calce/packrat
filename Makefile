MOCHA_OPTS= --check-leaks --compilers coffee:coffee-script
REPORTER = list
TIMEOUT = --timeout 10000

check: test

test: test-unit

test-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		$(TIMEOUT) --reporter $(REPORTER) \
		$(MOCHA_OPTS)

test-cov: lib-cov
	@PACKRAT_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov:
	@jscoverage lib lib-cov

benchmark:
	@./support/bench

clean:
	rm -f coverage.html
	rm -fr lib-cov

.PHONY: test test-unit benchmark clean

compile:
	coffee -bw -o ./lib -c ./src