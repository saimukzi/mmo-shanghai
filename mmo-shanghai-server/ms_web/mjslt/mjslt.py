import random

EPSILON = 0.00001

def gen_new_game_state():
    tiletype_list = gen_new_game_tiletype_list()
    tilexyz_list = get_tilexyz_list()

    assert(len(tiletype_list) == len(tilexyz_list))

    tile_list_len = len(tiletype_list)
    tile_list = []
    for i in range(tile_list_len):
        tile_list.append([i, *tiletype_list[i], *tilexyz_list[i]])

    return {
        'TILE_LIST': tile_list,
    }


def state_pick_tile_id_pair(state, tile_id0, tile_id1):
    if tile_id0 == tile_id1:
        return {'RESULT':'ERROR_SAME_TILE_ID', 'STATE':state}
    if not state_tile_id_exist(state, tile_id0):
        return {'RESULT':'ERROR_TILE_NOT_EXIST', 'STATE':state}
    if not state_tile_id_exist(state, tile_id1):
        return {'RESULT':'ERROR_TILE_NOT_EXIST', 'STATE':state}
    if not state_tile_id_is_free(state, tile_id0):
        return {'RESULT':'ERROR_TILE_NOT_FREE', 'STATE':state} 
    if not state_tile_id_is_free(state, tile_id1):
        return {'RESULT':'ERROR_TILE_NOT_FREE', 'STATE':state}
    tile0 = state_get_tile(state, tile_id0)
    tiletype0 = tile_get_tiletype(tile0)
    tile1 = state_get_tile(state, tile_id1)
    tiletype1 = tile_get_tiletype(tile1)
    if not tiletype_is_pair(tiletype0, tiletype1):
        return {'RESULT':'ERROR_NOT_TILE_PAIR', 'STATE':state}
    
    state_remove_tile(state, tile_id0)
    state_remove_tile(state, tile_id1)

    return {'RESULT':'OK', 'STATE':state}


def state_tile_id_exist(state, tile_id):
    for tile in state['TILE_LIST']:
        if tile_get_id(tile) == tile_id:
            return True
    return False


def state_tile_id_is_free(state, tile_id):
    tile = state_get_tile(state, tile_id)
    tilexyz = tile_get_tilexyz(tile)

    exist_right = False
    exist_left = False

    for tile0 in state['TILE_LIST']:
        if tile_get_id(tile0) == tile_id: continue
        tilexyz0 = tile_get_tilexyz(tile0)
        if tilexyz0[2] > tilexyz[2]:
            if tilexyz[0] > tilexyz0[0] + 1 - EPSILON: continue
            if tilexyz[0] < tilexyz0[0] - 1 + EPSILON: continue
            if tilexyz[1] > tilexyz0[1] + 1 - EPSILON: continue
            if tilexyz[1] < tilexyz0[1] - 1 + EPSILON: continue
            return False
        if tilexyz0[2] == tilexyz[2]:
            exist_right = exist_right or tilexyz_is_leftright(tilexyz, tilexyz0)
            exist_left = exist_left or tilexyz_is_leftright(tilexyz0, tilexyz)
            if exist_right and exist_left:
                return False
    return True


def tilexyz_is_leftright(tilexyz0, tilexyz1):
    if tilexyz0[0] < tilexyz1[0] - 1 - EPSILON: return False
    if tilexyz0[0] > tilexyz1[0] - 1 + EPSILON: return False
    if tilexyz0[1] < tilexyz1[1] - 1 + EPSILON: return False
    if tilexyz0[1] > tilexyz1[1] + 1 - EPSILON: return False
    return True


def tile_get_id(tile):
    return tile[0]


def tile_get_tiletype(tile):
    return tile[1:3]


def tile_get_tilexyz(tile):
    return tile[3:]


def state_get_tile(state, tile_id):
    for tile in state['TILE_LIST']:
        if tile_get_id(tile) == tile_id:
            return tile
    assert(False)


def state_remove_tile(state, tile_id):
    for i in range(len(state['TILE_LIST'])):
        if tile_get_id(state['TILE_LIST'][i]) == tile_id:
            state['TILE_LIST'].pop(i)
            return
    assert(False)


def tiletype_is_pair(tiletype0, tiletype1):
    if tiletype0[0] != tiletype1[0]: return False
    if tiletype0[0] < 5:
        return tiletype0[1] == tiletype1[1]
    else:
        return True


SUIT_VALUE_COUNT_LIST = [
    [0, 9, 4],
    [1, 9, 4],
    [2, 9, 4],
    [3, 4, 4],
    [4, 3, 4],
    [5, 4, 1],
    [6, 4, 1],
]
def gen_new_game_tiletype_list():
    ret_tiletype_list = []
    for suit, value, count in SUIT_VALUE_COUNT_LIST:
        for v in range(value):
            for _c in range(count):
                ret_tiletype_list.append([suit, v])
    random.shuffle(ret_tiletype_list)
    return ret_tiletype_list


TILE_Z_Y_X0_W_LIST = [
    [0,0,1,12],
    [0,1,3,8],
    [0,2,2,10],
    [0,3,1,12],
    [0,4,1,12],
    [0,5,2,10],
    [0,6,3,8],
    [0,7,1,12],

    [0,3.5,0,1],
    [0,3.5,13,2],

    [1,1,4,6],
    [1,2,4,6],
    [1,3,4,6],
    [1,4,4,6],
    [1,5,4,6],
    [1,6,4,6],

    [2,2,5,4],
    [2,3,5,4],
    [2,4,5,4],
    [2,5,5,4],

    [3,3,6,2],
    [3,4,6,2],

    [4,3.5,6.5,1],
]
def get_tilexyz_list():
    ret_tilexyz_list = []
    for z, y, x0, w in TILE_Z_Y_X0_W_LIST:
        for xi in range(w):
            x = x0 + xi
            ret_tilexyz_list.append([x,y,z])
    return ret_tilexyz_list
