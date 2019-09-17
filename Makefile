dest := /usr/local/bin
script := go-ondock.sh
symlinks := $(dest)/go $(dest)/gofmt $(dest)/golint
goversion := 1.13
files := $(dest)/$(script) $(symlinks)

$(dest)/$(script):
	cp -f $(script) $@
	sed -e 's/REPLACE_GOVERSION/$(goversion)/' -i $@
	chmod +x $@

$(symlinks):
	ln -s $(dest)/$(script) $@

image:
	if ! docker images --format="{{.Repository}}:{{.Tag}}" | grep -q local/golang:$(goversion)-alpine; then \
	  docker build --build-arg GOVERSION=$(goversion) -t local/golang:$(goversion)-alpine . ; \
	fi

.PHONY: install
install: $(files) image

.PHONY: uninstall
uninstall:
	rm -f $(files)

.PHONY: rmi
rmi:
	docker rmi local/golang:$(goversion)-alpine
