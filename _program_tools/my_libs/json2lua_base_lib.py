# code from https://www.cnblogs.com/lyh916/p/11343266.html
import json
import types
import json
import os
import codecs

def space_str(layer):
    lua_str = ""
    for i in range(0,layer):
        lua_str += '\t'    
    return lua_str

def dic_to_lua_str(data,layer=0):
    d_type = type(data)
    if d_type is str:
        return "\"" + data + "\""
    elif d_type is bool:
        if data:
            return 'true'
        else:
            return 'false'
    elif d_type is int or d_type is float:
        return str(data)
    elif d_type is list:
        lua_str = "{\n"
        lua_str += space_str(layer+1)
        for i in range(0,len(data)):
            lua_str += dic_to_lua_str(data[i],layer+1)
            if i < len(data)-1:
                lua_str += ','
        lua_str += '\n'
        lua_str += space_str(layer)
        lua_str +=  '}'
        return lua_str
    elif d_type is dict:
        lua_str = ''
        lua_str += "\n"
        lua_str += space_str(layer)
        lua_str += "{\n"
        data_len = len(data)
        data_count = 0
        for k,v in data.items():
            data_count += 1
            lua_str += space_str(layer+1)
            if type(k) is int:
                lua_str += '[' + str(k) + ']'
            else:
                # lua_str += k
                lua_str += '["' + k + '"]'

            lua_str += ' = '            
            try:
                lua_str += dic_to_lua_str(v,layer +1)
                if data_count < data_len:
                    lua_str += ',\n'

            except Exception:
                print ('error in ',k,v)
                raise
        lua_str += '\n'
        lua_str += space_str(layer)
        lua_str += '}'
        return lua_str
    else:
        print (d_type , 'is error')
        return None

def str_to_lua_table(jsonStr):
    data_dic = None
    try:
        data_dic = json.loads(jsonStr)
    except Exception:
        data_dic =[]
    else:
        pass
    finally:
        pass
    bytes = ''
    for it in dic_to_lua_str(data_dic):
        bytes += it
    return bytes

def file_to_lua_file(jsonFile,luaFile):
    with codecs.open(luaFile,"w","utf-8") as luafile:
        with codecs.open(jsonFile,"r","utf-8") as jsonfile:
            luafile.write(str_to_lua_table(jsonfile.read()))