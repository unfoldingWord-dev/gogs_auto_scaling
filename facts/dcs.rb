# Fact: dcs_server_name
#
# Purpose: Returns the desired hostname for DCS
#

Facter.add(:dcs_server_name) do
  setcode do
    "SERVER_NAME"
  end
end
