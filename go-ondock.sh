#!/bin/sh
GOVERSION="REPLACE_GOVERSION"
NAMEBASE="go-ondock"
NAME="${NAMEBASE}$(pwd | sed -e 's,/,-,g')"

if [ $(docker ps --filter=name=${NAME} | wc -l) -lt 2 ]; then
  if [ $(docker ps --format='{{.Names}}' | grep ${NAMEBASE} | wc -l) -gt 5 ]; then
	oldest=$(docker ps --format='{{.ID}}' | grep ${NAMEBASE} | tail -n1)
	docker rm -f ${oldest} > /dev/null 2>&1
  fi
  docker run -tid --rm --name ${NAME} -v /tmp:/tmp -v $PWD:$PWD local/golang:${GOVERSION}-alpine /bin/ash > /dev/null 2>&1
fi
goenv=$(env | grep "^GO")
cmd="cd $PWD && $(basename $0) $@"
docker exec -i -e ${goenv} ${NAME} /bin/ash -c "${cmd}"
