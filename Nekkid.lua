local nekkid
local validSlots = {1, 3, 5, 6, 7, 8, 9, 10, 16, 17}
local filledSlots = {}

local DISABLED = [=[Interface\Buttons\UI-Panel-Button-Disabled]=]
local ENABLED = [=[Interface\Buttons\UI-Panel-Button-Up]=]

local function EquipItems(button)
	for index, item in pairs(filledSlots) do
		local bag, slot = string.match(index, '(%d+)-(%d+)')
		if(bag and slot) then
			PickupContainerItem(bag, slot)
			PickupInventoryItem(item)
		end
	end

	table.wipe(filledSlots)
	button:SetNormalTexture(DISABLED)
end

local function UnequipItem(item)
	if(not GetInventoryItemLink('player', item)) then return end

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if(not GetContainerItemLink(bag, slot) and not filledSlots[bag..'-'..slot]) then
				PickupInventoryItem(item)
				PickupContainerItem(bag, slot)

				filledSlots[bag..'-'..slot] = item
				return
			end
		end
	end
end

local function OnClick(self)
	if(nekkid) then
		EquipItems(self)
	else
		self:SetNormalTexture(ENABLED)
		for _, item in pairs(validSlots) do
			if(GetInventoryItemLink('player', item)) then
				UnequipItem(item)
			end
		end
	end

	nekkid = not nekkid
end

local function onLoad(self)
	if(not UnitHasRelicSlot('player')) then
		table.insert(slots, 18)
	end

	self:SetScript('OnShow', nil)
end

local nekkid = CreateFrame('Button', nil, PaperDollFrame, 'UIPanelButtonTemplate')
nekkid:SetPoint('TOP', CharacterTrinket1Slot, 'BOTTOM', 0, -5)
nekkid:SetHeight(27)
nekkid:SetWidth(36)
nekkid:SetNormalTexture(DISABLED)
nekkid:SetScript('OnClick', OnClick)
nekkid:SetScript('OnShow', function()
	nekkid:SetScript('OnShow', nil)
	if(not UnitHasRelicSlot('player')) then
		table.insert(validSlots, 18)
	end
end)

local undress = CreateFrame('Button', nil, DressUpFrame, 'UIPanelButtonTemplate')
undress:SetPoint('RIGHT', DressUpFrameResetButton, 'LEFT')
undress:SetHeight(22)
undress:SetWidth(80)
undress:SetText('Undress')
undress:SetScript('OnClick', DressUpModel.Undress)
