#
# revert_snapshot.rb
# Description: revert to the selected snapshot
#
# Copyright (C) 2017, Christian Jung
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'rest-client'
require 'json'
require 'openssl'

def call_rhevm(ext_mgt_system, uri, type=:get, payload=nil)
  params = {
    :method => type,
    :url => "https://#{ext_mgt_system[:hostname]}#{uri}",
    :user => ext_mgt_system.authentication_userid,
    :password => ext_mgt_system.authentication_password,
    :headers => { :accept => :xml, :content_type => :xml },
    :verify_ssl => OpenSSL::SSL::VERIFY_NONE
  }
  params[:payload] = payload if payload
  return JSON.parse(RestClient::Request.new(params).execute)
end

$evm.log("info", "Begin Automate Method")

ext_mgt_system = $evm.root['vm'].ext_management_system

$evm.log("info", "Got ext_management_system #{ext_mgt_system.name}")

vm=$evm.root["vm"]
vmuuid=vm["uid_ems"]
$evm.log("info", "RHEV UUID: #{vmuuid}")

snapshotid=$evm.root["dialog_snapshot_name"]

$evm.log("info", "Sending POST to restore action URL /api/vms/#{vmuuid}/snapshots/#{snapshotid}/restore")

payload = "<action/>"

create_snapshot=call_rhevm(ext_mgt_system, "/api/vms/#{vmuuid}/snapshots/#{snapshotid}/restore", :post, payload)

$evm.log("info", "End Automate Method")
