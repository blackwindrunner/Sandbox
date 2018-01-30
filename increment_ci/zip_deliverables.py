import os, zipfile
# 一次性使用的脚本，当每次构建结束时需要通过这个脚本文件从新打包。
## 传入文件目录和输入目录，将传入文件目录中所有jar文件打包输出成zip文件
def make_jars_to_zip(source_dir, output_filename):
  zipf = zipfile.ZipFile(output_filename, 'w')
  pre_len = len(os.path.dirname(source_dir))
  for parent,dirnames,filenames in os.walk(source_dir):
    for filename in filenames:
      if filename.strip().__contains__(".jar"):
        pathfile = os.path.join(parent, filename)
        arcname = pathfile[pre_len:].strip(os.path.sep)   #相对路径
        print("filename:"+filename)
        print("pathfile:"+pathfile)
        print("arcname:"+arcname)
        zipf.write(pathfile, arcname)
  zipf.close()

btt_all_component = open("../8211.txt")
zip_path="D:\\8211_deliverables_zip"
# 判断结果
if not os.path.exists(zip_path):
      # 如果不存在则创建目录
      # 创建目录操作函数
      os.makedirs(zip_path) 
      print('create path: '+zip_path+'')        
else:
     # 如果目录存在则不创建，并提示目录已存在
     print('path '+zip_path+' have existed')

for component_name in btt_all_component.readlines():
  if component_name.strip()!='':
    print(component_name.strip())
    print("../../"+component_name.strip())
    print(zip_path+"\\"+component_name.strip()+".zip")
    make_jars_to_zip("../../"+component_name.strip(),zip_path+"\\"+component_name.strip()+".zip")