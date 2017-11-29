#!/bin/bash
# ./poker_build.sh ngpoker node tp server userdb replay devip
server_branch=$4
userDB_branch=$5
dev_ip=$7

echo "server $server_branch"
echo "userdb $userDB_branch"
echo "dev_ip $dev_ip"

echo `pwd`

if [ ! -f taaskingclient.server/.git ]; then
    echo "Initializing server project"
    git submodule update --init -- taaskingclient.server
fi

if [ ! -f taaskingclient.userDB/.git ]; then
    echo "Initializing userdb project"
    git submodule update --init -- taaskingclient.userDB
fi

echo "Resetting all the submodules"
git submodule foreach git add -A

echo "Resetting all the submodules"
git submodule foreach git reset --hard HEAD

echo "Fetching new changes in each submodule"
git submodule foreach git fetch --all --prune

cd taaskingclient.server
git checkout $server_branch
git pull origin $server_branch
cd ..

cd taaskingclient.userDB
git checkout $userDB_branch
git pull origin $userDB_branch
cd ..

echo "Changing the username in hibernate files"

sed -i "s,root,gauss,g" taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml
sed -i "s,localhost,$dev_ip,g" taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml

sed -i "s,root,gauss,g" taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml
sed -i "s,localhost,$dev_ip,g" taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml

echo "Building server"
gradle -Ddev_ip=$dev_ip clean build -x test

cd ..
