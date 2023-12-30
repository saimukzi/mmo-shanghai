extends Object

class_name Common

const EPSILON = 0.00001

static func shuffle(ary: Array, rng: RandomNumberGenerator):
    var ary_size = ary.size()
    
    var v_idx_ary = Array()
    for i in range(ary_size):
        v_idx_ary.append([rng.randi(), i])
    v_idx_ary.sort()
    
    var ret_ary = Array()
    for v_idx in v_idx_ary:
        var idx = v_idx[1]
        ret_ary.append(ary[idx])
    
    return ret_ary

static func dot21(mat2d: Array, ary1d: Array):
    assert(ary1d.size() == mat2d[0].size() - 1)
    var ret_ary = Array()
    var ary1d_size = ary1d.size()
    for row in mat2d:
        var ret = 0.0
        for i in range(ary1d.size()):
            ret += ary1d[i] * row[i]
        ret += row[ary1d_size]
        ret_ary.append(ret)
    return ret_ary

