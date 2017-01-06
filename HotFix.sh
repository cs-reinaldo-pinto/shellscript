#!/bin/bash

numberbranchs=`git branch -a |grep -i 'remotes/origin/hotfix*' |wc -l`
path_config="/var/lib/jenkins/jobs/HF-KE-API-Promote/config.xml"

if [[ "$numberbranchs" > 1 ]]; then
    echo "Erro, numero de branch hotfix acima do esperado: $numberbranchs." 
    exit 1
elif [[ "$numberbranchs" == 1 ]]; then
	cp /var/lib/jenkins/jobs/HF-KE-API-Promote/config.xml .
    hotfix=`git branch -a |grep -i 'remotes/origin' |grep -iv 'head' |grep -i "hotfix" |sed 's@remotes/origin/@@g' |sed 's/^[ \t]*//;s/[ \t]*$//'`
    sed -e 's,master,'"$hotfix"',g' config.xml > /var/lib/jenkins/jobs/HF-KE-API-Promote/config.xml
    echo "Branch hotfix: $hotfix, status Ok."
else
	echo "Erro, nao encontramos branch com o prefixo 'hotfix'."
    exit 1
fi


git config --global user.email "jenkins@email.com.br"
  	git config --global user.name "Jenkins_ssh"	
    echo "http://usuario:senha@url.com" > ".git/git-credentials"
    git config credentials.helper store
  	git checkout $HOTFIX
	TIMESTAMP="$(date +'%Y%m%d_%H-%M-%S')"
	REVISION=$(git rev-parse --short HEAD)
	git checkout master
	git merge --no-ff origin/$HOTFIX -m "Hotfix $HOTFIX merge at $TIMESTAMP - $REVISION."
	git tag -a v1.${BUILD_NUMBER} -m "Hotfix merge at ${TIMESTAMP} - ${REVISION}"
    git push origin master #--tags	#-key "/var/lib/jenkins/.ssh/id_rsa"
