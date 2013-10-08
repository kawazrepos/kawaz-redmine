if type "puppet" > /dev/null; then
  puppet module install alup/rbenv 
  puppet module install puppetlabs/apache
  puppet module install puppetlabs/mysql
  puppet module install erwbgy/iptables
else
  echo "Please install puppet"
fi
