import os, zipfile

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

btt_all_component = open("../8210.txt")
for component_name in btt_all_component.readlines():
  if component_name.strip()!='':
    print(component_name.strip())
    zip_path="D:\\8210_deliverables_zip"
    print("=====")
    print("../../"+component_name.strip())
    print(zip_path+"\\"+component_name.strip()+".zip")
    make_jars_to_zip("../../"+component_name.strip(),zip_path+"\\"+component_name.strip()+".zip")