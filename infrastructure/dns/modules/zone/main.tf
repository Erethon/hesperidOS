variable "zone" { type = string }
variable "nameservers" { type = list(string) }
variable "a_records" {
  type    = map(string)
  default = {}
}
variable "aaaa_records" {
  type    = map(string)
  default = {}
}

resource "powerdns_zone" "this" {
  name         = var.zone
  kind         = "Master"
  nameservers  = var.nameservers
  soa_edit_api = "EPOCH"
}

resource "powerdns_record" "soa" {
  zone    = powerdns_zone.this.name
  name    = powerdns_zone.this.name
  type    = "SOA"
  ttl     = 3600
  records = ["ns1.anthoid.eu. hostmaster.anthoid.eu. 0 10800 3600 604800 3600"]

  lifecycle {
    ignore_changes = [records]
  }
}

resource "powerdns_record" "a" {
  for_each = var.a_records

  zone    = powerdns_zone.this.name
  name    = each.key == "@" ? var.zone : "${each.key}.${var.zone}"
  type    = "A"
  ttl     = 60
  records = [each.value]
}

resource "powerdns_record" "aaaa" {
  for_each = var.aaaa_records

  zone    = powerdns_zone.this.name
  name    = each.key == "@" ? var.zone : "${each.key}.${var.zone}"
  type    = "AAAA"
  ttl     = 60
  records = [each.value]
}
