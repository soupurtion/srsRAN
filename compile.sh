sudo apt-get install libzmq3-dev -y
sudo apt-get install libfftw3-dev libsctp-dev libmbedtls-dev -y
echo "\n\n\nBuilding ZeroMQ libzmq..."
cd libzmq
./autogen.sh
./configure
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..

echo "\n\n\nBuilding ZeroMQ csmq..."
cd czmq
./autogen.sh
./configure
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..

echo "\n\n\nBuilding srsRAN..."
rm -rf build
mkdir build
cd build
cmake ../
make -j$(nproc)
cd ..

echo "\n\n\nDone!"