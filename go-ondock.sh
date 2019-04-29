#!/bin/sh
GOVERSION="REPLACE_GOVERSION"
NAMEBASE="go-ondock"
NAME="${NAMEBASE}-$(whoami)"

search_host_gopath() {
  if [ -d $HOME/go ]; then
    echo "$HOME/go"
  elif [ -d /go ]; then
    echo "/go"
  fi
}

if [ $(docker ps --filter=name=${NAME} | wc -l) -lt 2 ]; then
  if [ $(docker ps --format='{{.Names}}' | grep ${NAMEBASE} | wc -l) -gt 5 ]; then
    oldest=$(docker ps --format='{{.ID}}' | grep ${NAMEBASE} | tail -n1)
    docker rm -f ${oldest} > /dev/null 2>&1
  fi
  host_gopath=$(search_host_gopath)
  if [ "${host_gopath}" = "" ]; then
    echo "Not found anything that looks like GOPATH on the host."
    echo "You must make the directory located '~/go' or '/go'."
    exit 1
  fi
  docker run -tid --rm --name ${NAME} -v /tmp:/tmp -v ${host_gopath}/src:/go/src local/golang:${GOVERSION}-alpine /bin/ash > /dev/null 2>&1
fi
user=$(id -u):$(id -g)
goenv=$(env | grep "^GO")
cmd="cd $(pwd | sed -e "s,$HOME,,g") && $(basename $0) $@"
if [ "${goenv}" = "" ];then
  docker exec -i -u ${user} ${NAME} /bin/ash -c "${cmd}"
else
  docker exec -i -u ${user} -e ${goenv} ${NAME} /bin/ash -c "${cmd}"
fi
