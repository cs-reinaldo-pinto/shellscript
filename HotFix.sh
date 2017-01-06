#!/bin/bash

numberbranchs=`git branch -a |grep -i 'remotes/origin' |grep -iv 'head' |grep -i 'hotfix' |wc -l`

if [[ "$numberbranchs" > 1 ]]; then
	echo "Erro, numero de branch hotfix acima do esperado: $numberbranchs." 
	exit 1
elif [[ "$numberbranchs" == 1 ]]; then
	echo "Numero de branch hotfix: $numberbranchs, status Ok."
	branchhotfix=`git branch -a |grep -i 'remotes/origin' |grep -iv 'head' |grep -i 'hotfix' |sed 's@remotes/origin/@@g'`
	git checkout $branchhotfix
	TIMESTAMP="$(date +'%Y%m%d_%H-%M-%S')"
	REVISION=$(git rev-parse --short HEAD)
	git checkout master
	git commit -m "Hotfix merge at ${TIMESTAMP} - ${REVISION}"
	git push -q upstream HEAD:gh-pages
else
	echo "Erro, nao encontramos branch com o prefixo 'hotfix'."
	exit 1
fi
