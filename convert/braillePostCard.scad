/*
 * PostCard in Braille
 * convert :  scad -> stl -> gcode
 *
 * derived from https://www.thingiverse.com/thing:8000
 */

/* 
   1. Create a new .scad script with a "use" statement at the top of your .scad file and then use the drawText function to print just the braille. 
      There are four parameters:
		text       - string that you want printed in braille (required)
		dotHeight  - float z height of each dot. Make sure this value is at least as large as your layer height. (optional, defaults to 0.5)
		dotRadius  - float radius of each dot (optional, defaults to 1)
		charWidth  - float width of each braille character (optional, defaults to 7)
		resolution - the resolution of the dots (optional, defaults to 10)
				You will have to manually position and draw each line with this method
	
	2. Open the .scad script and specify the text you want to print in the testText variable. 
	   You will also need to specify the width of the slab that it's drawn on. 
	   It takes quite a bit of computational power to render this stuff, it almost brought my laptop to a standstill.
 */

// Lines 7, # of Character 12
message = [ "I", "Love", "You"];

dotHeight = 0.5;
dotRadius = 1;
charWidth = 7;
resolution = 10;
lineHeight = 12;
totalHeight = len(message) * lineHeight;
slabX = 150;
slabY = totalHeight;

charKeys   = ["a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", "k", "K", "l", "L", "m", "M", "n", "N", 
              "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", "v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", 
			  ",", ";", ":", ".", "!", "(", ")", "?", "\"", "*", "'", "-"];
			  
charValues = [[1], [1], [1, 2], [1, 2], [1, 4], [1, 4], [1, 4, 5], [1, 4, 5], [1, 5], [1, 5], [1, 2, 4], [1, 2, 4], [1, 2, 4, 5], [1, 2, 4, 5], [1, 2, 5], 
              [1, 2, 5], [2, 4], [2, 4], [2, 4, 5], [2, 4, 5], [1, 3], [1, 3], [1, 2, 3], [1, 2, 3], [1, 3, 4], [1, 3, 4], [1, 3, 4, 5], [1, 3, 4, 5], [1, 3, 5],
		      [1, 3, 5], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 5], [1, 2, 3, 5], [2, 3, 4], [2, 3, 4], [2, 3, 4, 5], [2, 3, 4, 5], 
			  [1, 3, 6], [1, 3, 6], [1, 2, 3, 6], [1, 2, 3, 6], [2, 4, 5, 6], [2, 4, 5, 6], [1, 3, 4, 6], [1, 3, 4, 6], [1, 3, 4, 5, 6], [1, 3, 4, 5, 6], [1, 3, 5, 6], 
			  [1, 3, 5, 6], [2], [2, 3], [2, 5], [2, 5, 6], [2, 3, 5], [2, 3, 5, 6], [2, 3, 5, 6], [2, 3, 6], [2, 3, 6], [3, 5], [3], [3, 6]];

module drawDot(location, dotHeight = 0.5, dotRadius = 0.5, resolution = 10) {
	translate(location) {
		difference() {
			cylinder(h=dotHeight, r=dotRadius, $fn = resolution);
		}
	}
}

module drawCharacter(charMap, dotHeight = 0.5, dotRadius = 0.5, resolution = 10) {
	for(i = [0: len(charMap)-1]) {
		drawDot([floor((charMap[i]-1)/3)*dotHeight*3*dotRadius*2, -(charMap[i]-1)%3*dotHeight*3*dotRadius*2, 0], dotHeight, dotRadius, resolution);
	}
}

module drawText(text, dotHeight = 0.5, dotRadius = 0.5, charWidth = 3.5, resolution = 10) {
	for(i = [0: len(text)-1]) {
		translate([charWidth*i, 0, 0]) {
			for(j = [0:len(charKeys)]) {
				if(charKeys[j] == text[i]) {
					drawCharacter(charValues[j], dotHeight, dotRadius, resolution);
				}
			}
		}
	}
}

translate([0, lineHeight/3, 0]) {
	cube([slabX, slabY, 1], true);
}

translate([0, 0, 0.499]) {
	for(i = [0: len(message)]) {
		translate([-len(message[i])*charWidth/2, totalHeight/2-lineHeight*i, 0])
			drawText(message[i], dotHeight = dotHeight, dotRadius = dotRadius, charWidth = charWidth, resolution = resolution);
	}
}
