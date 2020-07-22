#!/usr/bin/env bash

#My delete-entity.sh script for jhipster Relea#se 2.26.2, based on @shacharsol 's answer.

#Usage: ./delete-entity GROUP_ID ENTITY_NAME

#GROUP_ID: com/subpackage/and/so/on/ (end with '/')

#ENTITY_NAME: firstLowercaseNameOfEntity

#Example: ./delete-entity uz/javlon/ transInfo


echo;
if [ -z "$1" ];
then
    printf "Required argument GROUP_ID is not set. \nUsage: ./delete-entity.sh GROUP_ID ENTITY_NAME.\n";
    exit 1;
else
    GROUP_ID=$1;
    echo "GROUP_ID is set to '$1'.";
fi

if [ -z "$2" ];
then
    printf "Required argument ENTITY_NAME is not set. \nUsage: ./delete-entity.sh GROUP_ID ENTITY_NAME .\n";
    exit 1;
else
    ENTITY_NAME=$2;
    JAVA_ENTITY_NAME=`echo ${ENTITY_NAME:0:1} | tr  '[a-z]' '[A-Z]'`${ENTITY_NAME:1}
    echo "ENTITY_NAME is set to '$2'."
    echo "Java entity name inferred as: '${JAVA_ENTITY_NAME}'.";
fi

JAVA_ENTITY_NAME=`echo ${ENTITY_NAME:0:1} | tr  '[a-z]' '[A-Z]'`${ENTITY_NAME:1}
UNDERSCORED_FOLDER_NAME=`echo ${ENTITY_NAME} | sed -r 's/([a-z0-9])([A-Z])/\1-\L\2/g'`
echo ${UNDERSCORED_FOLDER_NAME};

QUESTION=$'You may want to keep definition file(.jhipster/'${JAVA_ENTITY_NAME}'.json) in case you want to regenerate entity in the future.\nDo you want to delete entity definition file also?'

while true; do
    read -p "${QUESTION}" yn
    case $yn in
        [Yy]* ) rm -rf ./.jhipster/${ENTITY_NAME}.json; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo;
echo "Starting to delete files...";

rm -rf src/main/resources/config/liquibase/changelog/*_added_entity_${JAVA_ENTITY_NAME}.xml
rm -rf src/main/java/${GROUP_ID}domain/${JAVA_ENTITY_NAME}.java
rm -rf src/main/java/${GROUP_ID}repository/${JAVA_ENTITY_NAME}Repository.java
rm -rf src/main/java/${GROUP_ID}service/${JAVA_ENTITY_NAME}Service.java
rm -rf src/main/java/${GROUP_ID}service/impl/${JAVA_ENTITY_NAME}ServiceImpl.java
rm -rf src/main/java/${GROUP_ID}repository/search/${JAVA_ENTITY_NAME}SearchRepository.java
rm -rf src/main/java/${GROUP_ID}web/rest/${JAVA_ENTITY_NAME}Resource.java
rm -rf src/main/java/${GROUP_ID}web/rest/dto/${JAVA_ENTITY_NAME}DTO.java
rm -rf src/main/java/${GROUP_ID}web/rest/mapper/${JAVA_ENTITY_NAME}Mapper.java
rm -rf target/generated-sources/${GROUP_ID}web/rest/mapper/${JAVA_ENTITY_NAME}MapperImpl.java

rm -rf src/main/webapp/app/entities/${UNDERSCORED_FOLDER_NAME}/*

rm -rf src/test/java/${GROUP_ID}web/rest/${JAVA_ENTITY_NAME}ResourceIntTest.java
rm -rf src/test/gatling/simulations/${JAVA_ENTITY_NAME}GatlingTest.scala
rm -rf src/test/javascript/spec/app/entities/${UNDERSCORED_FOLDER_NAME}/*
rm -rf src/test/javascript/spec/app/entities/${UNDERSCORED_FOLDER_NAME}

rm -rf src/main/webapp/i18n/en/${ENTITY_NAME}.json
rm -rf src/main/webapp/i18n/fr/${ENTITY_NAME}.json
rm -rf src/main/webapp/i18n/ru/${ENTITY_NAME}.json
rm -rf src/main/webapp/i18n/uz/${ENTITY_NAME}.json

echo "Deleting entity '${ENTITY_NAME}' is completed.";
echo;
echo "-----------------------------------------------------";
echo "Do not forget to manually correct these files also:  ";
echo "-----------------------------------------------------";
echo " --> src/main/webapp/index.html"
echo " --> src/main/webapp/scripts/compopnents/navbar.html"
echo " --> src/main/webapp/i18n/**/global.json"
echo " --> src/main/resources/config/liquibase/master.xml (if you use liquibase)"
echo " --> src/main/resources/config/mongeez/master.xml   (if you use mongodb)"