local html = [[
<html>
	<head>
		<style type="text/css">
			html, body, #map {
				margin: 0; padding: 0; height: 100%;
			}
		</style>
		<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript">
			var map;
			var bounds;
			
			function initialize()
			{
				var mapOptions = {
					zoom: 2,
					center: new google.maps.LatLng(35, 0),
					streetViewControl: false,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};
				
				map = new google.maps.Map(document.getElementById("map"), mapOptions);
				bounds = new google.maps.LatLngBounds();
			}
			
			function addMarker(latitude, longitude)
			{
				var point = new google.maps.LatLng(parseFloat(latitude), parseFloat(longitude));
				bounds.extend(point);
				
				var marker = new google.maps.Marker({
					position: point,
					map: map,
					animation: google.maps.Animation.DROP
				});
			}
			
			google.maps.event.addDomListener(window, "load", initialize);
		</script>
	</head>
	<body>
		<div id="map"></div>
	</body>
</html>
]]

include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize() 
	self.Map = vgui.Create("HTML")
	self.Map:SetPos(0, 0)
	self.Map:SetSize(963, 575)
	
	self.Map:SetVisible(true)
	
	self.Map:SetPaintedManually(true)
	
	self.Map:SetHTML(html)
	
	self:UpdateMarkers()
	
	timer.Create(self:EntIndex() .. "_map", 60, 0, function() self:UpdateMarkers() end)
end

function ENT:OnRemove()
	timer.Destroy(self:EntIndex() .. "_map")
end

function ENT:Draw()
	self:DrawModel()
	
	local pos = self:GetPos() + (self:GetUp() * 2) + (self:GetRight() * -178) + (self:GetForward() * 106)
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Up(), -90)
	
	self.Map:SetPaintedManually(false)
	
	cam.Start3D2D(pos, ang, 0.370)
		self.Map:PaintManual()
	cam.End3D2D()
	
	self.Map:SetPaintedManually(true)
end

function ENT:UpdateMarkers()
	self.Map:Refresh()
	
	timer.Simple(2, function()
		for _, ply in pairs(player.GetAll()) do
			local lat = ply:GetNWFloat("Latitude", 0)
			local lon = ply:GetNWFloat("Longitude", 0)
			
			if lat != 0 and lon != 0	then
				self.Map:RunJavascript('addMarker(' .. lat .. ', ' .. lon .. ')')
			end
		end
	end)
end