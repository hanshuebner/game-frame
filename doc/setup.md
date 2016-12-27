# Enable SPI and IR driver

Edit /boot/config.txt and uncomment

dtparam=spi=on
dtoverlay=lirc-rpi,gpio_in_pull=up

# Install prerequisite software

sudo apt-get install -y lirc gifsicle subversion git

# Configure lircd

sudo cp lirc/* /etc/lirc

# Make user part of the spi group

sudo usermod -G spi $USER

# Reboot

# Install CCL

svn co http://svn.clozure.com/publicsvn/openmcl/release/1.11/linuxarm/ccl

Create driver script in ~/bin:

--
#!/bin/sh

exec $HOME/ccl/armcl "$@"
--

Allow ccl to bind port 80:

sudo /sbin/setcap 'cap_net_bind_service=+ep' ~/ccl/armcl

# Install quicklisp

ccl -n -l http://beta.quicklisp.org/quicklisp.lisp -e '(quicklisp-quickstart:install)' -e '(ql:quickload :buildapp)'

# Install buildapp