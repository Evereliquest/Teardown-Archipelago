--positions the player in the couch for the end cutscene.

function init()
	--find the ik setup 
	playercouch = FindBody("couchscene")    
	local couchTransform = GetBodyTransform(playercouch)
	--register the ik locations
	SetPlayerRigLocationLocalTransform(playercouch, "ik_head"	 , TransformToLocalTransform(couchTransform, GetLocationTransform(FindLocation("ik_head"))))
	SetPlayerRigLocationLocalTransform(playercouch, "ik_foot_l"	 , TransformToLocalTransform(couchTransform, GetLocationTransform(FindLocation("ik_foot_l"))))
	SetPlayerRigLocationLocalTransform(playercouch, "ik_foot_r"	 , TransformToLocalTransform(couchTransform, GetLocationTransform(FindLocation("ik_foot_r"))))
	SetPlayerRigLocationLocalTransform(playercouch, "ik_hand_l"	 , TransformToLocalTransform(couchTransform, GetLocationTransform(FindLocation("ik_hand_l"))))
	SetPlayerRigLocationLocalTransform(playercouch, "ik_hand_r"	 , TransformToLocalTransform(couchTransform, GetLocationTransform(FindLocation("ik_hand_r"))))
	SetPlayerRigLocationLocalTransform(playercouch, "player_seat", TransformToLocalTransform(couchTransform, GetLocationTransform(FindLocation("player_seat"))))
end

function tick(dt)
	--set the player to the ik setup each frame
	SetPlayerRigTransform(playercouch, GetBodyTransform(playercouch))
end