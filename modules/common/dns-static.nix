{ ... }:
let
  asHosts = "hosts.as197174";
  srv = port: hosts: map (h: "0 0 ${toString port} ${h}.${asHosts}.anthoid.eu.") hosts;
in
{
  erethon.dns.records = {
    "_prometheus._tcp.${asHosts}".SRV.values = srv 9100 [ "bgp1" ];
    "_bird._tcp.${asHosts}".SRV.values = srv 9324 [ "bgp1" ];
  };
}
