go-ondock
=========

# Description

After installing this, you can use the below commands transparently on the docker host.

* go
* gofmt
* golint

# Prerequisite

* Docker is installed on your host
* Go is not installed on your host
* Your Golang working directory on the host must be located in `~/go` or `/go`

# Installation

```
sudo make install
```

# Uninstallation

```
sudo make uninstall && sudo make rmi
```
