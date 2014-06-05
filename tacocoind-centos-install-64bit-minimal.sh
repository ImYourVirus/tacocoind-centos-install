# Step #1: Installing tacocoind
cd /usr/local/src
ldconfig
mkdir /usr/local/src/tacocoin-master
cd /usr/local/src/tacocoin-master
wget -qO- https://api.github.com/repos/tacocoin/tacocoin/tarball/master --no-check-certificate | tar xfzv -
cd TacoCoin*/src
make -f makefile.unix USE_UPNP=- BDB_LIB_PATH=/usr/local/lib OPENSSL_LIB_PATH=/usr/local/lib64

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
