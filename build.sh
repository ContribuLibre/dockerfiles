#!/bin/bash
# this is kind of an expensive check, so let's not do this twice if we
# are running more than one validate bundlescript

REPO='https://gogs.boxobox.xyz/xataz/dockerfiles.git'
BRANCH='master'
USER='xataz'
DOCKER_PUSH=$1

CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"

HEAD="$(git rev-parse --verify HEAD)"

git fetch -q "$REPO" "refs/heads/$BRANCH"
UPSTREAM="$(git rev-parse --verify FETCH_HEAD)"

COMMIT_DIFF="$UPSTREAM...$HEAD"

validate_diff() {
	if [ "$UPSTREAM" != "$HEAD" ]; then
		git diff "$COMMIT_DIFF" "$@"
	else
		git diff HEAD~ "$@"
	fi
}

deps_pull() {
    image=$1
    images_list=""
    image_path=$2

    while true; do
        image=$(grep 'FROM' ${image_path}/Dockerfile | awk '{print $2}')
        if [[ $image == ${USER}* ]];then
            image_name=$(echo $image | cut -d/ -f 2 | cut -d: -f1)
            image_tag=${latest-$(echo $image | cut -d: -f2)}
            [ $image_name == $image_tag ] && image_tag='latest' && image_name=$(echo $image_name | cut -d/ -f2)
            
            if [ "$(find ${image_name} -type f -name .tags)" == "" ]; then
                image_path=${image_name}
            else
                if [ -e "${image_name}/Dockerfile" ]; then
                    image_path=${image_name}
                else
                    image_path=$(dirname $(grep -E "^${image_tag}[[:blank:]]|[[:blank:]]${image_tag}[[:blank:]]|[[:blank:]]${image_tag}$" $(find ${image_name} -type f -name .tags) | grep -v "$2" | cut -d: -f1))
                fi
            fi
            images_list="${image_name}|${image_tag}|${image_path} "${images_list}
        else
            echo -e "${CBLUE}Pull ${image}${CEND}" 
            docker pull ${image}
            break
        fi
    done
    for f in ${images_list[@]}; do
        f_name=$(echo $f | cut -d"|" -f1)
        f_tag=$(echo $f | cut -d"|" -f2)
        f_path=$(echo $f | cut -d"|" -f3)
        build_image ${f_name} ${f_path}
    done 
}

build_image() {
    image_name=$1
    image_dir=$2

    if [ -e "${image_dir}/.tags" ]; then
        tags_list=$(cat ${image_dir}/.tags)
    else
        tags_list="latest"
    fi

    for tag in $tags_list; do
        echo -e "${CGREEN}Build ${USER}/${image_name}:${tag} on ${image_dir}${CEND}"
        docker build -t ${USER}/${image_name}:${tag} ${image_dir}
        if [ $? == 0 ]; then
            echo -e "${CGREEN}                       ---                                   "
            echo -e "Successfully built ${USER}/${image_name}:${tag} with context ${image_dir}"
            echo -e "                       ---                                   ${CEND}"
            if [ "$DOCKER_PUSH" == "push" ]; then
                echo -e "${CYELLOW}Push ${USER}/${image_name}:${tag}${CEND}"
                docker push ${USER}/${image_name}:${tag}
                echo -e "${CYELLOW}                       ---                                   "
                echo -e "Successfully push ${USER}/${image_name}:${tag}"
                echo -e "                       ---                                   ${CEND}"
            fi
        else
            echo -e "${CRED}                       ---                                   "
            echo -e "Failed built ${USER}/${image_name}:${tag} with context ${image_dir}"
            echo -e "                       ---                                   ${CEND}"
            exit 1
        fi
    done
}


# get the dockerfiles changed
IFS=$'\n'
files=( $(validate_diff --diff-filter=ACMRTUX --name-only -- '*Dockerfile') )
unset IFS

# build the changed dockerfiles
for f in "${files[@]}"; do
    image=${f%Dockerfile}
    base=${image%%\/*}
    build_dir=$(dirname $f)
    
    deps_pull ${base} ${build_dir}
    build_image ${base} ${build_dir}
done
