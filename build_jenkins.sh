cd $WORKSPACE/poker

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

cd $WORKSPACE/poker/taaskingclient.server
git checkout $server_branch
git pull origin $server_branch

cd $WORKSPACE/poker/taaskingclient.userDB
git checkout $userDB_branch
git pull origin $userDB_branch

cd $WORKSPACE/poker/
echo "Changing the username in hibernate files"
sed -i "s,root,gauss,g" taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml
sed -i "s,root,gauss,g" taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml
sed -i "s,localhost,$dev_ip,g" taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml
sed -i "s,localhost,$dev_ip,g" taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml

cd $WORKSPACE/poker/taaskingclient.server/AlterScripts
for i in `ls -R current/ | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'| grep sql`
do
    echo "file=$i"
    mysql -ugauss -h$dev_ip < $i
done

cd $WORKSPACE/tourney_panel/db/
for i in `ls -R current/ | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'| grep sql`
do
    echo "file=$i"
    mysql -ugauss -h$dev_ip < $i
done

cd $WORKSPACE/replay
/opt/maven/bin/mvn clean install

cd $WORKSPACE/ngPoker
npm install
grunt --force build

cd $WORKSPACE/adda52analytics
git reset --hard HEAD
git fetch --all --prune
git checkout $nodeAnalytics
git pull origin $nodeAnalytics
