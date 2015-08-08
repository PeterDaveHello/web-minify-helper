YUICOMPERSSOR_VERSION = 2.4.8

.PHONY : all test submodule

all: test yuicompressor.jar submodule

test:
	@bash -n minify.sh

submodule:
	@git submodule update --init

yuicompressor.jar: yuicompressor-$(YUICOMPERSSOR_VERSION).jar
	@ln -f -s yuicompressor-$(YUICOMPERSSOR_VERSION).jar yuicompressor.jar

yuicompressor-$(YUICOMPERSSOR_VERSION).jar:
	@wget https://github.com/yui/yuicompressor/releases/download/v$(YUICOMPERSSOR_VERSION)/yuicompressor-$(YUICOMPERSSOR_VERSION).jar
