extends Node2D

onready var turn_timer = $TurnTimer
onready var score = $Score
onready var message = $Message
onready var startup = $Startup
onready var flag = $Flag
onready var channel = $Channel
onready var opt1 = $Option
onready var opt2 = $Option2
onready var opt3 = $Option3
onready var opt4 = $Option4
onready var opts = [opt1, opt2, opt3, opt4]

var questions_asked = 0
var correct_answers = 0
var vote_counts = [[], [], [], []]
var correct_vote = 0
var state = 0
var until_next_state = -1.0

const timer_time = 20.0
const between_questions_time = 4.0

func _ready():
	randomize()
	StartNewGame()

func _process(delta):
	until_next_state -= delta
	if state == 1:
		turn_timer.SetText(str(int(until_next_state + 1.0)))
		if until_next_state <= 0.0:
			CheckAnswer()
			state = 2
			until_next_state = between_questions_time
	elif state == 2:
		turn_timer.SetText("0")
		if until_next_state <= 0.0:
			PickNewQuestion()
			state = 1
			until_next_state = timer_time
	
	score.SetText(str(correct_answers) + "/" + str(questions_asked))

func SetChannel(channel_name):
	channel.SetText("Playing with: "+channel_name)

func StartNewGame():
	PickNewQuestion()
	questions_asked = 0
	correct_answers = 0
	state = 0
	until_next_state = 9999.9
	startup.StartCount()

func CheckAnswer():
	questions_asked += 1
	var answer = 0
	var max_votes = 0
	var tie = false
	for i in [0, 1, 2, 3]:
		if len(vote_counts[i]) > max_votes:
			max_votes = len(vote_counts[i])
			answer = i
			tie = false
		elif len(vote_counts[i]) == max_votes:
			tie = true
	
	for opt in opts:
		opt.SetFadedColoring()
	opts[correct_vote].SetCorrectColoring()
	if answer == correct_vote and !tie:
		correct_answers += 1
		message.SetText("Correct! It was "+opts[correct_vote].GetOptionText()+"!") # TODO: pick random positive word as prefix
	else:
		if tie:
			message.SetText("Ties won't count! It was "+opts[correct_vote].GetOptionText()+"!")
		else:
			opts[answer].SetWrongColoring()
			message.SetText("WRONG! It was "+opts[correct_vote].GetOptionText()+"!") # TODO: pick random negative
	# TODO apply color to options

func PickNewQuestion():
	vote_counts = [[], [], [], []]
	for opt in opts:
		opt.SetNormalColoring()
	
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
	flag.SetFlag(Flags.GetFlag(options[correct_vote]))
	
	SetOptions(options)
	message.SetText("What's this?")

func SetOptions(options):
	opt1.SetOption(options[0], 0.0)
	opt2.SetOption(options[1], 0.25)
	opt3.SetOption(options[2], 0.50)
	opt4.SetOption(options[3], 0.75)

func ProcessMessage(src, msg):
	if state != 1:
		return
	var vote = 0
	if msg.is_valid_integer():
		vote = int(msg)
	else:
		if msg.to_lower() == "one":
			vote = 1
		elif msg.to_lower() == "two":
			vote = 2
		elif msg.to_lower() == "three":
			vote = 3
		elif msg.to_lower() == "four":
			vote = 4
		elif msg.to_lower() == "five":
			vote = 5
	
	if vote == 5:
		pass # easter egg here
	
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
