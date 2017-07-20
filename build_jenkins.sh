echo $WORKSPACE

cd $WORKSPACE/poker
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

cd $WORKSPACE/poker/html5poker.ngpoker
git checkout $ngpoker_branch
git pull origin $ngpoker_branch

cd $WORKSPACE/poker/taaskingclient.node
git checkout $node_branch
git pull origin $node_branch

cd $WORKSPACE/poker/taaskingclient.nodeTourneyPanel
git checkout $tourneyPanel_branch
git pull origin $tourneyPanel_branch

cd $WORKSPACE/poker/taaskingclient.server
git checkout $server_branch
git pull origin $server_branch

cd $WORKSPACE/poker/taaskingclient.userDB
git checkout $userDB_branch
git pull origin $userDB_branch

cd $WORKSPACE/poker/taaskingclient.videoreplay
git checkout $videoreplay_branch
git pull origin $videoreplay_branch

cd $WORKSPACE/poker/

echo "Changing the username in hibernate files"

sed -i 's,root,gauss,g' taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml
sed -i 's,localhost,$dev_ip,g' taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml

sed -i 's,root,gauss,g' taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml
sed -i 's,localhost,$dev_ip,g' taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml

echo "Changing the mysql properties file in video replay"
sed -i 's,root,gauss,g' taaskingclient.videoreplay/WebContent/WEB-INF/classes/MySql.properties

echo "Building ngpoker"
cd html5poker.ngpoker
grunt --force build
