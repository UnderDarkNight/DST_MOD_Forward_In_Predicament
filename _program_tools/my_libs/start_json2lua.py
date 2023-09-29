# import json2lua_base_lib
import my_libs.json2lua_base_lib as json2lua_base_lib

input_file_name = "test.json"   ## json 文件名
output_file_name = "result_test.lua"    ## 输出文件名

def json_file_2_lua_file(input_file_name,output_file_name):

    json2lua_base_lib.file_to_lua_file(input_file_name,output_file_name)

    # 成功把json 转换成 lua 使用的 table 。 需要顶头加个 return

    temp_file = open(output_file_name,encoding="utf-8")
    txt = []
    inser_flag = False
    for line in temp_file:
        if not inser_flag and line.find("{") != -1:
            inser_flag = True
            line = "return" + line
        txt.append(line)
        # print(line)


    temp_file.close()

    with open(output_file_name,"w") as f:
        for i in txt:
            f.writelines(i)
    f.close()

if __name__ == "__main__":
    json_file_2_lua_file(input_file_name,output_file_name)