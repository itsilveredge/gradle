cd $WORKSPACE/poker/html5poker
git pull origin master

cd $WORKSPACE/poker/html5poker.ngpoker
git pull origin master

cd $WORKSPACE/poker/taaskingclient
git pull origin master

cd $WORKSPACE/poker/taaskingclient.node
git pull origin master

cd $WORKSPACE/poker/taaskingclient.nodeTourneyPanel
git pull origin master

cd $WORKSPACE/poker/taaskingclient.server
git pull origin master

cd $WORKSPACE/poker/taaskingclient.userDB
git pull origin master

cd $WORKSPACE/poker/taaskingclient.videoreplay
git pull origin master

echo "Changing the username in hibernate files"
sed -i 's,root,gauss,g' $WORKSPACE/poker/taaskingclient.server/TaashkingCommon/src/hibernate.cfg.xml
sed -i 's,root,gauss,g' $WORKSPACE/poker/taaskingclient.userDB/UserCommon/src/hibernate2.cfg.xml

cd $WORKSPACE/poker/
echo "Building the server jars"
gradle clean build -x test

echo "Building the flash project"
gradle -b client_build_file/build.gradle clean build

echo "Changing the mysql properties file for video replay"
sed -i 's,root,gauss,g' taaskingclient.videoreplay/WebContent/WEB-INF/classes/MySql.properties

echo "Building the video replay war"
gradle -b gradle-replay/build.gradle clean war

echo "Building ngpoker"
cd html5poker.ngpoker
grunt --force build

cd $WORKSPACE/poker/
