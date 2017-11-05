#!/usr/bin/ruby

require 'yaml'
require 'net/http'
require 'uri'
require 'json'
require 'socket'
require 'slack/incoming/webhooks'

def buildSendData(host, key, value)
    return <<-JSON
{
  "request": "sender data",
  "data": [{
    "host": "#{host}",
    "key": "#{key}",
    "value": "#{value}"
  }]
}
    JSON
end

cnf = YAML.load_file(File.expand_path('../cnf.yml', __FILE__))
zabbix_ip = cnf['zabbix_ip']

cnf['nasne'].each do |nasne|
  # p nasne['name']

  ep = {
    hdd_list:  URI.parse('http://' + nasne['ip'] + ':64210/status/HDDListGet'),
    hdd0_info: URI.parse('http://' + nasne['ip'] + ':64210/status/HDDInfoGet?id=0'),
    hdd1_info: URI.parse('http://' + nasne['ip'] + ':64210/status/HDDInfoGet?id=1'),
    rec_list:  URI.parse('http://' + nasne['ip'] + ':64220/recorded/titleListGet?searchCriteria=0&filter=0&startingIndex=0&requestedCount=0&sortCriteria=0&withDescriptionLong=0&withUserData=0'),
  }

  begin
    hdd_list  = JSON.parse(Net::HTTP.get(ep[:hdd_list]))
    hdd0_info = JSON.parse(Net::HTTP.get(ep[:hdd0_info]))
    hdd1_info = JSON.parse(Net::HTTP.get(ep[:hdd1_info]))
    rec_list  = JSON.parse(Net::HTTP.get(ep[:rec_list]))
  rescue => e
    slack = Slack::Incoming::Webhooks.new cnf['slack_webhook_url']
    slack.post '@channel ERROR: ' + e.message + "\n" + e.backtrace.to_s
    next
  end

  data = []
  data << buildSendData(nasne['name'], 'hdd_count', hdd_list['HDD'][0]['mountStatus'] + hdd_list['HDD'][1]['mountStatus'])
  data << buildSendData(nasne['name'], 'hdd0_free', hdd0_info['HDD']['freeVolumeSize'])
  data << buildSendData(nasne['name'], 'hdd0_used', hdd0_info['HDD']['usedVolumeSize'])
  data << buildSendData(nasne['name'], 'hdd1_free', hdd1_info['HDD']['freeVolumeSize'])
  data << buildSendData(nasne['name'], 'hdd1_used', hdd1_info['HDD']['usedVolumeSize'])
  data << buildSendData(nasne['name'], 'rec_count', rec_list['totalMatches'])

  data.each do |d|
    cn = TCPSocket.open(zabbix_ip, 10051)
    cn.puts(d)
    cn.close()
  end
end
