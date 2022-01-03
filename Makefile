MAKEFLAGS += --warn-undefined-variables

export CLIENT_VERSION	 	= $(CLIENT_VERSION)
export GO_VERSION    		= $(GO_VERSION)
export GIT_BRANCH			= $(GIT_BRANCH)

##################################################
# INCLUDES
##################################################

include .github/variables.mk

##################################################
# HELPER
##################################################

.PHONY: help
help:
	@echo "Management commands for loli:"
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "** Golang Commands **"
	@echo ""
	@echo "make setup"
	@echo "make build"
	@echo "make install"
	@echo "make lint"
	@echo "make test"
	@echo "make misspell"
	@echo "make clean"
	@echo ""

##################################################
# GOLANG SHORTCUTS
##################################################

.PHONY: setup
setup:
	@echo "==> Setup..."
	$(GO) mod download
	$(GO) generate -v ./...
	@echo ""

.PHONY: build
build:
	@echo "==> Building..."
	$(GOBUILD) -o $(BINDIR)/$(BINNAME) -ldflags '$(LDFLAGS)' $(MAIN)
	@echo ""

.PHONY: install
install:
	@echo "==> Installing..."
	$(GO) install -x $(MAIN)
	@echo ""

.PHONY: lint
lint:
	@echo "==> Running lint..."
	golint -set_exit_status ./...

.PHONY: test
test:
	@echo "==> Running test..."
	go test -v ./...

.PHONY: misspell
misspell:
	@# misspell - Correct commonly misspelled English words in source files
	@#    go get -u github.com/client9/misspell/cmd/misspell
	@echo "==> Runnig misspell ..."
	find . -name '*.go' -not -path './vendor/*' -not -path './_repos/*' | xargs misspell -error
	@echo ""

.PHONY: clean
clean:
	@echo "==> Cleaning..."
	$(GO) clean -x -i $(MAIN)
	rm -rf ./bin/* ./vendor ./dist *.tar.gz
	@echo ""

.PHONY: verify-goreleaser
verify-goreleaser:
ifeq (, $(shell which goreleaser))
	$(error "No goreleaser in $(PATH), consider installing it from https://goreleaser.com/install")
endif
	goreleaser --version

.PHONY: snapshot
snapshot: verify-goreleaser
	goreleaser --snapshot --skip-publish  --rm-dist

.PHONY: release
release: verify-goreleaser
	goreleaser release --rm-dist --debug
