import my_libs.excel2json as excel2json
import my_libs.start_json2lua   as json2lua

'''

    使用示例
    注意文件路径

'''

input_excel_file_name = "./_program_tools/input.xls"         #输入的  excel 名字
temp_json_file_name = "./_program_tools/temp.json"           #中间临时 json 
output_lua_file_name = "./_program_tools/output.lua"         #最终输出商店读取列表

excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)