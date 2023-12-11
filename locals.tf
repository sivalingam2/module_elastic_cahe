locals {
  name_prefix = "${var.env}-${var.elasticcache_type}-elasticcache"
  tags        = merge(var.tags, {tf-module-name = elasticcache}, { env = var.env})
}