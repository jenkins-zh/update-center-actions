#!/bin/sh
echo '=================== Create deploy key to push ==================='
mkdir /root/.ssh
ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts && \
ssh-keyscan -t rsa gitee.com >> /root/.ssh/known_hosts && \
echo "${GIT_DEPLOY_KEY}" > /root/.ssh/id_rsa && \
chmod 400 /root/.ssh/id_rsa

echo '=================== Clone website ==================='
rm -rf update-center-mirror
git clone ${WEBSITE_GIT}

echo '=================== Publish to GitHub Pages ==================='
cp -R mirror/* update-center-mirror/tsinghua
ls -hal mirror
ls -ahl update-center-mirror

cd update-center-mirror && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
git log -3 && \
git add . && \
pwd && \
git remote -vv && \
echo -n 'Files to Commit:' && ls -l | wc -l && \
timestamp=$(date +%s%3N) && \
git commit -m "Automated deployment to GitHub Pages on $timestamp" && \
git status && \
git push origin master --force
echo '=================== Done  ==================='
