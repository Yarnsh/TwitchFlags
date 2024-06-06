extends CanvasLayer

onready var turn_timer = $TurnTimer
onready var flag = $Flag
onready var opt1 = $Option1
onready var opt2 = $Option2
onready var opt3 = $Option3
onready var opt4 = $Option4
onready var opts = [opt1, opt2, opt3, opt4]

var questions_asked = 0
var correct_answers = 0
var vote_counts = [[], [], [], []]
var correct_vote = 0

func _ready():
	randomize()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		PickNewQuestion()

func StartNewGame():
	PickNewQuestion()
	questions_asked = 0
	correct_answers = 0
	# TODO reset score and start timer here

func CheckAnswer():
	pass # TODO count up vote, update score, show message and color options, pick new question

func PickNewQuestion():
	vote_counts = [[], [], [], []]
	
	var flag_count = len(Flags.names_list)
	# TODO: handle if there are less than 4 flags available, if we want to generalize this
	var options_idx = []
	var options = []
	var idx = 0
	while idx < 4:
		var flag_idx = randi() % (flag_count - idx)
		while flag_idx in options_idx:
			flag_idx = (flag_idx + 1) % flag_count
		options_idx.append(flag_idx)
		options.append(Flags.names_list[flag_idx])
		
		idx += 1
	
	correct_vote = randi() % 4
	flag.SetFlag(Flags.name_to_flag[options[correct_vote]])
	
	SetOptions(options)

func SetOptions(options):
	opt1.SetOption(options[0], 0.0)
	opt2.SetOption(options[1], 0.25)
	opt3.SetOption(options[2], 0.50)
	opt4.SetOption(options[3], 0.75)

func ProcessMessage(src, msg):
	if !msg.is_valid_integer():
		return
	var vote = int(msg)
	if vote < 1 or vote > 4:
		return
	
	var idx = 1
	for bucket in vote_counts:
		if src in bucket:
			if idx != vote:
				bucket.erase(src)
				opts[idx-1].SetVotes(len(bucket))
		else:
			if idx == vote:
				bucket.append(src)
				opts[idx-1].SetVotes(len(bucket))
		idx += 1
