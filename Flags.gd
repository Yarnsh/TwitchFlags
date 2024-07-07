extends Node

var name_to_flag_set = {}

signal new_flag_set

class FlagSet:
	var name_to_flag = {}
	var name_to_path = {}
	var names_list = []

func _ready():
	var dirs = _find_dir_paths("res://flags")
	
	for dir_name in dirs:
		LoadNewFlagSet(dir_name)

func LoadNewFlagSet(dir_path):
	var flag_set = FlagSet.new()
	var paths = _find_png_paths(dir_path)
	for flag_path in paths:
		var flag_name = (flag_path.get_file()).split(".")[0]
		flag_name = flag_name.split("_").join(" ")
		flag_set.names_list.append(flag_name)
		flag_set.name_to_flag[flag_name] = null # lazy load these to improve startup time
		flag_set.name_to_path[flag_name] = flag_path
	var split_dir = dir_path.split("/")
	var nice_name = split_dir[len(split_dir) - 1].split("_").join(" ")
	name_to_flag_set[nice_name] = flag_set
	print(flag_set.names_list)
	emit_signal("new_flag_set")

func GetFlag(set_name, flag_name):
	var result = name_to_flag_set[set_name].name_to_flag[flag_name]
	if result == null:
		if name_to_flag_set[set_name].name_to_path[flag_name].begins_with("res://"):
			result = load(name_to_flag_set[set_name].name_to_path[flag_name])
			name_to_flag_set[set_name].name_to_flag[flag_name] = result
		else:
			var image = Image.new()
			var err = image.load(name_to_flag_set[set_name].name_to_path[flag_name])
			if err != OK:
				print("loading failed, dunno what do")
			result = ImageTexture.new()
			result.create_from_image(image, 0)
			name_to_flag_set[set_name].name_to_flag[flag_name] = result
		
	return result

func GetFlagNameList(set_name):
	return name_to_flag_set[set_name].names_list

func _find_png_paths(dir_path) -> Array:
	var png_paths := [] # accumulated png paths to return
	var dir_queue := [dir_path] # directories remaining to be traversed
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

func _find_dir_paths(dir_path) -> Array:
	var dir_paths := [] # accumulated png paths to return
	var dir_queue := [dir_path] # directories remaining to be traversed
	var dir: Directory # current directory being traversed
	
	var file: String # current file being examined
	while file or not dir_queue.empty():
		# continue looping until there are no files or directories left
		if file:
			# there is another file in this directory
			if dir.current_is_dir():
				# found a directory, append it to the queue.
				dir_paths.append("%s/%s" % [dir.get_current_dir(), file])
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
	
	return dir_paths
