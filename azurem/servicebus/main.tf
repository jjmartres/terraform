resource "azurerm_servicebus_queue_authorization_rule" "reader" {
  for_each            = toset(local.queues_reader)
  name                = "${split("|", each.key)[1]}-reader"
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace[split("|", each.key)[0]].name
  queue_name          = azurerm_servicebus_queue.queue[each.key].name
  resource_group_name = var.resource_group_name

  listen = true
  send   = false
  manage = false
}

resource "azurerm_servicebus_queue_authorization_rule" "sender" {
  for_each            = toset(local.queues_sender)
  name                = "${split("|", each.key)[1]}-sender"
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace[split("|", each.key)[0]].name
  queue_name          = azurerm_servicebus_queue.queue[each.key].name
  resource_group_name = var.resource_group_name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_servicebus_queue_authorization_rule" "manage" {
  for_each            = toset(local.queues_manage)
  name                = "${split("|", each.key)[1]}-manage"
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace[split("|", each.key)[0]].name
  queue_name          = azurerm_servicebus_queue.queue[each.key].name
  resource_group_name = var.resource_group_name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  for_each            = var.servicebus_namespaces_queues
  name                = lookup(each.value, "custom_name", format("%s-%s-bus", local.default_name, each.key))
  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = lookup(each.value, "sku", "Basic")
  capacity = lookup(each.value, "capacity", lookup(each.value, "sku", "Basic") == "Premium" ? 1 : 0)

  tags = merge(
  var.extra_tags,
  local.default_tags
  )
}

resource "azurerm_servicebus_queue" "queue" {
  for_each            = toset(local.queues_list)
  name                = split("|", each.key)[1]
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace[split("|", each.key)[0]].name

  auto_delete_on_idle                     = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "auto_delete_on_idle", null)
  default_message_ttl                     = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "default_message_ttl", null)
  duplicate_detection_history_time_window = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "duplicate_detection_history_time_window", null)
  enable_express                          = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "enable_express", false)
  enable_partitioning                     = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "enable_partitioning", null)
  lock_duration                           = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "lock_duration", null)
  max_size_in_megabytes                   = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "max_size_in_megabytes", null)
  requires_duplicate_detection            = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "requires_duplicate_detection", null)
  requires_session                        = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "requires_session", null)
  dead_lettering_on_message_expiration    = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "dead_lettering_on_message_expiration", null)
  max_delivery_count                      = lookup(var.servicebus_namespaces_queues[split("|", each.key)[0]]["queues"][split("|", each.key)[1]], "max_delivery_count", null)
}