compile:
#Legacy
	go build -tags=legacy_appindicator -o build/legacy main.go
#Default
	go build -o build/default main.go
