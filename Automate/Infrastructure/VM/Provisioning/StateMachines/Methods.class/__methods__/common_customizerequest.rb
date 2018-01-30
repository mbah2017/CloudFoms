#
# Description: This method is used to Customize the RHEV, RHEV PXE, and RHEV ISO Provisioning Request
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

# Get provisioning object
prov = $evm.root["miq_provision"]

$evm.log("info", "Disabling VM Autostart")
prov.set_option(:vm_auto_start,[false,0])

dialog_vmname = prov.get_option(:dialog_vmname)
if not dialog_vmname.nil?
  $evm.log("info", "Setting VM name to: #{dialog_vmname}")
  prov.set_option(:vm_target_name,dialog_vmname)
end

dialog_fqdn = prov.get_option(:dialog_fqdn)
if not dialog_fqdn.nil?
  $evm.log("info", "Setting FQDN to: #{dialog_fqdn}")
  prov.set_option(:vm_target_hostname,dialog_fqdn)
end

$evm.log("info", "Provisioning ID:<#{prov.id}> Provision Request ID:<#{prov.miq_provision_request.id}> Provision Type: <#{prov.provision_type}>")

# get user specified options from dialog
tshirtsize = prov.get_option(:dialog_tshirtsize)
vm_memory = prov.get_option(:dialog_memory)
vm_cores = prov.get_option(:dialog_cores)

case tshirtsize
when "M"
    prov.set_option(:vm_memory,4096)
    prov.set_option(:cores_per_socket,2)
    $evm.log("info", "T-Shirt Size Medium: 2 Cores, 4 GB RAM")
when "L"
    prov.set_option(:vm_memory,4096)
    prov.set_option(:cores_per_socket,4)
    $evm.log("info", "T-Shirt Size Large: 4 Cores, 4 GB RAM")
when "XL"
    prov.set_option(:vm_memory,8192) 
    prov.set_option(:cores_per_socket,4)
    $evm.log("info", "T-Shirt Size Extra Large: 4 Cores, 8 GB RAM")
else 
    $evm.log("warn", "Unkonwn T-Shirt Size!")
end

if vm_memory.to_i > 0
    prov.set_option(:vm_memory,vm_memory.to_i * 1024)
    $evm.log("info", "Memory Override: #{vm_memory}")
end
if vm_cores.to_i > 0
    prov.set_option(:cores_per_socket,vm_cores.to_i)
    $evm.log("info", "Cores Override: #{vm_cores}")
end

# this is just a fail safe to make sure we have only one socket
prov.set_option(:number_of_sockets, 1)

prov.attributes.sort.each { |k,v| $evm.log("info", "Prov attributes: #{v}: #{k}") }
