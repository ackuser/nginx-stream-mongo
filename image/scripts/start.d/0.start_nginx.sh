#!/bin/bash
set -e
set -o pipefail

echo "========================================="
echo "Starting nginx"
echo "========================================="


panic(){
    echo $@
    return 1
}

get_git_artifact(){
    set -x
    git config --global http.sslVerify false
    git clone -b master --depth=1 ${ARTIFACT_URL} /tmp/artifact  || panic Could not git clone artifact ${ARTIFACT_URL}
    rm -rf /tmp/artifact/.git /tmp/artifact/.gitignore
    cp -R /tmp/artifact/* ${HOME}
}

get_http_artifact(){

    curl -k --connect-timeout 10 --max-time 60 -o "/tmp/$file" "$ARTIFACT_URL" || panic Could not download artifact ${ARTIFACT_URL}

    if [[ $ARTIFACT_URL = *.tgz* ]] || [[ $ARTIFACT_URL = *.tar.gz* ]]
    then
       tar -xzvf /tmp/$file -C "$HOME"
    fi

    if [[ $ARTIFACT_URL = *.zip* ]]
    then
       unzip -o /tmp/$file  -d "$HOME"
    fi
}

deploy_downloaded_artifact(){
    #### Now I have analyze if html and conf.d directories exits
    if [ -d "${HOME}/conf.d" ]
    then
        #### Preprocess the files to allow interpolation using erb (ruby templates)
        for file in ${HOME}/conf.d/*.conf; do
            cp "${file}" "${file}.orig"
            erb "${file}.orig" > "${file}"
        done
        cp -R "${HOME}/conf.d" "/etc/nginx/"
        rm -rf "${HOME}/conf.d"
    fi

    if [ -d "${HOME}/html" ]
    then
        cp -R "${HOME}/html" "/usr/share/nginx/"
    else
        cp -R ${HOME}/* "/usr/share/nginx/html/."
    fi

}

get_git_artifactconf(){
  set -x
   git config --global http.sslVerify false
   git clone -b master --depth=1 ${ARTIFACTCONF_URL} /tmp/artifactconf  || panic Could not git clone artifact ${ARTIFACTCONF_URL}
   rm -rf /tmp/artifactconf/.git /tmp/artifactconf/.gitignore
   cp -R /tmp/artifactconf/*  ${APP_HOME}
}

get_http_artifactconf(){

    curl -k --connect-timeout 10 --max-time 60 -o "/tmp/$file" "$ARTIFACTCONF_URL" || panic Could not download artifact ${ARTIFACTCONF_URL}

    if [[ $ARTIFACTCONF_URL = *.tgz* ]] || [[ $ARTIFACTCONF_URL = *.tar.gz* ]]
    then
       tar -xzvf /tmp/$file -C "$APP_HOME"
    fi

    if [[ $ARTIFACTCONF_URL = *.zip* ]]
    then
       unzip -o /tmp/$file  -d "$APP_HOME"
    fi

}

deploy_downloaded_artifactconf(){
    #### Now I have analyze if html and conf.d directories exits
    if [ -d "${APP_HOME}/conf.d" ]
    then
        #### Preprocess the files to allow interpolation using erb (ruby templates)
        for file in ${APP_HOME}/conf.d/*.conf; do
            cp "${file}" "${file}.orig"
            erb "${file}.orig" > "${file}"
        done
    fi
}



#### I have to validate if ARTIFACT_URL is available

if [ -n "$ARTIFACT_URL" ]
then
    file=$(basename ${ARTIFACT_URL})

    if [[ $ARTIFACT_URL = *.git ]]
    then
      get_git_artifact
    else
        get_http_artifact
    fi
    deploy_downloaded_artifact
fi

#### I have to validate if ARTIFACTCONF_URL is available

if [ -n "$ARTIFACTCONF_URL" ]
then
    file=$(basename ${ARTIFACTCONF_URL})

    if [[ $ARTIFACTCONF_URL = *.git ]]
    then
      get_git_artifactconf
    else
        get_http_artifactconf
    fi
    deploy_downloaded_artifactconf
fi

if [ -e /etc/nginx/conf.d/default.template ]
 then
   echo "default.template exist. Creating default.conf from default.template"
    envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf
 else
    echo "default.template does not exist"
fi

nginx -g "daemon off;"
