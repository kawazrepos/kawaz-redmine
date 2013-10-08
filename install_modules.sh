if type "puppet" > /dev/null; then
  puppet install module alup/rbenv 
  puppet install module puppetlabs/apache
  puppet install module puppetlabs/mysql
  puppet module install erwbgy/iptables
else
  echo "Please install puppet"
fi
