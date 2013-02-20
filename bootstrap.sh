STARTDIR=$(pwd)
echo $(date) > bootstrap.log 2>&1

echo -e "\nWe need sudo access to install necessary packages.\n"
sudo echo -e "\nStarting log in ${STARTDIR}/bootstrap.log\n"

echo -e "\n#### Building development environment ####\n"

if [ -f $STARTDIR/bootstrap.log ]; then
	echo -e "\n!!!!!!!!Old development environment installation found!!!!!!!!\n"
	while true; do
		read -p "Remove old development environment packages (nukes everything, well almost...)? [Yes/n] " yn
		case $yn in
			Yes) sudo pecl uninstall mongo xdebug >> $STARTDIR/bootstrap.log 2>&1; sudo apt-get -y purge php-pear mongodb* php5* >> $STARTDIR/bootstrap.log 2>&1; sudo apt-get -y autoremove >> $STARTDIR/bootstrap.log 2>&1; sudo rm -Rf /usr/lib/php5; sudo rm -Rf /etc/php5; break;;
			[Nn]* ) break;;
			* ) echo "Please answer Yes or no.";;
		esac
	done
fi

echo -ne "Adding New Ubuntu Repositories for PHP and MongoDB..."
sudo apt-get -y install python-software-properties >> $STARTDIR/bootstrap.log 2>&1;
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 >> $STARTDIR/bootstrap.log 2>&1
sudo sh -c "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/10gen.list" >> $STARTDIR/bootstrap.log 2>&1;
sudo add-apt-repository -y ppa:ondrej/php5 >> $STARTDIR/bootstrap.log 2>&1
echo -e "DONE\n\n"

echo -ne "Updating repos..."
sudo apt-get update >> $STARTDIR/bootstrap.log 2>&1
echo -e "DONE\n\n"

echo -ne "Installing latest PHP, MongoDB (client and server), git and vim..."
sudo apt-get install -y php5-cli php-pear php5-dev mongodb-10gen git vim >> $STARTDIR/bootstrap.log 2>&1
echo -e "DONE\n\n"

echo -ne "\n\nInstalling MongoDB and Xdebug PHP extensions..."
sudo pecl install mongo xdebug >> $STARTDIR/bootstrap.log 2>&1
sudo mkdir -p /etc/php5/conf.d
if [ -f /usr/lib/php5/20100525/xdebug.so ];
then
	sudo sh -c "echo 'zend_extension=/usr/lib/php5/20100525/xdebug.so' > /etc/php5/conf.d/20-xdebug.ini"
else
	sudo sh -c "echo 'zend_extension=/usr/lib/php5/20100525+lfs/xdebug.so' > /etc/php5/conf.d/20-xdebug.ini"
fi
if [ -f /usr/lib/php5/20100525/mongo.so ];
then
	sudo sh -c "echo 'extension=mongo.so' > /etc/php5/conf.d/10-mongo.ini"
else
	sudo sh -c "echo 'extension=/usr/lib/php5/20100525+lfs/mongo.so' > /etc/php5/conf.d/10-mongo.ini"
fi
echo -e "DONE\n\n"

echo "##### ALL DONE #####\n\n"

