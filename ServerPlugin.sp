#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR ""
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

/*
* ENUMS
*/

enum ServerMode {
	Default,
	Retake,
	Matchmaking,
	Trening
};

ServerMode SERVER_MODE = Default; 

/*
* PLUGIN HANDLER
*/

public Plugin myinfo = 
{
	name = "",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO)
	{
		SetFailState("This plugin is for CSGO only.");	
	}
	
	
}

/*
* Server mode hendlers
*/

public void RunDefaultMode(){
	SERVER_MODE = Default;
}

public void RunRetakeMode(){
	SERVER_MODE = Retake;
}

public void RunMatchMode(){
	SERVER_MODE = Matchmaking;
}

public void RunTreningMode(){
	SERVER_MODE = Trening;
}


/*
* METHODS
*/


public bool IsClientValid(int client)
{
	if (client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client))
		return true;
	return false;
}

public bool IsClientTeamValid(int client)
{
	int ClientTeam = GetClientTeam(client);
	if (ClientTeam != CS_TEAM_CT && ClientTeam != CS_TEAM_T)
	{
		return false;
	}
	return true;
}

/*
* Matach methods
*/



/*
* Configs TODO
*/

public Action ConfigDefault(int client, int cfg)
{
	ServerCommand("mp_ct_default_secondary weapon_hkp2000");
	ServerCommand("mp_t_default_secondary weapon_glock");
	ServerCommand("ammo_grenade_limit_default 0");
	ServerCommand("ammo_grenade_limit_flashbang 0");
	ServerCommand("ammo_grenade_limit_total 0");
	ServerCommand("bot_quota 0");
	ServerCommand("cash_player_bomb_defused 300");
	ServerCommand("cash_player_bomb_planted 300");
	ServerCommand("cash_player_damage_hostage -30");
	ServerCommand("cash_player_interact_with_hostage 150");
	ServerCommand("cash_player_killed_enemy_default 300");
	ServerCommand("cash_player_killed_enemy_factor 1");
	ServerCommand("cash_player_killed_hostage -1000");
	ServerCommand("cash_player_killed_teammate -300");
	ServerCommand("cash_player_rescued_hostage 1000");
	ServerCommand("cash_team_elimination_bomb_map 3250");
	ServerCommand("cash_team_hostage_alive 150");
	ServerCommand("cash_team_hostage_interaction 150");
	ServerCommand("cash_team_loser_bonus 1400");
	ServerCommand("cash_team_loser_bonus_consecutive_rounds 500");
	ServerCommand("cash_team_planted_bomb_but_defused 800");
	ServerCommand("cash_team_rescued_hostage 750");
	ServerCommand("cash_team_terrorist_win_bomb 3500");
	ServerCommand("cash_team_win_by_defusing_bomb 3500");
	ServerCommand("cash_team_win_by_hostage_rescue 3500");
	ServerCommand("cash_player_get_killed 0");
	ServerCommand("cash_player_respawn_amount 0");
	ServerCommand("cash_team_elimination_hostage_map_ct 2000");
	ServerCommand("cash_team_elimination_hostage_map_t 1000");
	ServerCommand("cash_team_win_by_time_running_out_bomb 3250");
	ServerCommand("cash_team_win_by_time_running_out_hostage 3250");
	ServerCommand("ff_damage_reduction_grenade 0.85");
	ServerCommand("ff_damage_reduction_bullets 0.33");
	ServerCommand("ff_damage_reduction_other 0.4");
	ServerCommand("ff_damage_reduction_grenade_self 1");
	ServerCommand("mp_afterroundmoney 0");
	ServerCommand("mp_autokick 0");
	ServerCommand("mp_autoteambalance 0");
	ServerCommand("mp_buytime 15");
	ServerCommand("mp_c4timer 35");
	ServerCommand("mp_death_drop_defuser 1");
	ServerCommand("mp_death_drop_grenade 2");
	ServerCommand("mp_death_drop_gun 1");
	ServerCommand("mp_defuser_allocation 0");
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_forcecamera 1");
	ServerCommand("mp_force_pick_time 160");
	ServerCommand("mp_free_armor 0");
	ServerCommand("mp_freezetime 6");
	ServerCommand("mp_friendlyfire 0");
	ServerCommand("mp_halftime 0");
	ServerCommand("mp_halftime_duration 0");
	ServerCommand("mp_join_grace_time 30");
	ServerCommand("mp_limitteams 0");
	ServerCommand("mp_logdetail 3");
	ServerCommand("mp_match_can_clinch 1");
	ServerCommand("mp_match_end_restart 1");
	ServerCommand("mp_maxmoney 9999999");
	ServerCommand("mp_maxrounds 5");
	ServerCommand("mp_molotovusedelay 0");
	ServerCommand("mp_overtime_enable 1");
	ServerCommand("mp_overtime_maxrounds 10");
	ServerCommand("mp_overtime_startmoney 16000");
	ServerCommand("mp_playercashawards 1");
	ServerCommand("mp_playerid 0");
	ServerCommand("mp_playerid_delay 0.5");
	ServerCommand("mp_playerid_hold 0.25");
	ServerCommand("mp_round_restart_delay 5");
	ServerCommand("mp_roundtime 10");
	ServerCommand("mp_roundtime_defuse 10");
	ServerCommand("mp_solid_teammates 1");
	ServerCommand("mp_startmoney 9999999");
	ServerCommand("mp_teamcashawards 1");
	ServerCommand("mp_timelimit 0");
	ServerCommand("mp_tkpunish 0");
	ServerCommand("mp_warmuptime 36000");
	ServerCommand("mp_weapons_allow_map_placed 1");
	ServerCommand("mp_weapons_allow_zeus 1");
	ServerCommand("mp_win_panel_display_time 15");
	ServerCommand("spec_freeze_time 5.0");
	ServerCommand("spec_freeze_panel_extended_time 0");
	ServerCommand("sv_accelerate 5.5");
	ServerCommand("sv_stopspeed 80");
	ServerCommand("sv_allow_votes 0");
	ServerCommand("sv_allow_wait_command 0");
	ServerCommand("sv_alltalk 1");
	ServerCommand("sv_alternateticks 0");
	ServerCommand("sv_cheats 0");
	ServerCommand("sv_clockcorrection_msecs 15");
	ServerCommand("sv_consistency 0");
	ServerCommand("sv_contact 0");
	ServerCommand("sv_damage_print_enable 0");
	ServerCommand("sv_dc_friends_reqd 0");
	ServerCommand("sv_deadtalk 1");
	ServerCommand("sv_forcepreload 0");
	ServerCommand("sv_friction 5.2");
	ServerCommand("sv_full_alltalk 0");
	ServerCommand("sv_gameinstructor_disable 1");
	ServerCommand("sv_ignoregrenaderadio 0");
	ServerCommand("sv_kick_players_with_cooldown 0");
	ServerCommand("sv_kick_ban_duration 0 ");
	ServerCommand("sv_lan 0");
	ServerCommand("sv_log_onefile 0");
	ServerCommand("sv_logbans 1");
	ServerCommand("sv_logecho 1");
	ServerCommand("sv_logfile 1");
	ServerCommand("sv_logflush 0");
	ServerCommand("sv_logsdir logfiles");
	ServerCommand("sv_maxrate 0");
	ServerCommand("sv_mincmdrate 30");
	ServerCommand("sv_minrate 20000");
	ServerCommand("sv_competitive_minspec 1");
	ServerCommand("sv_competitive_official_5v5 1");
	ServerCommand("sv_pausable 1");
	ServerCommand("sv_pure 1");
	ServerCommand("sv_pure_kick_clients 1");
	ServerCommand("sv_pure_trace 0");
	ServerCommand("sv_spawn_afk_bomb_drop_time 30");
	ServerCommand("sv_steamgroup_exclusive 0");
	ServerCommand("sv_voiceenable 1");
	ServerCommand("mp_restartgame 1");
	ServerCommand("mp_warmup_start");
	
	return Plugin_Handled;
}

public Action ConfigMatch(int client, int cfg)
{
	ServerCommand("mp_ct_default_secondary weapon_hkp2000");
	ServerCommand("mp_t_default_secondary weapon_glock");
	ServerCommand("mp_give_player_c4 1");
	ServerCommand("ammo_grenade_limit_default 1");
	ServerCommand("ammo_grenade_limit_flashbang 2");
	ServerCommand("ammo_grenade_limit_total 4");
	ServerCommand("bot_quota 0");
	ServerCommand("cash_player_bomb_defused 300");
	ServerCommand("cash_player_bomb_planted 300");
	ServerCommand("cash_player_damage_hostage -30");
	ServerCommand("cash_player_interact_with_hostage 150");
	ServerCommand("cash_player_killed_enemy_default 300");
	ServerCommand("cash_player_killed_enemy_factor 1");
	ServerCommand("cash_player_killed_hostage -1000");
	ServerCommand("cash_player_killed_teammate -300");
	ServerCommand("cash_player_rescued_hostage 1000");
	ServerCommand("cash_team_elimination_bomb_map 3250");
	ServerCommand("cash_team_hostage_alive 150");
	ServerCommand("cash_team_hostage_interaction 150");
	ServerCommand("cash_team_loser_bonus 1400");
	ServerCommand("cash_team_loser_bonus_consecutive_rounds 500");
	ServerCommand("cash_team_planted_bomb_but_defused 800");
	ServerCommand("cash_team_rescued_hostage 750");
	ServerCommand("cash_team_terrorist_win_bomb 3500");
	ServerCommand("cash_team_win_by_defusing_bomb 3500");
	ServerCommand("cash_team_win_by_hostage_rescue 3500");
	ServerCommand("cash_player_get_killed 0");
	ServerCommand("cash_player_respawn_amount 0");
	ServerCommand("cash_team_elimination_hostage_map_ct 2000");
	ServerCommand("cash_team_elimination_hostage_map_t 1000");
	ServerCommand("cash_team_win_by_time_running_out_bomb 3250");
	ServerCommand("cash_team_win_by_time_running_out_hostage 3250");
	ServerCommand("ff_damage_reduction_grenade 0.85");
	ServerCommand("ff_damage_reduction_bullets 0.33");
	ServerCommand("ff_damage_reduction_other 0.4");
	ServerCommand("ff_damage_reduction_grenade_self 1");
	ServerCommand("mp_afterroundmoney 0");
	ServerCommand("mp_autokick 0");
	ServerCommand("mp_autoteambalance 0");
	ServerCommand("mp_buytime 15");
	ServerCommand("mp_c4timer 40");
	ServerCommand("mp_death_drop_defuser 1");
	ServerCommand("mp_death_drop_grenade 2");
	ServerCommand("mp_death_drop_gun 1");
	ServerCommand("mp_defuser_allocation 0");
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_forcecamera 1");
	ServerCommand("mp_force_pick_time 160");
	ServerCommand("mp_free_armor 0");
	ServerCommand("mp_freezetime 12");
	ServerCommand("mp_friendlyfire 1");
	ServerCommand("mp_halftime 1");
	ServerCommand("mp_halftime_duration 30");
	ServerCommand("mp_join_grace_time 30");
	ServerCommand("mp_limitteams 0 ");
	ServerCommand("mp_logdetail 3");
	ServerCommand("mp_match_can_clinch 1");
	ServerCommand("mp_match_end_restart 1");
	ServerCommand("mp_maxmoney 16000");
	ServerCommand("mp_maxrounds 30");
	ServerCommand("mp_molotovusedelay 0");
	ServerCommand("mp_overtime_enable 1");
	ServerCommand("mp_overtime_maxrounds 10");
	ServerCommand("mp_overtime_startmoney 16000");
	ServerCommand("mp_playercashawards 1");
	ServerCommand("mp_playerid 0");
	ServerCommand("mp_playerid_delay 0.5");
	ServerCommand("mp_playerid_hold 0.25");
	ServerCommand("mp_round_restart_delay 5");
	ServerCommand("mp_roundtime 1.92");
	ServerCommand("mp_roundtime_defuse 1.92");
	ServerCommand("mp_solid_teammates 1");
	ServerCommand("mp_startmoney 800");
	ServerCommand("mp_teamcashawards 1");
	ServerCommand("mp_timelimit 0");
	ServerCommand("mp_tkpunish 0");
	ServerCommand("mp_warmuptime 1");
	ServerCommand("mp_weapons_allow_map_placed 1");
	ServerCommand("mp_weapons_allow_zeus 1");
	ServerCommand("mp_win_panel_display_time 15");
	ServerCommand("spec_freeze_time 2.0");
	ServerCommand("spec_freeze_panel_extended_time 0");
	ServerCommand("spec_freeze_time_lock 2");
	ServerCommand("spec_freeze_deathanim_time 0");
	ServerCommand("sv_accelerate 5.5");
	ServerCommand("sv_stopspeed 80");
	ServerCommand("sv_allow_votes 0");
	ServerCommand("sv_allow_wait_command 0");
	ServerCommand("sv_alltalk 0");
	ServerCommand("sv_alternateticks 0");
	ServerCommand("sv_cheats 0");
	ServerCommand("sv_clockcorrection_msecs 15");
	ServerCommand("sv_consistency 0");
	ServerCommand("sv_contact 0");
	ServerCommand("sv_damage_print_enable 0");
	ServerCommand("sv_dc_friends_reqd 0");
	ServerCommand("sv_deadtalk 1");
	ServerCommand("sv_forcepreload 0");
	ServerCommand("sv_friction 5.2");
	ServerCommand("sv_full_alltalk 0");
	ServerCommand("sv_gameinstructor_disable 1");
	ServerCommand("sv_ignoregrenaderadio 0 ");
	ServerCommand("sv_kick_players_with_cooldown 0");
	ServerCommand("sv_kick_ban_duration 0");
	ServerCommand("sv_lan 0");
	ServerCommand("sv_log_onefile 0");
	ServerCommand("sv_logbans 1");
	ServerCommand("sv_logecho 1");
	ServerCommand("sv_logfile 1");
	ServerCommand("sv_logflush 0");
	ServerCommand("sv_logsdir logfiles");
	ServerCommand("sv_maxrate 0");
	ServerCommand("sv_mincmdrate 30");
	ServerCommand("sv_minrate 20000");
	ServerCommand("sv_competitive_minspec 1");
	ServerCommand("sv_competitive_official_5v5 1");
	ServerCommand("sv_pausable 1");
	ServerCommand("sv_pure 1");
	ServerCommand("sv_pure_kick_clients 1");
	ServerCommand("sv_pure_trace 0");
	ServerCommand("sv_spawn_afk_bomb_drop_time 30");
	ServerCommand("sv_steamgroup_exclusive 0");
	ServerCommand("sv_voiceenable 1");
	ServerCommand("sv_auto_full_alltalk_during_warmup_half_end 0");
	ServerCommand("mp_restartgame 1");
	return Plugin_Handled;
}

public Action ConfigWarmup(int client, int cfg)
{
	ServerCommand("mp_ct_default_secondary weapon_hkp2000");
	ServerCommand("mp_t_default_secondary weapon_glock");
	ServerCommand("ammo_grenade_limit_default 0");
	ServerCommand("ammo_grenade_limit_flashbang 0");
	ServerCommand("ammo_grenade_limit_total 0");
	ServerCommand("bot_quota 0");
	ServerCommand("cash_player_bomb_defused 300");
	ServerCommand("cash_player_bomb_planted 300");
	ServerCommand("cash_player_damage_hostage -30");
	ServerCommand("cash_player_interact_with_hostage 150");
	ServerCommand("cash_player_killed_enemy_default 300");
	ServerCommand("cash_player_killed_enemy_factor 1");
	ServerCommand("cash_player_killed_hostage -1000");
	ServerCommand("cash_player_killed_teammate -300");
	ServerCommand("cash_player_rescued_hostage 1000");
	ServerCommand("cash_team_elimination_bomb_map 3250");
	ServerCommand("cash_team_hostage_alive 150");
	ServerCommand("cash_team_hostage_interaction 150");
	ServerCommand("cash_team_loser_bonus 1400");
	ServerCommand("cash_team_loser_bonus_consecutive_rounds 500");
	ServerCommand("cash_team_planted_bomb_but_defused 800");
	ServerCommand("cash_team_rescued_hostage 750");
	ServerCommand("cash_team_terrorist_win_bomb 3500");
	ServerCommand("cash_team_win_by_defusing_bomb 3500");
	ServerCommand("cash_team_win_by_hostage_rescue 3500");
	ServerCommand("cash_player_get_killed 0");
	ServerCommand("cash_player_respawn_amount 0");
	ServerCommand("cash_team_elimination_hostage_map_ct 2000");
	ServerCommand("cash_team_elimination_hostage_map_t 1000");
	ServerCommand("cash_team_win_by_time_running_out_bomb 3250");
	ServerCommand("cash_team_win_by_time_running_out_hostage 3250");
	ServerCommand("ff_damage_reduction_grenade 0.85");
	ServerCommand("ff_damage_reduction_bullets 0.33");
	ServerCommand("ff_damage_reduction_other 0.4");
	ServerCommand("ff_damage_reduction_grenade_self 1");
	ServerCommand("mp_afterroundmoney 0");
	ServerCommand("mp_autokick 0");
	ServerCommand("mp_autoteambalance 0");
	ServerCommand("mp_buytime 15");
	ServerCommand("mp_c4timer 35");
	ServerCommand("mp_death_drop_defuser 1");
	ServerCommand("mp_death_drop_grenade 2");
	ServerCommand("mp_death_drop_gun 1");
	ServerCommand("mp_defuser_allocation 0");
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_forcecamera 1");
	ServerCommand("mp_force_pick_time 160");
	ServerCommand("mp_free_armor 0");
	ServerCommand("mp_freezetime 6");
	ServerCommand("mp_friendlyfire 0");
	ServerCommand("mp_halftime 0");
	ServerCommand("mp_halftime_duration 0");
	ServerCommand("mp_join_grace_time 30");
	ServerCommand("mp_limitteams 0");
	ServerCommand("mp_logdetail 3");
	ServerCommand("mp_match_can_clinch 1");
	ServerCommand("mp_match_end_restart 1");
	ServerCommand("mp_maxmoney 9999999");
	ServerCommand("mp_maxrounds 5");
	ServerCommand("mp_molotovusedelay 0");
	ServerCommand("mp_overtime_enable 1");
	ServerCommand("mp_overtime_maxrounds 10");
	ServerCommand("mp_overtime_startmoney 16000");
	ServerCommand("mp_playercashawards 1");
	ServerCommand("mp_playerid 0");
	ServerCommand("mp_playerid_delay 0.5");
	ServerCommand("mp_playerid_hold 0.25");
	ServerCommand("mp_round_restart_delay 5");
	ServerCommand("mp_roundtime 10");
	ServerCommand("mp_roundtime_defuse 10");
	ServerCommand("mp_solid_teammates 1");
	ServerCommand("mp_startmoney 9999999");
	ServerCommand("mp_teamcashawards 1");
	ServerCommand("mp_timelimit 0");
	ServerCommand("mp_tkpunish 0");
	ServerCommand("mp_warmuptime 36000");
	ServerCommand("mp_weapons_allow_map_placed 1");
	ServerCommand("mp_weapons_allow_zeus 1");
	ServerCommand("mp_win_panel_display_time 15");
	ServerCommand("spec_freeze_time 5.0");
	ServerCommand("spec_freeze_panel_extended_time 0");
	ServerCommand("sv_accelerate 5.5");
	ServerCommand("sv_stopspeed 80");
	ServerCommand("sv_allow_votes 0");
	ServerCommand("sv_allow_wait_command 0");
	ServerCommand("sv_alltalk 1");
	ServerCommand("sv_alternateticks 0");
	ServerCommand("sv_cheats 0");
	ServerCommand("sv_clockcorrection_msecs 15");
	ServerCommand("sv_consistency 0");
	ServerCommand("sv_contact 0");
	ServerCommand("sv_damage_print_enable 0");
	ServerCommand("sv_dc_friends_reqd 0");
	ServerCommand("sv_deadtalk 1");
	ServerCommand("sv_forcepreload 0");
	ServerCommand("sv_friction 5.2");
	ServerCommand("sv_full_alltalk 0");
	ServerCommand("sv_gameinstructor_disable 1");
	ServerCommand("sv_ignoregrenaderadio 0");
	ServerCommand("sv_kick_players_with_cooldown 0");
	ServerCommand("sv_kick_ban_duration 0 ");
	ServerCommand("sv_lan 0");
	ServerCommand("sv_log_onefile 0");
	ServerCommand("sv_logbans 1");
	ServerCommand("sv_logecho 1");
	ServerCommand("sv_logfile 1");
	ServerCommand("sv_logflush 0");
	ServerCommand("sv_logsdir logfiles");
	ServerCommand("sv_maxrate 0");
	ServerCommand("sv_mincmdrate 30");
	ServerCommand("sv_minrate 20000");
	ServerCommand("sv_competitive_minspec 1");
	ServerCommand("sv_competitive_official_5v5 1");
	ServerCommand("sv_pausable 1");
	ServerCommand("sv_pure 1");
	ServerCommand("sv_pure_kick_clients 1");
	ServerCommand("sv_pure_trace 0");
	ServerCommand("sv_spawn_afk_bomb_drop_time 30");
	ServerCommand("sv_steamgroup_exclusive 0");
	ServerCommand("sv_voiceenable 1");
	ServerCommand("mp_restartgame 1");
	ServerCommand("mp_warmup_start");
	
	return Plugin_Handled;
}

public Action ConfigKnifeRound(int client, int cfg)
{
	ServerCommand("mp_unpause_match");
	ServerCommand("mp_warmuptime 1");
	ServerCommand("mp_ct_default_secondary none");
	ServerCommand("mp_t_default_secondary none");
	ServerCommand("mp_free_armor 1");
	ServerCommand("mp_roundtime 60");
	ServerCommand("mp_round_restart_delay 5");
	ServerCommand("mp_roundtime_defuse 60");
	ServerCommand("mp_roundtime_hostage 60");
	ServerCommand("mp_give_player_c4 0");
	ServerCommand("mp_maxmoney 0");
	ServerCommand("mp_restartgame 1");

	return Plugin_Handled;
}

public Action ConfigTrening(int client, int cfg)
{
	ServerCommand("mp_ct_default_secondary weapon_hkp2000");
	ServerCommand("mp_t_default_secondary weapon_glock");
	ServerCommand("ammo_grenade_limit_default 0");
	ServerCommand("ammo_grenade_limit_flashbang 0");
	ServerCommand("ammo_grenade_limit_total 0");
	ServerCommand("bot_quota 0");
	ServerCommand("cash_player_bomb_defused 300");
	ServerCommand("cash_player_bomb_planted 300");
	ServerCommand("cash_player_damage_hostage -30");
	ServerCommand("cash_player_interact_with_hostage 150");
	ServerCommand("cash_player_killed_enemy_default 300");
	ServerCommand("cash_player_killed_enemy_factor 1");
	ServerCommand("cash_player_killed_hostage -1000");
	ServerCommand("cash_player_killed_teammate -300");
	ServerCommand("cash_player_rescued_hostage 1000");
	ServerCommand("cash_team_elimination_bomb_map 3250");
	ServerCommand("cash_team_hostage_alive 150");
	ServerCommand("cash_team_hostage_interaction 150");
	ServerCommand("cash_team_loser_bonus 1400");
	ServerCommand("cash_team_loser_bonus_consecutive_rounds 500");
	ServerCommand("cash_team_planted_bomb_but_defused 800");
	ServerCommand("cash_team_rescued_hostage 750");
	ServerCommand("cash_team_terrorist_win_bomb 3500");
	ServerCommand("cash_team_win_by_defusing_bomb 3500");
	ServerCommand("cash_team_win_by_hostage_rescue 3500");
	ServerCommand("cash_player_get_killed 0");
	ServerCommand("cash_player_respawn_amount 0");
	ServerCommand("cash_team_elimination_hostage_map_ct 2000");
	ServerCommand("cash_team_elimination_hostage_map_t 1000");
	ServerCommand("cash_team_win_by_time_running_out_bomb 3250");
	ServerCommand("cash_team_win_by_time_running_out_hostage 3250");
	ServerCommand("ff_damage_reduction_grenade 0.85");
	ServerCommand("ff_damage_reduction_bullets 0.33");
	ServerCommand("ff_damage_reduction_other 0.4");
	ServerCommand("ff_damage_reduction_grenade_self 1");
	ServerCommand("mp_afterroundmoney 0");
	ServerCommand("mp_autokick 0");
	ServerCommand("mp_autoteambalance 0");
	ServerCommand("mp_buytime 15");
	ServerCommand("mp_c4timer 35");
	ServerCommand("mp_death_drop_defuser 1");
	ServerCommand("mp_death_drop_grenade 2");
	ServerCommand("mp_death_drop_gun 1");
	ServerCommand("mp_defuser_allocation 0");
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_forcecamera 1");
	ServerCommand("mp_force_pick_time 160");
	ServerCommand("mp_free_armor 0");
	ServerCommand("mp_freezetime 6");
	ServerCommand("mp_friendlyfire 0");
	ServerCommand("mp_halftime 0");
	ServerCommand("mp_halftime_duration 0");
	ServerCommand("mp_join_grace_time 30");
	ServerCommand("mp_limitteams 0");
	ServerCommand("mp_logdetail 3");
	ServerCommand("mp_match_can_clinch 1");
	ServerCommand("mp_match_end_restart 1");
	ServerCommand("mp_maxmoney 9999999");
	ServerCommand("mp_maxrounds 5");
	ServerCommand("mp_molotovusedelay 0");
	ServerCommand("mp_overtime_enable 1");
	ServerCommand("mp_overtime_maxrounds 10");
	ServerCommand("mp_overtime_startmoney 16000");
	ServerCommand("mp_playercashawards 1");
	ServerCommand("mp_playerid 0");
	ServerCommand("mp_playerid_delay 0.5");
	ServerCommand("mp_playerid_hold 0.25");
	ServerCommand("mp_round_restart_delay 5");
	ServerCommand("mp_roundtime 10");
	ServerCommand("mp_roundtime_defuse 10");
	ServerCommand("mp_solid_teammates 1");
	ServerCommand("mp_startmoney 9999999");
	ServerCommand("mp_teamcashawards 1");
	ServerCommand("mp_timelimit 0");
	ServerCommand("mp_tkpunish 0");
	ServerCommand("mp_warmuptime 36000");
	ServerCommand("mp_weapons_allow_map_placed 1");
	ServerCommand("mp_weapons_allow_zeus 1");
	ServerCommand("mp_win_panel_display_time 15");
	ServerCommand("spec_freeze_time 5.0");
	ServerCommand("spec_freeze_panel_extended_time 0");
	ServerCommand("sv_accelerate 5.5");
	ServerCommand("sv_stopspeed 80");
	ServerCommand("sv_allow_votes 0");
	ServerCommand("sv_allow_wait_command 0");
	ServerCommand("sv_alltalk 1");
	ServerCommand("sv_alternateticks 0");
	ServerCommand("sv_cheats 0");
	ServerCommand("sv_clockcorrection_msecs 15");
	ServerCommand("sv_consistency 0");
	ServerCommand("sv_contact 0");
	ServerCommand("sv_damage_print_enable 0");
	ServerCommand("sv_dc_friends_reqd 0");
	ServerCommand("sv_deadtalk 1");
	ServerCommand("sv_forcepreload 0");
	ServerCommand("sv_friction 5.2");
	ServerCommand("sv_full_alltalk 0");
	ServerCommand("sv_gameinstructor_disable 1");
	ServerCommand("sv_ignoregrenaderadio 0");
	ServerCommand("sv_kick_players_with_cooldown 0");
	ServerCommand("sv_kick_ban_duration 0 ");
	ServerCommand("sv_lan 0");
	ServerCommand("sv_log_onefile 0");
	ServerCommand("sv_logbans 1");
	ServerCommand("sv_logecho 1");
	ServerCommand("sv_logfile 1");
	ServerCommand("sv_logflush 0");
	ServerCommand("sv_logsdir logfiles");
	ServerCommand("sv_maxrate 0");
	ServerCommand("sv_mincmdrate 30");
	ServerCommand("sv_minrate 20000");
	ServerCommand("sv_competitive_minspec 1");
	ServerCommand("sv_competitive_official_5v5 1");
	ServerCommand("sv_pausable 1");
	ServerCommand("sv_pure 1");
	ServerCommand("sv_pure_kick_clients 1");
	ServerCommand("sv_pure_trace 0");
	ServerCommand("sv_spawn_afk_bomb_drop_time 30");
	ServerCommand("sv_steamgroup_exclusive 0");
	ServerCommand("sv_voiceenable 1");
	ServerCommand("mp_restartgame 1");
	ServerCommand("mp_warmup_start");
	
	return Plugin_Handled;
}