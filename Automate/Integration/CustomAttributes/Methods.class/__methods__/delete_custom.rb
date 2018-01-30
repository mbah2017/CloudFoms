#
# Method to write custom attribte
#
# Copyright (C) 2016, Christian Jung
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

# Dump all of root's attributes to the log
$evm.root.attributes.sort.each { |k, v| $evm.log("info", "Root:<$evm.root> Attribute - #{k}: #{v}")}

vm = $evm.root['vm']
if vm.nil?
    $evm.log("error", "Current object is not a VM")
    exit MIQ_ABORT
end

dialog_attribute_name = $evm.root["dialog_attribute_name"]

$evm.log("info", "Deleting custom attribute #{dialog_attribute_name} from VM #{vm.name} ")
# delete is done by simply storing an empty string
vm.custom_set(dialog_attribute_name, "")
