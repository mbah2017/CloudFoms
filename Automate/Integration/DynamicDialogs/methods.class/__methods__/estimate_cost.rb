#
# estimate cost based on selected T-Shirt size
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

# Dump all of root's attributes to the log
$evm.root.attributes.sort.each { |k, v| $evm.log("info", "Root:<$evm.root> Attribute - #{k}: #{v}")}

dialog_tshirtsize = $evm.root["dialog_tshirtsize"]

case dialog_tshirtsize 
when "M"
    cost = "100 EUR / month"
when "L"
    cost = "200 EUR / month"
when "XL"
    cost = "500 EUR / month"
else
    cost = "select size first"
end 

dialog_field = $evm.object

dialog_field["required"] = "true"
dialog_field["protected"] = "false"
dialog_field["read_only"] = "true"
dialog_field["value"] = cost
