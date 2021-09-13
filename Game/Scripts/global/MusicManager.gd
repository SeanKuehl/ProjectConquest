extends Node

var menuMusicDirectory = "res://Game/Assets/Sounds/Menu Music/"
var menuMusic = []

var menuMusicPlaying = false
var menuMusicIndex = -1	#-1 so it can't accidentally play music when it should error
var menuMusicPlayPosition = -1.0


var rng = RandomNumberGenerator.new()

func _ready():
	pass
	
func LoadMusic():
	#other types of music will be "battle" and "game"
	LoadMusicInDirectory("menu", menuMusicDirectory)
	
func GetCurrentMenuMusic():
	if menuMusicPlaying:
		#get current menu music, pass the song and position to resume from
		return [load(menuMusic[menuMusicIndex]), menuMusicPlayPosition]
	else:
		#get new music
		rng.randomize()
		var my_random_number = rng.randi_range(0, len(menuMusic)-1)
		menuMusicPlaying = true
		menuMusicIndex = my_random_number
		menuMusicPlayPosition = 0.0
		return [load(menuMusic[my_random_number]), menuMusicPlayPosition]	#second item will be the parameter for play()
	
func SetMenuMusicPlaybackPosition(pos):
	menuMusicPlayPosition = pos

func LoadMusicInDirectory(musicType, dir):
	
	var allFiles = GetFilePathsInDirectory(dir)
	#there's both the audio files and the import files in the directory
	#remove every other element, we can't play and don't want to play the import files
	var isMusicFile = true
	var musicFiles = []
	for x in allFiles:
		if isMusicFile:
			musicFiles.append(x)
			isMusicFile = false
		else:
			isMusicFile = true
		
	
	if musicType == "menu":
		menuMusic = musicFiles
	
#make a way to resume music between menus(play() can take a time parameter)
	

#dir is the path to a dictory
#this function takes a directory and returns the full paths to files, ["c:/hello.txt"] for example
func GetFilePathsInDirectory(dir):
	
	var fileNames = list_files_in_directory(dir)
	var filePaths = []
	#to read from the file, it will need the full path to the file
	for x in fileNames:
		filePaths.append(dir+x)
		
	return filePaths
	
	
#path, a file path
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
