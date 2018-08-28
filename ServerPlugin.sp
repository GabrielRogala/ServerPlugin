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

int SERVER_MODE = 0; // 0 - default, 1 - retake, 2 - mm, 3 - trening

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

public void RunDefaultMode(){
	SERVER_MODE = 0;
}

public void RunRetakeMode(){
	SERVER_MODE = 1;
}

public void RunMatchMode(){
	SERVER_MODE = 2;
}

public void RunTreningMode(){
	SERVER_MODE = 3;
}
