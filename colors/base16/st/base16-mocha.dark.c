

// Base16 Mocha dark - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#3B3228", /*  0: Base 00 - Black   */
	"#cb6077", /*  1: Base 08 - Red     */
	"#beb55b", /*  2: Base 0B - Green   */
	"#f4bc87", /*  3: Base 0A - Yellow  */
	"#8ab3b5", /*  4: Base 0D - Blue    */
	"#a89bb9", /*  5: Base 0E - Magenta */
	"#7bbda4", /*  6: Base 0C - Cyan    */
	"#d0c8c6", /*  7: Base 05 - White   */

	/* Bright colors */
	"#7e705a", /*  8: Base 03 - Bright Black */
	"#cb6077", /*  9: Base 08 - Red          */
	"#beb55b", /* 10: Base 0B - Green        */
	"#f4bc87", /* 11: Base 0A - Yellow       */
	"#8ab3b5", /* 12: Base 0D - Blue         */
	"#a89bb9", /* 13: Base 0E - Magenta      */
	"#7bbda4", /* 14: Base 0C - Cyan         */
	"#f5eeeb", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#d28b71", /* 16: Base 09 */
	"#bb9584", /* 17: Base 0F */
	"#534636", /* 18: Base 01 */
	"#645240", /* 19: Base 02 */
	"#b8afad", /* 20: Base 04 */
	"#e9e1dd", /* 21: Base 06 */

	[255] = 0,

	[256] = "#d0c8c6", /* default fg: Base 05 */
	[257] = "#3B3228", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

