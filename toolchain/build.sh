#!/bin/bash
echo -e "Build environment variables:"
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"
echo "BUILD_NUMBER=${BUILD_NUMBER}"

cd src
echo "creating build file..."
echo ${BUILD_NUMBER} > buildStage_BUILD_NUMBER.txt
echo "build file created..."

# Learn more about the available environment variables at:
# https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-deliverypipeline_environment#deliverypipeline_environment

# To review or change build options use:
# ibmcloud cr build --help

echo -e "build backend docker"
cd backend
if [ -f Dockerfile ]; then 
   echo "Dockerfile found"
else
    echo "Dockerfile not found"
    exit 1
fi
ibmcloud cr build -t $REGISTRY_URL/$REGISTRY_NAMESPACE/backend:${BUILD_NUMBER} .

cd ..

echo -e "build frontend docker"
cd frontend
if [ -f Dockerfile ]; then 
   echo "Dockerfile found"
else
    echo "Dockerfile not found"
    exit 1
fi
ibmcloud cr build -t $REGISTRY_URL/$REGISTRY_NAMESPACE/frontend:${BUILD_NUMBER} .

cd ..


buildStage_BUILD_NUMBER=$(cat buildStage_BUILD_NUMBER.txt)
echo "replacing image version with $buildStage_BUILD_NUMBER"...
sed -i "s/BUILD_NUMBER/${buildStage_BUILD_NUMBER}/g" deployment.yaml

#rollback management
echo "rollback file management"
cp deployment.yaml rollback/deployment_${buildStage_BUILD_NUMBER}.yaml
git config --global user.email "s.romano1992@gmail.com"
git config --global user.name "Simone Romano"
git add rollback/deployment_${buildStage_BUILD_NUMBER}.yaml
git commit -m "added rollback file for current build..." rollback/deployment_${buildStage_BUILD_NUMBER}.yaml
git push origin

#tagging
echo "git tagging..."
tag=$(date '+%Y%m%d%H%M%S')_${BUILD_NUMBER}
git tag $tag
echo "created tag $tag"
git push origin $tag