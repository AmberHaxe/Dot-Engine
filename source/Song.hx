package;

import Section.SwagSection;
import Section.DialogueSection;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var dialogue:Array<DialogueSection>;
	var bpm:Float;
	var hasDialogue:Bool;
	var needsVoices:Bool;
	var stageDefault:String;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gf:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var dialogue:Array<DialogueSection>;
	public var bpm:Float;
	public var hasDialogue:Bool = false;
	public var needsVoices:Bool = true;
	public var stageDefault:String = 'stage';
	public var speed:Float = 1;

	public var gf:String = 'gf';
	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, notes, dialogue, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.dialogue = dialogue;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.notes);
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daBpm = songData.bpm; */

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}