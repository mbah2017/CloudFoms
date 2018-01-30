#
#  Getting MAC Address from a VM with powershell, and setting it up to a state var
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

prov = $evm.root['miq_provision']
if not prov.type.to_s.include?("ManageIQ::Providers::Microsoft::InfraManager")
    # I don't have SCVMM right now to double check, but this should make sure we only run this method on SCVMM
    $evm.log("info", "This doesn't seem to be an SCVMM provider, skipping")
    exit MIQ_OK
end 

require 'winrm'

vm = $evm.root['miq_provision'].vm

if vm.nil?
    $evm.log("error", "No VM object found in miq_provision")
    exit MIQ_ABORT
else 
    $evm.log(:info, "vm: #{vm.name}")
end 

# get the credentials to log into SCVMM from the database
winrm_host      = vm.ext_management_system.hostname
winrm_user      = vm.ext_management_system.authentication_userid
winrm_password  = vm.ext_management_system.authentication_password

port ||= 5985
endpoint = "http://#{winrm_host}:#{port}/wsman"
$evm.log(:info, "endpoint: #{endpoint}")

opts = {
  :endpoint     => endpoint,
  :user         => winrm_user,
  :password     => winrm_password,
  :disable_sspi => true
}

script = nil
script = <<SCRIPT
Get-SCVirtualMachine -Name '#{vm.name}' -VMMServer localhost | Get-SCVirtualNetworkAdapter | select MACAddress
SCRIPT

$evm.log(:info, "script: #{script}")

$evm.log(:info, 'Establishing WinRM connection')

connect_winrm = WinRM::Connection.new(opts) 
connect_winrm.shell(:powershell)

$evm.log(:info, "connect_winrm: #{connect_winrm}")

$evm.log(:info, 'Executing PowerShell: #{script}')
powershell_return = connect_winrm.shell(:powershell) do | shell |
	shell.run(script)
end

macaddress = powershell_return.stdout[/..:..:..:..:..:../]

# Process the winrm output
$evm.log(:info, "powershell_return: #{powershell_return}")

$evm.set_state_var("powershell_mac", "#{macaddress}")

if $evm.state_var_exist?("powershell_mac")
    # This shouldn´t happen we set value again with powershell_return 
    $evm.log(:info, "powershell_mac state var exists, setting it with #{macaddress}")
else
    # State var powershell_mac initialize data
    $evm.log(:info, "powershell_mac state var doesn´t exists, setting it with #{macaddress}")
end

exit MIQ_OK  
