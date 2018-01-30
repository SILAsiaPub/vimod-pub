function tasklist (list)
  print(list)
  --count = count + 1
  fh,err = io.open(list)
  if err then print("Tasklist not found! Skipping further processing."); return; end
  while true do
    line = fh:read()
    if line == nil then break end
    print (line)
    if string.find(line,"Python") then

      print(line+"\n")
      print("\n")
    end
  end
end

input = "D:\\All-SIL-Publishing\\github-SILAsiaPub\\vimod-pub\\trunk\\data\\demo\\books\\setup\\sfm2html.tasks"
tasklist(input)
