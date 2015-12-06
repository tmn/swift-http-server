sudo apt-get update
sudo apt-get install -y wget curl clang libicu-dev git

echo "=== import GPG"
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys '7463 A81A 4B2E EA1B 551F FBCF D441 C977 412B 37AD 1BE1 E29A 084C B305 F397 D62A 9F59 7F4D 21A5 6D5F'

echo "=== refresh keys"
gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

echo "=== download Swift"
mkdir dev/
cd dev/
# wget https://swift.org/builds/ubuntu1404/swift-2.2-SNAPSHOT-2015-12-01-b/swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04.tar.gz
tar xzf swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04.tar.gz
echo 'export PATH=/home/vagrant/dev/swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04/usr/bin:"${PATH}"' >> /home/vagrant/.bashrc
