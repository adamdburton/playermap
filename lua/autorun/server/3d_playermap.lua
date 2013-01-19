hook.Add('PlayerInitialSpawn', '3D_Playermap', function(ply)
	
	local address = string.Explode(":", ply:IPAddress())[1]
	
	if address == 'loopback' then
		address = ''
	end
	
	http.Fetch('http://freegeoip.net/json/' .. address, function(contents, size)
		
		local words = {}
		
		local lat = string.match(contents, '%"latitude%"%: %"(-?%d.?%d?)%"')
		local lon = string.match(contents, '%"longitude%"%: %"(-?%d.?%d?)%"')
		
		ply:SetNWFloat("Latitude", lat)
		ply:SetNWFloat("Longitude", lon)
		
	end)
	
end)