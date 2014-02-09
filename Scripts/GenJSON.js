var names = ["Jacob", "Mason", "Ethan", "Noah", "William", "Liam", "Jayden", "Michael", "Alexander", "Aiden", "Sophia", "Emma", "Isabella", "Olivia", "Ava", "Emily", "Abigail", "Mia", "Madison", "Elizabeth"];


var shows = ["Game of Thrones", "Breaking Bad", "The Golden Girls"];


var episode_names0 = ["Season 1", "Season 2", "Season 3", "Season 4"];
var episode_names1 = ["Episode 1", "Episode 2", "Episode 3", "Episode 4"];
var episode_names2 = ["Live Free or Die", "Madrigal", "Hazard Pay", "Fifty-One", "Dead Freight", "Buyout", "Say My Name", "Gliding Over All", "Blood Money", "Buried", "Confessions", "Rabid Dog"];


var i=0;
var j=0;
var k=0;

var obj = [];

var totalPages = 0;

for (i=0;i<shows.length;i++){
	for (j=0;j<episode_names1.length;j++){

		var episodeRandom = Math.floor((Math.random()*episode_names2.length));
		var seasonRandom = Math.floor((Math.random()*episode_names0.length));

		var episodeName = episode_names0[seasonRandom]+" "+episode_names1[j] + " " + episode_names2[episodeRandom];

		var numRecordings = Math.floor((Math.random()*6)+4);

		var recordings = [];

		for (k=0;k<numRecordings;k++){
			var nameIndex = Math.floor((Math.random()*names.length));
			var firstName = names[nameIndex];

			recordings.push({
				firstName : firstName,
				likes : Math.floor(Math.random()*1000),
				dislikes : Math.floor(Math.random()*1000),
				mood : (Math.random()*360),
				intensity : Math.random(),
				waveformUrl : "waveformUrl",
				audioUrl : "audioUrl"
			});


		}

		obj.push({
			title : shows[i],
			subTitle : episodeName,
			mood : (Math.random()*360),
			intensity : Math.random(),
			recordings : recordings
		});
		totalPages++;
	}
}

var sets = [];
var count=0;
for (j=0;j<totalPages/5;j++){

	var tagPages = []

	for (i=0;count<totalPages && i<5;i++){
		tagPages.push(obj[count]);
		count++;
	}
	sets.push({
		setNumber : (j+1),
		tagPageCount : (count-j*5),
		totalTagPages: totalPages,
		totalSets : Math.floor(totalPages/5+1),
		tagPages  : tagPages
	});
}

var json = JSON.stringify(sets);
json = json.replace(/"/g, "\\\"");
document.write(json);