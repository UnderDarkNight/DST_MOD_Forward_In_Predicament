#coding=utf-8

import xlrd
import json
import chardet
from urllib import parse

input_excel_file_name = "test.xls"
output_json_file_name = "test.json"


class MyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, bytes):
            info = chardet.detect(obj)
            print(info,obj)
            if info['encoding'] == None:
                return ""
            if info['encoding'] == "ascii":
                return str(obj, encoding='utf-8')
            if info['encoding'] == "utf-8": ## 中文乱码  b'\xe9\x87\x91\xe5\x9d\x97'
                return obj.decode('utf-8')
            
            return str(obj, encoding='utf-8')
        if isinstance(obj, int):
            return int(obj)
        elif isinstance(obj, float):    #只使用 int 数据类型
            return int(obj)
        else:
            return super(MyEncoder, self).default(obj)

def start_excel_2_json(input_excel_file_name,output_json_file_name):

    xlrd.Book.encoding = "gb2312"
    work_book = xlrd.open_workbook(input_excel_file_name,encoding_override="gb2312")    #xls 文件名字的编码，无法修改内部编码
    # sheets = work_book.sheets()
    # print(sheets)
    sheet_names = work_book.sheet_names()
    # print(sheet_names)

    sheet1 = work_book.sheet_by_name(sheet_names[0])

    row = sheet1.row_values(0)  # 行

    # print(row,type(row))
    col = sheet1.col_values(0)  # 列
    # print(col,type(col))

    ret_dict = {}
    ret_list = []
    # print("kk",len(col))
    for i in range(1,len(col)):
        # print("FFF",sheet1.row_values(i))
        if i == 0:
            pass
        else:
            temp_dict = {}
            for k in range(len(row)):
                value = sheet1.row_values(i)[k]
                # print(value,type(value))
                if type(value) == str:
                    value = value.encode("utf-8")
                    # chardet.detect(value)

                temp_dict[row[k]] = value

            # temp_dict[row[0]] = sheet1.row_values(i)[0]     # prefab
            # temp_dict[row[1]] = sheet1.row_values(i)[1]     # cost
            # temp_dict[row[2]] = sheet1.row_values(i)[2]     # num2give
            # temp_dict[row[3]] = sheet1.row_values(i)[3]     # image
            # temp_dict[row[4]] = sheet1.row_values(i)[4]     # atlas
            ret_list.append(temp_dict)

    # print(ret_list)

    # 将 Python 列表转换为 json 格式
    # indent 参数用于美观的格式化 json 数据
    # ensure_ascii=False 防止乱码

    json_data = json.dumps(ret_list,ensure_ascii=False,indent=4,cls=MyEncoder)
    with open(output_json_file_name,'w',encoding="utf8") as f:
        f.write(json_data)

    # f = open(output_json_file_name, "w", encoding="utf8")
    # json.dump(ret_list, f, ensure_ascii=False)


if __name__ == '__main__':
    start_excel_2_json(input_excel_file_name,output_json_file_name)