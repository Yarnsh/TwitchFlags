extends Node

var name_to_flag = {}
var names_list = []

func _ready():
	var paths = _find_png_paths()
	for flag_path in paths:
		var flag_name = (flag_path.get_file()).split(".")[0]
		flag_name = flag_name.split("_").join(" ")
		names_list.append(flag_name)
		name_to_flag[flag_name] = load(flag_path)
	print(names_list)

func _find_png_paths() -> Array:
	var png_paths := [] # accumulated png paths to return
	var dir_queue := ["res://flags"] # directories remaining to be traversed
	var dir: Directory # current directory being traversed
	
	var file: String # current file being examined
	while file or not dir_queue.empty():
		# continue looping until there are no files or directories left
		if file:
			# there is another file in this directory
			if dir.current_is_dir():
				# found a directory, append it to the queue.
				dir_queue.append("%s/%s" % [dir.get_current_dir(), file])
			elif file.ends_with(".png.import"):
				# found a .png.import file, append its corresponding png to our results
				png_paths.append("%s/%s" % [dir.get_current_dir(), file.get_basename()])
		else:
			# there are no more files in this directory
			if dir:
				# close the current directory
				dir.list_dir_end()
			
			if dir_queue.empty():
				# there are no more directories. terminate the loop
				break
			
			# there are more directories. open the next directory
			dir = Directory.new()
			dir.open(dir_queue.pop_front())
			dir.list_dir_begin(true, true)
		file = dir.get_next()
	
	return png_paths
