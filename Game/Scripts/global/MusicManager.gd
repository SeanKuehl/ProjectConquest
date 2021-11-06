extends Node

var menuMusicDirectory = "res://Game/Assets/Sounds/Menu Music/"
var battleMusicDirectory = "res://Game/Assets/Sounds/Battle Music/"
var gameMusicDirectory = "res://Game/Assets/Sounds/Game Music/"


var menuMusic = []
var battleMusic = []
var gameMusic = []

var menuMusicPlaying = false
var menuMusicIndex = -1	#-1 so it can't accidentally play music when it should error
var menuMusicPlayPosition = -1.0

var gameMusicPlaying = false
var gameMusicIndex = -1

var battleMusicPlaying = false
var battleMusicIndex = -1

var rng = RandomNumberGenerator.new()

func _ready():
	pass

func LoadMusic():
	#other types of music will be "battle" and "game"
	LoadMusicInDirectory("menu", menuMusicDirectory)
	LoadMusicInDirectory("battle", battleMusicDirectory)
	LoadMusicInDirectory("game", gameMusicDirectory)

#game music will work in this way, it will switch to a new song
#after a battle, so each time it calls the func it can return a new song
#it will never switch to a new menu and resume so yeah
func GetGameMusic():
	gameMusicIndex += 1
	if gameMusicIndex > len(gameMusic)-1:
		#game music index starts at zero, so the -1 adjustment is needed
		gameMusicIndex = 0	#so it will be 0 next time around

	return load(gameMusic[gameMusicIndex])

func GetBattleMusic():
	battleMusicIndex += 1
	if battleMusicIndex > len(battleMusic)-1:
		#game music index starts at zero, so the -1 adjustment is needed
		battleMusicIndex = 0	#so it will be 0 next time around

	return load(battleMusic[battleMusicIndex])


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
	#change this to get the .import files and take off the .import ending
	#because only the .imports are there in the exported version

	var allFiles = GetFilePathsInDirectory(dir)
	#there's both the audio files and the import files in the directory
	#remove every other element, we can't play and don't want to play the import files

	var musicFiles = []
	for x in allFiles:
		#if music file ends in ".import", cut off the ".import" and
		#load it
		#this explains what this mess is: https://godotengine.org/qa/96597/audio-crashes-and-missing-on-exported-project-3-2-3

		if x.ends_with(".import"):

			x.erase(len(x)-7,7)

			musicFiles.append(x)



	if musicType == "menu":
		menuMusic = musicFiles
	elif musicType == "battle":
		battleMusic = musicFiles
	elif musicType == "game":
		gameMusic = musicFiles

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
