/****************************************************\
Simple Addon to get AtmosGlobal (weather addon) vars
and send it to outputs for usage with Wiremod.

Created by: NickMaps
Creator of Atmos: Looter

Atmos is under development and will contain more
Global vars in the future.

TODO:
There's no checks (AFAIK) if Atmos is installed
If this addon runs wihout atmos it will Spams
Console Errors.
\****************************************************/

AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.PrintName       = "Wire Atmos Data"
ENT.Author          = "NickMaps"
ENT.Purpose         = "It Gets Current Atmos Data"
ENT.Instructions    = "Outputs data for gates and E2"
ENT.Category        = "Editors"

ENT.Spawnable			= true
ENT.AdminOnly			= false

//Spawns the entity
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( ClassName )
     ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
     ent:Spawn()
     ent:Activate()
	
	return ent
	
end

//Initialize the entity with the below properties
//Uses the model gmod use for the Sky Editors with a custom material
function ENT:Initialize()

	if ( CLIENT ) then return end
	
	self:SetModel( "models/MaxOfS2D/cube_tool.mdl" )
	self:SetMaterial( "gmod/atmos_data" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)
	
	//Checks if Wiremod Exists then creates the outputs
	if WireAddon then
		self.Outputs = Wire_CreateOutputs(self,  {"Hours", "Minutes", "IsStorming?", "IsSnowing?"})
	end
	
	local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
		end
	
end

//Disable the arrow in the gmod SkyEditor model by setting the bodygroup
function ENT:EnableForwardArrow()

	self:SetBodygroup( 1, 1 )

end

//This function gets AtmosGlobal var "GetTime" and floor it for a individual output for the hours
function AtmosTimeHours()
	local hrs = AtmosGlobal:GetTime();
	local hours = math.floor( hrs );
	if (hrs != nil) then
		return hours
	else
		return
	end
end

//Same as above but convert it to a individual output for minutes
function AtmosTimeMinutes()
	local hrs = AtmosGlobal:GetTime();
	local hours = math.floor( hrs );
	local minutes = ( hrs - hours ) * 60;
	if (hrs != nil) then
		math.floor( minutes )
		return minutes
	else
		return
	end
end

//This function gets the AtmosGlobar var "GetStorming" that checks if its storming (true) or not (false) and outputs it (0,1)
function AtmosStorming()
	local storming = AtmosGlobal:GetStorming();
		if(storming == false ) then
		return 0
	else
		return 1
	end
end

function AtmosSnowing()
	local snowing = AtmosGlobal:GetSnowing();
	if(snowing == false ) then
		return 0
	else
		return 1
	end
end

//Updates the outputs
if ( SERVER ) then

	function ENT:Think()
		local hrs = AtmosTimeHours()
		WireLib.TriggerOutput( self, "Hours", hrs)

		local mins = AtmosTimeMinutes()
		WireLib.TriggerOutput( self, "Minutes", mins)
		
		local storms = AtmosStorming()
		WireLib.TriggerOutput( self, "IsStorming?", storms)

		local snow = AtmosSnowing()
		WireLib.TriggerOutput( self, "IsSnowing?", snow)

	end

end