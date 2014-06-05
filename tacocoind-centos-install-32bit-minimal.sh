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


# Step #1: Installing tacocoind
cd /usr/local/src
ldconfig
mkdir /usr/local/src/tacocoin-master
cd /usr/local/src/tacocoin-master
wget -qO- https://api.github.com/repos/tacocoin/tacocoin/tarball/master --no-check-certificate | tar xfzv -
cd TacoCoin*/src
make -f makefile.unix USE_UPNP=- BDB_LIB_PATH=/usr/local/lib OPENSSL_LIB_PATH=/usr/local/lib

# Step 1.1 Strip debugging symbols out of the binary and move it to a location that allows for easy execution.
strip tacocoind
cp -a tacocoind /usr/local/bin/

# Step #2: Configuring tacocoind
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
addnode=taco.mineempire.com
daemon=1
listen=1
server=1
" >> coin.conf
chown taco:taco coin.conf

# Assume the identity of the non-privileged user, taco.
su - taco

# Now that you.ve assumed the identity of a non-privileged user, you will want to run tacocoind for the first time.
tacocoind
