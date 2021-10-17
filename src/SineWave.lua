-- @4thAxis
-- 08/04/2020

local module = {}

--------------------------------------------------------------------
---------------------------  Imports  ------------------------------
--------------------------------------------------------------------

local RunService = game:GetService("RunService")

--------------------------------------------------------------------
--------------------------  Privates  ------------------------------
--------------------------------------------------------------------

local function NewSegment()
	local Part = Instance.new("Part")

	Part.Size = Vector3.new(1,1,1)
	Part.TopSurface = Enum.SurfaceType.Smooth
	Part.BottomSurface = Enum.SurfaceType.Smooth
	Part.Anchored = true
	Part.CanCollide = false
	Part.Material = Enum.Material.Neon
	Part.Color = Color3.fromRGB(255,255,255)

	return Part
end


--------------------------------------------------------------------
-------------------------  Functions  ------------------------------
--------------------------------------------------------------------


module.CreateSegments = function(HowMany, TravelDist)
	TravelDist = TravelDist or 150

	local Segments = {}
	for i = 1, HowMany or 200 do
		local Segment = NewSegment()
		local CFrameBit = CFrame.new(i*Segment.Size.x,-(TravelDist/2),0)
		Segment.CFrame = CFrameBit
		Segment.Parent = workspace

		table.insert(Segments,{
			Part = Segment,
			Amplitude = 0,
			StartingPos = CFrameBit
		})
		
		if(i%2 == 0) then
			RunService.Heartbeat:Wait()
		end
	end

	return Segments
end


module.AnimateSegments = function(Segments, TravelDist, HowMany)
	Segments = Segments or module.CreateSegments()
	TravelDist = TravelDist or 150 -- Period/Cycle
	HowMany = HowMany or 200

	local Range, Speed = 0, 0
	local Tog = false

	local Amplitude, Y
	while wait() do -- 30hz proportional frequency to the rate of growth for speed
		for i, Segment in ipairs(Segments) do
			Amplitude = Segment.Amplitude
			Y = Amplitude * math.cos(((Range*Speed)+i) * math.pi/(HowMany/2))

			Amplitude = (Amplitude+1 < (TravelDist/2) and Amplitude+1 or (TravelDist/2))
			Segment.Part.CFrame = Segment.StartingPos * CFrame.new(0, Y, 0)
			Segment.Amplitude = Amplitude
		end

		if Tog then 
			Speed = Speed < 200 and Speed + 0.5 or false
		else if Speed > -200 then 
				Speed -= 0.5 
			else 
				Tog = true 
			end 
		end

		Range += 1
	end
end


return module
