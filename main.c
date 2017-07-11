#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curses.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <locale.h>
#include "characters.h"

int main() {
  lua_State *lua_state = luaL_newstate();
  lua_pushnil(lua_state);
  setlocale(LC_ALL, "");
  character_test();
  lua_close(lua_state);
  return 0;
}

