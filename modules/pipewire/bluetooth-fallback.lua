local fallback_sinks = {
  "egpu-tv",
  "alsa_output.pci-0000_c3_00.6.HiFi__Speaker__sink",
}

SimpleEventHook {
  name = "default-nodes/find-bluetooth-fallback",
  after = {
    "default-nodes/find-selected-default-node",
    "default-nodes/find-stored-default-node",
    "default-nodes/find-best-default-node",
  },
  before = { "default-nodes/apply-default-node" },
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "select-default-node" },
    },
  },
  execute = function (event)
    local event_properties = event:get_properties ()
    if event_properties ["default-node.type"] ~= "audio.sink" then
      return
    end

    local source = event:get_source ()
    local metadata_manager = source:call ("get-object-manager", "metadata")
    local metadata = metadata_manager:lookup {
      Constraint { "metadata.name", "=", "default" },
    }
    local configured_json = metadata:find (0, "default.configured.audio.sink")
    if not configured_json then
      return
    end

    local configured = Json.Raw (configured_json):parse ().name
    if not configured:match ("^bluez_output%.") then
      return
    end

    local available_nodes = event:get_data ("available-nodes")
    available_nodes = available_nodes and available_nodes:parse ()
    if not available_nodes then
      return
    end

    for _, node_properties in ipairs (available_nodes) do
      if node_properties ["node.name"] == configured then
        return
      end
    end

    for _, fallback in ipairs (fallback_sinks) do
      for _, node_properties in ipairs (available_nodes) do
        if node_properties ["node.name"] == fallback then
          event:set_data ("selected-node", fallback)
          return
        end
      end
    end
  end,
}:register ()
