#!/usr/bin/ruby

require 'socket'
require 'yaml'

sh_file = File.expand_path('../raspi_temp.sh', __FILE__)
raspi_temp = `sh #{sh_file}`

d = <<JSON
{
  "request": "sender data",
  "data": [{
    "host": "RasPi3",
    "key": "room_temp",
    "value": "#{raspi_temp}"
  }]
}
JSON

cnf = YAML.load_file(File.expand_path('../cnf.yml', __FILE__))
ip = cnf['zabbix_ip']
cn = TCPSocket.open(ip, 10051)
cn.puts(d)
cn.close()
