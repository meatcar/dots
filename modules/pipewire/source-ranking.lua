-- Default audio source order, best first. Matches node.name prefixes.
-- A source the user picks stays default while it is connected.
local ranked_sources = {
  "alsa_input.usb-DJI_Technology_Co.__Ltd._Wireless_Mic_Rx",
  "alsa_input.usb-Insta360_Insta360_Link_2",
  "alsa_input.pci-0000_c3_00.6.HiFi__Mic2__source",
  "alsa_input.usb-046d_Brio_101",
  "alsa_input.pci-0000_c3_00.6.HiFi__Mic1__source",
  "alsa_input.usb-Generic_USB_Audio",
  "alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device",
}

local function rank (name)
  for i, prefix in ipairs (ranked_sources) do
    if name:sub (1, #prefix) == prefix then
      return i
    end
  end
end

local function configured_source (event)
  local metadata = event:get_source ():call ("get-object-manager", "metadata"):lookup {
    Constraint { "metadata.name", "=", "default" },
  }
  local json = metadata and metadata:find (0, "default.configured.audio.source")
  return json and Json.Raw (json):parse ().name
end

SimpleEventHook {
  name = "default-nodes/find-ranked-source",
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
    if event:get_properties () ["default-node.type"] ~= "audio.source" then
      return
    end

    local available_nodes = event:get_data ("available-nodes")
    available_nodes = available_nodes and available_nodes:parse ()
    if not available_nodes then
      return
    end

    local configured = configured_source (event)
    local best, best_rank
    for _, node_properties in ipairs (available_nodes) do
      local name = node_properties ["node.name"]
      if name == configured then
        return
      end
      local r = rank (name)
      if r and (not best_rank or r < best_rank) then
        best, best_rank = name, r
      end
    end

    if best then
      event:set_data ("selected-node", best)
    end
  end,
}:register ()
