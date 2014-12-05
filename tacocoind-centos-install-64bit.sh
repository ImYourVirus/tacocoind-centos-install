#    Version 2
#    Written by ImYourVirus feel free to reuse it in other works for free
#    as long as these notices are kept.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
#    If you like the work I have put into this script feel free to donate
#    to the work that I have put into this script. Thanks.
#
#    BTC:  1Hq3kzVoLyg5UF8GuCKZacreRzmZPU8s16
#    LTC:  LdkMYTpzcfCYnkjaMsmBEPce4xQ2r1VPbq
#    DOGE: D6bS3eK35SfqcFbnUWUnqtKA87DkFy6Vun
#
#


# Updating the Server
yum -y update

# Step #1: Installing the Dependencies
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel wget python-devel
echo '/usr/local/lib' > /etc/ld.so.conf.d/usr_local_lib.conf && /sbin/ldconfig
echo '/usr/local/lib64' > /etc/ld.so.conf.d/usr_local_lib64.conf && /sbin/ldconfig

# Step #2: Installing OpenSSL
cd /usr/local/src
wget -qO- http://www.openssl.org/source/openssl-1.0.1f.tar.gz | tar xzv
cd openssl-1.0.1f
./config shared --prefix=/usr/local --openssldir=/usr/local/ssl
make && make install

# Step #3: Installing Boost (A Collection of C++ Libraries)
cd /usr/local/src
wget -qO- http://downloads.sourceforge.net/boost/boost_1_55_0.tar.bz2 | tar xjv
cd boost_1_55_0/
./bootstrap.sh --prefix=/usr/local
./b2 install --with=all

# Step #4: Installing BerkeleyDB (A Library for High-Performance Database Functionality)
cd /usr/local/src
wget -qO- http://download.oracle.com/berkeley-db/db-5.1.19.tar.gz | tar xzv
cd db-5.1.19/build_unix
../dist/configure --prefix=/usr/local --enable-cxx
make && make install

# Step #5: Installing tacocoind
cd /usr/local/src
ldconfig
mkdir /usr/local/src/tacocoin-master
cd /usr/local/src/tacocoin-master
wget -qO- https://api.github.com/repos/tacocoin/tacocoin/tarball/master --no-check-certificate | tar xfzv -
cd TacoCoin*/src
make -f makefile.unix USE_UPNP=- BDB_LIB_PATH=/usr/local/lib OPENSSL_LIB_PATH=/usr/local/lib64

# Step 5.1 Strip debugging symbols out of the binary and move it to a location that allows for easy execution.
strip tacocoind
cp -a tacocoind /usr/local/bin/

# Step #6: Configuring tacocoind
#   Most scrypt-based cryptocurrencies use a configuration file that is nearly identical to LiteCoin's.
#   It is generally safe to use Litecoin documentation when looking up configuration variables.
#   If you do not have a standard non-root user, then you can create one using the useradd command.
#   In this example we.re going to create a user named taco.
useradd -m -s/bin/bash taco

mkdir /home/taco/.tacocoin
chown taco:taco /home/taco/.tacocoin
cd /home/taco/.tacocoin
pass=$(tr -dc A-Za-z0-9 </dev/urandom |  head -c 30)
echo "rpcuser=tacocoinrpc
rpcpassword=$pass
daemon=1
listen=1
server=1
" >> coin.conf
chown taco:taco coin.conf

# Assume the identity of the non-privileged user, taco.
su - taco

# Now that you.ve assumed the identity of a non-privileged user, you will want to run tacocoind for the first time.
tacocoind
