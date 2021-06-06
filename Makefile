BINARY_NAME=mrkdwn
BINARIES_FOLDER=/usr/local/bin
EXECUTABLE=$(shell swift build --configuration release --show-bin-path)/$(BINARY_NAME)

.PHONY: build install clean genxcodeproj release_zip

build:
	swift build -c release

install: clean build
	install -d "$(BINARIES_FOLDER)"
	install "$(EXECUTABLE)" "$(BINARIES_FOLDER)"

clean:
	swift package clean

genxcodeproj:
	swift package generate-xcodeproj
	Sources/XcodeprojHelper/AddCommandLineArgs.swift $(BINARY_NAME).xcodeproj/xcshareddata/xcschemes/$(BINARY_NAME).xcscheme commandline_arguments.txt

release_zip: install
	rm -rf release_binary
	rm -rf release_binary.zip
	mkdir release_binary
	cp "$(EXECUTABLE)" release_binary
	cp "README.md" release_binary
	zip -r release_binary.zip release_binary/
	rm -rf release_binary