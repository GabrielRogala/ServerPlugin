#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "KawalChama"
#define PLUGIN_VERSION "1.00"

#define NONE 0
#define SPEC 1
#define TEAM1 2
#define TEAM2 3

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
enum MatchRoundType{
	WarmupRound,
	KnifeRound,
	MatchRound
}

// game
ServerMode SERVER_MODE = Default; 
char PREFIX_PLUGIN[] = "[LOG]";
char CurrentMapName[64];
char DemoFileName[64];

char MenuOptions[][][32] = {
	{"cgm","Change geme mod >"},
		{"def","Default"},
		{"rtk","Retake"},
		{"mmk","Matchmaking"},
		{"trg","Trening"},
	{"mhd","Match Handler >"},
		{"swu","Start Warmup"},
		{"fkr","Force knife round"},
		{"smm","Start Match"},
		{"pus","Pause"},
		{"ups","Unpause"},
		{"stm","Swap teams"},
	{"mxp","Mix player"},
	{"dmg","Damage info >"},
		{"ton","Turn ON"},
		{"tof","Turn OFF"},
	{"dmo","Demo"},
		{"src","Start recording"},
		{"spr","Stop recording"},
	{"",""}
};


// default

// retake

// match
MatchRoundType CurrentRoundType;
//int WinningTeam;
int Damage[MAXPLAYERS + 1][MAXPLAYERS + 1];
int Hits[MAXPLAYERS + 1][MAXPLAYERS + 1];
char CaptainID_CT[40];
char CaptainID_T[40];
char CaptainName_T[64];
char CaptainName_CT[64];
//int TotalPauses_CT;
//int TotalPauses_T;
//int MaxPauses_CT;
//int MaxPauses_T;
bool DemoRecorded;
int ReadyPlayers;
char PlayersReadyList[MAXPLAYERS + 1][64];
// trening


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
	
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Post);
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath);
	
	RegConsoleCmd("sm_stay", CMD_Stay, "");
	RegConsoleCmd("sm_switch", CMD_Switch, "");
	RegConsoleCmd("sm_unpause", CMD_Unpause, "");
	RegConsoleCmd("sm_pause", CMD_Pause, "");
	RegConsoleCmd("sm_ready", CMD_Ready, "");
	RegConsoleCmd("sm_unready", CMD_Unready, "");
	
	RegAdminCmd("sm_smenu", CMD_ServerMenu, ADMFLAG_GENERIC, "");
	
}

public void OnMapStart()
{
	//Map String to LowerCase
	GetCurrentMap(CurrentMapName, sizeof(CurrentMapName));
	int len = strlen(CurrentMapName);
	for(int i=0;i < len;i++)
	{
		CurrentMapName[i] = CharToLower(CurrentMapName[i]);
	}
	DemoRecorded = false;
	ReadyPlayers = 0;
	ServerCommand("tv_enable 1");
	//ServerCommand("changelevel \"%s\"",CurrentMapName);
}


/*
* MENU
*/

public Action Menu_ServerMenu(int client, int args)
{
	Menu menu = new Menu(MenuHandler_ServerMenu);
	
	if(args == 0){
		menu.SetTitle(MenuOptions[0][1]);
		menu.AddItem(MenuOptions[1][0], MenuOptions[1][1]);
		menu.AddItem(MenuOptions[2][0], MenuOptions[2][1]);
		menu.AddItem(MenuOptions[3][0], MenuOptions[3][1]);
		menu.AddItem(MenuOptions[4][0], MenuOptions[4][1]);
	} else if(args == 5){
		menu.SetTitle(MenuOptions[5][1]);
		menu.AddItem(MenuOptions[6][0], MenuOptions[6][1]);
		menu.AddItem(MenuOptions[7][0], MenuOptions[7][1]);
		menu.AddItem(MenuOptions[8][0], MenuOptions[8][1]);
		menu.AddItem(MenuOptions[9][0], MenuOptions[9][1]);
		menu.AddItem(MenuOptions[10][0], MenuOptions[10][1]);
		menu.AddItem(MenuOptions[11][0], MenuOptions[11][1]);
	} else if(args == 12){
		// non submenu
	} else if(args == 13){
		menu.SetTitle(MenuOptions[13][1]);
		menu.AddItem(MenuOptions[14][0], MenuOptions[14][1]);
		menu.AddItem(MenuOptions[15][0], MenuOptions[15][1]);
	} else if(args == 16){
		menu.SetTitle(MenuOptions[16][1]);
		menu.AddItem(MenuOptions[17][0], MenuOptions[17][1]);
		menu.AddItem(MenuOptions[18][0], MenuOptions[18][1]);
	} else {
		menu.SetTitle("Server menu");
		menu.AddItem(MenuOptions[0][0], MenuOptions[0][1]);
		menu.AddItem(MenuOptions[5][0], MenuOptions[5][1]);
		menu.AddItem(MenuOptions[12][0], MenuOptions[12][1]);
		menu.AddItem(MenuOptions[13][0], MenuOptions[13][1]);
		menu.AddItem(MenuOptions[16][0], MenuOptions[16][1]);
	}		

	menu.ExitButton = true;
	menu.Display(client, 20);
 
	return Plugin_Handled;
}

public int MenuHandler_ServerMenu(Menu menu, MenuAction action, int param1, int param2)
{
	/* If an option was selected, tell the client about the item. */
	if (action == MenuAction_Select)
	{
		char info[32];
		//bool found = menu.GetItem(param2, info, sizeof(info));
		//PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		
		if (StrEqual(info, MenuOptions[0][0]))
		{
			Menu_ServerMenu(param1, 0);
		}
		else if (StrEqual(info, MenuOptions[1][0]))
		{}
		else if (StrEqual(info, MenuOptions[2][0]))
		{}
		else if (StrEqual(info, MenuOptions[3][0]))
		{}
		else if (StrEqual(info, MenuOptions[4][0]))
		{}
		else if (StrEqual(info, MenuOptions[5][0]))
		{
			Menu_ServerMenu(param1, 5);
		}
		else if (StrEqual(info, MenuOptions[6][0]))
		{}
		else if (StrEqual(info, MenuOptions[7][0]))
		{}
		else if (StrEqual(info, MenuOptions[8][0]))
		{}
		else if (StrEqual(info, MenuOptions[9][0]))
		{}
		else if (StrEqual(info, MenuOptions[10][0]))
		{}
		else if (StrEqual(info, MenuOptions[11][0]))
		{}
		else if (StrEqual(info, MenuOptions[12][0]))
		{}
		else if (StrEqual(info, MenuOptions[13][0]))
		{
			Menu_ServerMenu(param1, 13);
		}
		else if (StrEqual(info, MenuOptions[14][0]))
		{}
		else if (StrEqual(info, MenuOptions[15][0]))
		{}
		else if (StrEqual(info, MenuOptions[16][0]))
		{
			Menu_ServerMenu(param1, 16);
		}
		else if (StrEqual(info, MenuOptions[17][0]))
		{
			StartRecordDemo(param1);
		}
		else if (StrEqual(info, MenuOptions[18][0]))
		{
			StopRecordDemo(param1);
		}
		
	}
	/* If the menu was cancelled, print a message to the server about it. */
	else if (action == MenuAction_Cancel)
	{
		PrintToServer("Client %d's menu was cancelled.  Reason: %d", param1, param2);
	}
	/* If the menu has ended, destroy it */
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

/*
* Commands
*/

public Action CMD_ServerMenu(int client, int args){
	Menu_ServerMenu(client, -1);
}

public Action CMD_Stay(int client, int args){
			
	PrintToChat(client, "%s You can't use this command.", PREFIX_PLUGIN);
	return Plugin_Handled;
}

public Action CMD_Switch(int client, int args){
	
	for (int i = 1; i <= MaxClients; i++){
		if(IsClientInGame(i)){
			switch (GetClientTeam(i)){
				case TEAM1 : ChangeClientTeam(i, TEAM2);
				case TEAM2 : ChangeClientTeam(i, TEAM1);
			}
		}
	}
	
	int ts = GetTeamScore(TEAM1);
	SetTeamScore(TEAM1, GetTeamScore(TEAM2));
	SetTeamScore(TEAM2, ts);

	return Plugin_Handled;
}

public Action CMD_Unpause(int client, int args){}
public Action CMD_Pause(int client, int args){}

public Action CMD_Ready(int client, int args){
	if(StrEqual(PlayersReadyList[client],"")){
		GetClientName(client, PlayersReadyList[client], 64);
		ReadyPlayers++;
	}
}

public Action CMD_Unready(int client, int args){
	char clientName[64];
	GetClientName(client, clientName, sizeof(clientName));
	
	if(StrEqual(PlayersReadyList[client],clientName)){
		strcopy(PlayersReadyList[client], 64, "");
		ReadyPlayers--;
	}
}


/*
* EVENTS
*/

public Action Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast){
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int victim = GetClientOfUserId(event.GetInt("userid"));
	bool validAttacker = IsClientValid(attacker);
	bool validVictim = IsClientValid(victim);
	
	if (validAttacker && validVictim)
	{
		int client_health = GetClientHealth(victim);
		int health_damage = event.GetInt("dmg_health");
		int event_client_health = event.GetInt("health");
		if (event_client_health == 0) {
			health_damage += client_health;
		}
		Damage[attacker][victim] += health_damage;
		Hits[attacker][victim]++;
	}
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	bool headshot = event.GetBool("headshot");
	char weapon[64]; 
	event.GetString("weapon", weapon, sizeof(weapon));
	
	
	char victimName[64]; 
	GetClientName(victim, victimName, sizeof(victimName));
	
	char attackerName[64]; 
	GetClientName(attacker, attackerName, sizeof(attackerName));
 
	char hsSufix[10];
 
 	if(headshot){
 		strcopy(hsSufix, 10, "(headshot)");
	}else{
		strcopy(hsSufix, 10, "");
	}
	
	PrintToChatAll("%s %s killed %s with %s %s",
					PREFIX_PLUGIN,
					attackerName,
					victimName,
					weapon,
					hsSufix);
 
	
	if (CurrentRoundType == MatchRound)
	{
		if (IsClientValid(victim))
		{
			PrintHintText(victim, "<font color='#0087af'><b><u>%N</u></b></font><br><font color='#87df87'>Frags: %d   </font><font color='#af0000'>Deaths: %d</font><br><font color='#dfdf00'>MVPS: %d</font>", victim, GetClientFrags(victim), GetClientDeaths(victim), CS_GetMVPCount(victim));
		}
	}
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast){
	if(SERVER_MODE == Default){	
		
	} else if(SERVER_MODE == Retake){

	} else if(SERVER_MODE == Matchmaking){

	} else if(SERVER_MODE == Trening){

	}

	return Plugin_Handled;
}
public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast){

	if(SERVER_MODE == Default){	
		
	} else if(SERVER_MODE == Retake){

	} else if(SERVER_MODE == Matchmaking){

	} else if(SERVER_MODE == Trening){

	}
	
	return Plugin_Handled;
}


/*
* Server mode hendlers
*/

// round start
public void RoundStartHandler_ServerModeDefault(Event event){

}
public void RoundStartHandler_ServerModeRetake(Event event){

}
public void RoundStartHandler_ServerModeMatchmaking(Event event){

	if(CurrentRoundType == WarmupRound){

	} else if(CurrentRoundType == KnifeRound){

	} else if(CurrentRoundType == MatchRound){

	}

}
public void RoundStartHandler_ServerModeTrening(Event event){

}

// round end
public void RoundEndHandler_ServerModeDefault(Event event){

}
public void RoundEndHandler_ServerModeRetake(Event event){

}
public void RoundEndHandler_ServerModeMatchmaking(Event event){
	
	if(CurrentRoundType == WarmupRound){

	} else if(CurrentRoundType == KnifeRound){

	} else if(CurrentRoundType == MatchRound){

	}
	
}
public void RoundEndHandler_ServerModeTrening(Event event){

}


// server mode change
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

public void SetCapitan(int client){
	int clientTeam = GetClientTeam(client);
	if(clientTeam == CS_TEAM_T ){
		GetClientAuthId(client, AuthId_Steam2, CaptainID_T, 32, false);
		GetClientName(client, CaptainName_T, 64);
		PrintToChatAll("%s T's Captain: %s", PREFIX_PLUGIN, CaptainName_T);
	}else if(clientTeam == CS_TEAM_CT ){
		GetClientAuthId(client, AuthId_Steam2, CaptainID_CT, 32, false);
		GetClientName(client, CaptainName_CT, 64);
		PrintToChatAll("%s CT's Captain: %s", PREFIX_PLUGIN, CaptainName_CT);
	}
	
}

public bool CaptainCheck(int client){
	
	char clinetId[32];
	GetClientAuthId(client, AuthId_Steam2, clinetId, 32, false);
	int clientTeam = GetClientTeam(client);
	
	if(clientTeam == CS_TEAM_T ){
		
		if(StrEqual(clinetId, CaptainID_T, false)){
			return true;
		}else{
			PrintToChatAll("%s T's Captain: %s", PREFIX_PLUGIN, CaptainName_T);
			return false;
		}
		
	}else if(clientTeam == CS_TEAM_CT ){
		
		if(StrEqual(clinetId, CaptainID_CT, false)){
			return true;
		}else{
			PrintToChatAll("%s CT's Captain: %s", PREFIX_PLUGIN, CaptainName_CT);
			return false;
		}
		
	}
		
	return false;
}

public void SwapPlayer(int client, int target)
{
	switch (GetClientTeam(target))
	{
		case TEAM1 : ChangeClientTeam(client, TEAM2);
		case TEAM2 : ChangeClientTeam(client, TEAM1);
		default:
		return;
	}
}

public void StartRecordDemo(int client){
	if(!DemoRecorded){
		DemoRecorded = true;
		char time[64];
		FormatTime(time, sizeof(time), "%F-%R");
		Format(DemoFileName, sizeof(DemoFileName), "%s-%s",CurrentMapName, time);
		ServerCommand("tv_record \"%s\"",DemoFileName);
		PrintToChat(client, "%s Start recording to file : %s.dem", PREFIX_PLUGIN, DemoFileName);
	}else{
		PrintToChat(client, "%s Demo is currently being recorded to file %s.dem", PREFIX_PLUGIN, DemoFileName);
	}
}

public void StopRecordDemo(int client){
	ServerCommand("tv_stoprecord");
	DemoRecorded = false;
	PrintToChat(client, "%s Demo was saved to a file %s.dem", PREFIX_PLUGIN, DemoFileName);
}

public bool IsClientValid(int client){
	if (client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client))
		return true;
	return false;
}

public bool IsClientTeamValid(int client){
	int ClientTeam = GetClientTeam(client);
	if (ClientTeam != CS_TEAM_CT && ClientTeam != CS_TEAM_T)
	{
		return false;
	}
	return true;
}

public void OnClientDisconnect(int client){
	if (IsPlayerReady(client))
	{
		strcopy(PlayersReadyList[client], 64, "");
		ReadyPlayers--;
	}
}

public bool IsPlayerReady(int client){
	
	if (CurrentRoundType == WarmupRound){
		char clientName[64];
		GetClientName(client, clientName, sizeof(clientName));
	
		if(StrEqual(PlayersReadyList[client],clientName)){
			return true;
		} else {
			return false;
		}
	}else{
		return false;
	}
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