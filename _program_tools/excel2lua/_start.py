#coding=utf-8
import my_libs.excel2json as excel2json
import my_libs.start_json2lua   as json2lua

'''
    注意事项：
    · 本文件在 python 3.11.3运行完全正常
    · 本文件的执行时候的文件路径是以MOD工程为根目录做参照的。（能在VSCode打开MOD工程后，找到本文件后直接F5运行）
    · 本工具的目的是直接将excel 表格内容按照指定格式生成 lua 文件，直接 require 读取并得到 table，不用频繁捣鼓 text 的读取。

    python 必要的库执行命令：
    pip install xlrd         读取excel的库，只能读取  xls 文件，没法读取 xlsx 文件
    pip install json
    pip install chardet      文本编码检查器
    pip install urllib       编码处理



    使用示例
    注意文件路径

'''

def excample():
    # 执行示例
    input_excel_file_name = "./_program_tools/input.xls"         #输入的  excel 名字
    temp_json_file_name = "./_program_tools/temp.json"           #中间临时 json 
    output_lua_file_name = "./_program_tools/output.lua"         #最终输出商店读取列表

    excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)


if __name__ == "__main__":
    # excample()

    base_addr = "./_program_tools/excel2lua/"

    # 纪念品商店A
    input_excel_file_name = base_addr + "02_special_shop_items_a.xls"
    temp_json_file_name = base_addr + "02_special_shop_items_a.json"
    output_lua_file_name = base_addr + "02_special_shop_items_a.lua"
    excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)
    # 纪念品商店B
    # input_excel_file_name = base_addr + "02_special_shop_items_b.xls"
    # temp_json_file_name = base_addr + "02_special_shop_items_b.json"
    # output_lua_file_name = base_addr + "02_special_shop_items_b.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)

    # # 材料商店A
    # input_excel_file_name = base_addr + "03_materials_shop_items_a.xls"
    # temp_json_file_name = base_addr + "03_materials_shop_items_a.json"
    # output_lua_file_name = base_addr + "03_materials_shop_items_a.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)
    # # 材料商店B
    # input_excel_file_name = base_addr + "03_materials_shop_items_b.xls"
    # temp_json_file_name = base_addr + "03_materials_shop_items_b.json"
    # output_lua_file_name = base_addr + "03_materials_shop_items_b.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)


    # # 料理商店A
    # input_excel_file_name = base_addr + "04_cuisines_shop_items_a.xls"
    # temp_json_file_name = base_addr + "04_cuisines_shop_items_a.json"
    # output_lua_file_name = base_addr + "04_cuisines_shop_items_a.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)
    # # 料理商店B
    # input_excel_file_name = base_addr + "04_cuisines_shop_items_b.xls"
    # temp_json_file_name = base_addr + "04_cuisines_shop_items_b.json"
    # output_lua_file_name = base_addr + "04_cuisines_shop_items_b.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)

    # # 当铺A
    # input_excel_file_name = base_addr + "08_pawnshop_items_a.xls"
    # temp_json_file_name = base_addr + "08_pawnshop_items_a.json"
    # output_lua_file_name = base_addr + "08_pawnshop_items_a.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)
    # # 当铺B
    # input_excel_file_name = base_addr + "08_pawnshop_items_b.xls"
    # temp_json_file_name = base_addr + "08_pawnshop_items_b.json"
    # output_lua_file_name = base_addr + "08_pawnshop_items_b.lua"
    # excel2json.start_excel_2_json(input_excel_file_name, temp_json_file_name)
    # json2lua.json_file_2_lua_file(temp_json_file_name, output_lua_file_name)

    