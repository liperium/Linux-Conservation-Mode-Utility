build:
#Legacy
#go build -tags=legacy_appindicator -o build/legacy main.go - No nix package for appindicator3-0.1 (tried libaraytanas and gnomes.appindicator)
#Default
#Kind of retired because of nix/gomod2nix.
	rm -rf build/*
	go build -o build/TrayConservationMode main.go
	chmod +x build/TrayConservationMode
	mkdir build/assets
	cp assets/* build/assets
	cp conservationmode build/conservationmode

	mv build conservation_mode
	tar -czf TrayConservationMode.tar.gz conservation_mode

	mv conservation_mode build