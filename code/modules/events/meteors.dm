/datum/event/meteor_wave
	startWhen		= 86
	endWhen			= 9999//safety value, will be set during ticks

	var/wave_delay  = 13//Note, wave delay is in procs. actual time is equal to wave_delay * 2.1
	var/min_waves 	= 11
	var/max_waves 	= 16
	var/min_meteors = 1
	var/max_meteors = 2
	var/duration = 340//Total duration in seconds that the storm will last after it starts

	var/downed_ship = FALSE

	var/waves		= 8
	var/next_wave 	= 86
	ic_name = "a meteor storm"

/datum/event/meteor_wave/setup()
	startWhen += rand(-15,15)//slightly randomised start time
	waves = rand(min_waves,max_waves)
	next_wave = startWhen
	wave_delay = round(((duration - 10)/waves)/2.1, 1)

/datum/event/meteor_wave/announce()
	command_announcement.Announce("A heavy meteor storm has been detected on collision course with the station. Estimated three minutes until impact, please activate station shields, and seek shelter in the central ring.", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/event/meteor_wave/start()
	command_announcement.Announce("Contact with meteor wave imminent, all hands brace for impact.", "Meteor Alert")

/datum/event/meteor_wave/tick()
	if(activeFor >= next_wave)
		var/amount = rand(min_meteors,max_meteors)

		event_meteor_wave(amount)
		next_wave += wave_delay
		waves--
		if(waves <= 0)
			endWhen = activeFor + 1
		else
			endWhen = next_wave + wave_delay

/datum/event/meteor_wave/end()
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce("The station has survived the meteor storm, it is now safe to commence repairs.", "Meteor Alert")

/datum/event/meteor_wave/shower
	wave_delay  = 6
	min_waves 	= 7
	max_waves 	= 9
	min_meteors = 0
	max_meteors = 1
	duration = 180 //Total duration in seconds that the storm will last after it starts

	waves		= 4//this is randomised
	next_wave 	= 86

/datum/event/meteor_wave/shower/announce()
	command_announcement.Announce("A meteor shower is approaching the station, estimated contact in three minutes. Crew are recommended to stay away from the outer areas of the station.", "Meteor Alert")

/datum/event/meteor_wave/shower/start()
	command_announcement.Announce("Meteors have reached the station. Please stay away from outer areas until the shower has passed.", "Meteor Alert")


/datum/event/meteor_wave/shower/end()
	spawn(100)
		command_announcement.Announce("The station has cleared the meteor shower, please return to your stations.", "Meteor Alert")


//An event specific version of the meteor wave proc, to bypass the delays
/datum/event/meteor_wave/proc/event_meteor_wave(var/number = meteors_in_wave)
	for(var/i = 0 to number)
		spawn(rand(10, 80))
			spawn_meteor(downed_ship)

/datum/event/meteor_wave/downed_ship
	downed_ship = TRUE
	ic_name = "a downed vessel"

/datum/event/meteor_wave/downed_ship/announce()
	command_announcement.Announce("The NDV Icarus reports that it has downed an unknown vessel that was approaching your station. Prepare for debris impact - please evacuate the surface level if needed.", "Ship Debris Alert", new_sound = 'sound/AI/unknownvesseldowned.ogg')

/datum/event/meteor_wave/downed_ship/start()
	command_announcement.Announce("Ship debris colliding now, all hands brace for impact.", "Ship Debris Alert")

/datum/event/meteor_wave/downed_ship/end()
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce("The last of the ship debris has hit or passed by the station, it is now safe to commence repairs.", "Ship Debris Alert")