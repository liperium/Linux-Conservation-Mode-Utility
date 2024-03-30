compile:
#Legacy
#go build -tags=legacy_appindicator -o build/legacy main.go - No nix package for appindicator3-0.1 (tried libaraytanas and gnomes.appindicator)
#Default
	go build -o build/TrayConservationMode main.go
	mkdir build/assets
	cp assets/* build/assets
	cp conservationmode build/conservationmode
	tar -czf build/TrayConservationMode.tar.gz build/*

