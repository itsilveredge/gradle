#!/bin/bash
# ./poker_build.sh ngpoker node tp server userdb replay devip
ngpoker_branch=$1
node_branch=$2
tourneyPanel_branch=$3
server_branch=$4
userDB_branch=$5
videoreplay_branch=$6
dev_ip=$7

echo "ngpoker $ngpoker_branch"
echo "node $node_branch"
echo "tp $tourneyPanel_branch"
echo "server $server_branch"
echo "userdb $userDB_branch"
echo "replay $videoreplay_branch"
echo "dev_ip $dev_ip"

echo `pwd`

if [ ! -f html5poker.ngpoker/.git ]; then
    echo "Initializing ngpoker project"
    git submodule update --init -- html5poker.ngpoker
fi

if [ ! -f taaskingclient.node/.git ]; then
    echo "Initializing node project"
    git submodule update --init -- taaskingclient.node
fi

if [ ! -f taaskingclient.nodeTourneyPanel/.git ]; then
    echo "Initializing tourney panel project"
    git submodule update --init -- taaskingclient.nodeTourneyPanel
fi

if [ ! -f taaskingclient.server/.git ]; then
    echo "Initializing server project"
    git submodule update --init -- taaskingclient.server
fi

if [ ! -f taaskingclient.userDB/.git ]; then
    echo "Initializing userdb project"
    git submodule update --init -- taaskingclient.userDB
fi

if [ ! -f taaskingclient.videoreplay/.git ]; then
    echo "Initializing video replay project"
    git submodule update --init -- taaskingclient.videoreplay
fi

echo "Resetting all the submodules"
git submodule foreach git add -A

echo "Resetting all the submodules"
git submodule foreach git reset --hard HEAD

echo "Fetching new changes in each submodule"
git submodule foreach git fetch --all --prune

cd html5poker.ngpoker
git checkout $ngpoker_branch
git pull origin $ngpoker_branch
cd ..

cd taaskingclient.node
git checkout $node_branch
git pull origin $node_branch
cd ..

cd taaskingclient.nodeTourneyPanel
git checkout $tourneyPanel_branch
git pull origin $tourneyPanel_branch
cd ..

cd taaskingclient.server
git checkout $server_branch
git pull origin $server_branch
cd ..

cd taaskingclient.userDB
git checkout $userDB_branch
git pull origin $userDB_branch
cd ..

cd taaskingclient.videoreplay
git checkout $videoreplay_branch
git pull origin $videoreplay_branch
cd ..

echo "Changing the username in hibernate files"

sed -i "s,root,gauss,g" taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml
sed -i "s,localhost,$dev_ip,g" taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml

sed -i "s,root,gauss,g" taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml
sed -i "s,localhost,$dev_ip,g" taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml

echo "Building ngpoker"
cd html5poker.ngpoker
grunt --force build
cd ..

echo "Building server"
gradle -Ddev_ip=$dev_ip clean build -x test

echo "Building replay"
cd taaskingclient.videoreplay
mvn clean install

cd ..
