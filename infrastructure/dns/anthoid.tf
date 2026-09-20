locals {
  aszone    = "as197174.anthoid.eu."
  subdomain = "hosts"

  srv_records = {
    "_bird._tcp" = {
      port  = 9324
      hosts = ["bgp1", "sobeck", "darky"]
    }
    "_prometheus._tcp" = {
      port  = 9100
      hosts = ["bgp1", "sobeck", "darky"]
    }
  }

  a_records = {
    darky = "95.217.227.105"
    ns1   = "95.217.227.105"
    ns2   = "95.217.227.105"
    ns3   = "135.181.130.157"
  }

  hosts_records = {
    bgp1   = "2a06:9801:74d::2"
    sobeck = "2a06:9801:74d::3"
    darky  = "2a06:9801:74d::4"
  }

  cname_records = {
    grafana = "darky"
  }

}

resource "powerdns_zone" "anthoidorg" {
  name        = "anthoid.org."
  kind        = "native"
  nameservers = ["ns1.anthoid.org.", "ns2.anthoid.org."]
}

resource "powerdns_zone" "anthoideu" {
  name        = "anthoid.eu."
  kind        = "Native"
  nameservers = ["ns1.anthoid.eu.", "ns2.anthoid.eu."]
}

resource "powerdns_zone" "rdns" {
  name = "d.4.7.0.1.0.8.9.6.0.a.2.ip6.arpa."
  kind = "Native"
  nameservers = [
    "ns1.anthoid.eu.",
    "ns2.anthoid.eu.",
  ]
}

resource "powerdns_record" "grafana" {
  for_each = local.cname_records

  zone    = powerdns_zone.anthoideu.name
  name    = "${each.key}.anthoid.eu."
  type    = "CNAME"
  ttl     = 300
  records = ["${each.value}.anthoid.eu."]
}

resource "powerdns_record" "a" {
  for_each = local.a_records

  zone    = powerdns_zone.anthoideu.name
  name    = "${each.key}.anthoid.eu."
  type    = "A"
  ttl     = 300
  records = [each.value]
}

resource "powerdns_record" "hosts" {
  for_each = local.hosts_records

  zone    = powerdns_zone.anthoideu.name
  name    = "${each.key}.hosts.${local.aszone}"
  type    = "AAAA"
  ttl     = 300
  records = [each.value]
}

resource "powerdns_record" "srv" {
  for_each = local.srv_records

  zone = powerdns_zone.anthoideu.name
  name = "${each.key}.hosts.${local.aszone}"
  type = "SRV"
  ttl  = 300
  records = [
    for host in each.value.hosts :
    "0 0 ${each.value.port} ${host}.hosts.${local.aszone}"
  ]
}
