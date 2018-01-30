#
# dynamic dialog to return list of custom attributes
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

list = {}

vm.custom_keys.each { |key| 
    value = vm.custom_get(key)
    $evm.log("info", "Found custom key #{key} with value #{value}")
    # we want to present the list of keys, not their values, to the user
    list[key]=key 
}

dialog_field = $evm.object
dialog_field["sort_by"]="description"
dialog_field["sort_order"]="ascending"
dialog_field["data_type"]="string"
dialog_field["required"]="true"

dialog_field["values"]=list
