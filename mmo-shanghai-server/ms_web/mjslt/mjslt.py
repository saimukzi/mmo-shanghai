import random

EPSILON = 0.00001

def gen_new_game():
    while True:
        tiletype_list = gen_new_game_tiletype_list()
        tilexyz_list = get_tilexyz_list()

        assert(len(tiletype_list) == len(tilexyz_list))

        tile_list_len = len(tiletype_list)
        tile_list = []
        for i in range(tile_list_len):
            tile_list.append([i, *tiletype_list[i], *tilexyz_list[i]])
        
        if not tile_list_exist_pair(tile_list):
            print('regen')
            continue

        return {
            'TILE_LIST': tile_list,
            'STATE': 'PICK_PAIR',
        }


def game_pick_tileid_pair(game, tileid0, tileid1):
    if tileid0 == tileid1:
        return {'RESULT':'ERROR_SAME_TILEID', 'GAME':game}
    if not game_tileid_exist(game, tileid0):
        return {'RESULT':'ERROR_TILE_NOT_EXIST', 'GAME':game}
    if not game_tileid_exist(game, tileid1):
        return {'RESULT':'ERROR_TILE_NOT_EXIST', 'GAME':game}
    tile_list = game['TILE_LIST']
    tile0 = tile_list_get_tile(tile_list, tileid0)
    tiletype0 = tile_get_tiletype(tile0)
    tile1 = tile_list_get_tile(tile_list, tileid1)
    tiletype1 = tile_get_tiletype(tile1)
    if not tile_list_tile_is_free(tile_list, tile0):
        return {'RESULT':'ERROR_TILE_NOT_FREE', 'GAME':game} 
    if not tile_list_tile_is_free(tile_list, tile1):
        return {'RESULT':'ERROR_TILE_NOT_FREE', 'GAME':game}
    if not tiletype_is_pair(tiletype0, tiletype1):
        return {'RESULT':'ERROR_NOT_TILE_PAIR', 'GAME':game}
    
    game_remove_tile(game, tileid0)
    game_remove_tile(game, tileid1)

    if len(game['TILE_LIST']) == 0:
        game['STATE'] = 'CLEAR'
    elif not tile_list_exist_pair(game['TILE_LIST']):
        game['STATE'] = 'NO_PAIR'
    else:
        game['STATE'] = 'PICK_PAIR'

    return {'RESULT':'OK', 'GAME':game}


def game_tileid_exist(game, tileid):
    for tile in game['TILE_LIST']:
        if tile_get_tileid(tile) == tileid:
            return True
    return False


# def game_tileid_is_free(game, tileid):
#     tile = game_get_tile(game, tileid)
#     tilexyz = tile_get_tilexyz(tile)

#     exist_right = False
#     exist_left = False

#     for tile0 in game['TILE_LIST']:
#         if tile_get_tileid(tile0) == tileid: continue
#         tilexyz0 = tile_get_tilexyz(tile0)
#         if tilexyz0[2] > tilexyz[2]:
#             if tilexyz[0] > tilexyz0[0] + 1 - EPSILON: continue
#             if tilexyz[0] < tilexyz0[0] - 1 + EPSILON: continue
#             if tilexyz[1] > tilexyz0[1] + 1 - EPSILON: continue
#             if tilexyz[1] < tilexyz0[1] - 1 + EPSILON: continue
#             return False
#         if tilexyz0[2] == tilexyz[2]:
#             exist_right = exist_right or tilexyz_is_leftright(tilexyz, tilexyz0)
#             exist_left = exist_left or tilexyz_is_leftright(tilexyz0, tilexyz)
#             if exist_right and exist_left:
#                 return False
#     return True


def tilexyz_is_leftright(tilexyz0, tilexyz1):
    if tilexyz0[0] < tilexyz1[0] - 1 - EPSILON: return False
    if tilexyz0[0] > tilexyz1[0] - 1 + EPSILON: return False
    if tilexyz0[1] < tilexyz1[1] - 1 + EPSILON: return False
    if tilexyz0[1] > tilexyz1[1] + 1 - EPSILON: return False
    return True


def tile_get_tileid(tile):
    return tile[0]


def tile_get_tiletype(tile):
    return tile[1:3]


def tile_get_tilexyz(tile):
    return tile[3:]


# def game_get_tile(game, tileid):
#     for tile in game['TILE_LIST']:
#         if tile_get_tileid(tile) == tileid:
#             return tile
#     assert(False)

def tile_list_get_tile(tile_list, tileid):
    for tile in tile_list:
        if tile_get_tileid(tile) == tileid:
            return tile
    assert(False)


def game_remove_tile(game, tileid):
    for i in range(len(game['TILE_LIST'])):
        if tile_get_tileid(game['TILE_LIST'][i]) == tileid:
            game['TILE_LIST'].pop(i)
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


def tile_list_exist_pair(tile_list):
    free_tile_list = tile_list_get_free_tile_list(tile_list)
    for tile0 in free_tile_list:
        tiletype0 = tile_get_tiletype(tile0)
        for tile1 in free_tile_list:
            if tile_get_tileid(tile0) == tile_get_tileid(tile1): continue
            tiletype1 = tile_get_tiletype(tile1)
            if tiletype_is_pair(tiletype0, tiletype1):
                return True
    return False

def tile_list_get_free_tile_list(tile_list):
    free_tile_list = tile_list
    free_tile_list = filter(lambda t: tile_list_tile_is_free(tile_list, t), free_tile_list)
    free_tile_list = list(free_tile_list)
    return free_tile_list


def tile_list_tile_is_free(tile_list, tile):
    tileid = tile_get_tileid(tile)
    tilexyz = tile_get_tilexyz(tile)
    x,y,z = tilexyz

    exist_right = False
    exist_left = False

    for tile0 in tile_list:
        if tile_get_tileid(tile0) == tileid: continue
        tilexyz0 = tile_get_tilexyz(tile0)
        x0,y0,z0 = tilexyz0
        if z0 > z:
            if x > x0 + 1 - EPSILON: continue
            if x < x0 - 1 + EPSILON: continue
            if y > y0 + 1 - EPSILON: continue
            if y < y0 - 1 + EPSILON: continue
            return False
        if z0 == z:
            exist_right = exist_right or tilexyz_is_leftright(tilexyz, tilexyz0)
            exist_left = exist_left or tilexyz_is_leftright(tilexyz0, tilexyz)
            if exist_right and exist_left:
                return False
    return True
