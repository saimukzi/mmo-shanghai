extends Object

class_name Common

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
