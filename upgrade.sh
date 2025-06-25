#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.27.5 ppagnoni/nginx:$new_ver

# Push new version to dockerhub
docker push ppagnoni/nginx:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

# Clone GitHub repo
git clone git@github.com:ppagnoni/monnezza.git $tmp_dir

# Update image tag
sed -i '' -e "s/ppagnoni\/nginx:.*/ppagnoni\/nginx:$new_ver/g" "$tmp_dir/ArgoCD Tutorial for Beginners: GitOps CD for Kubernetes n1/01_example/1-deployment.yaml"

# Commit and push
cd $tmp_dir
git add -A
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $tmp_dir