

// Base16 Embers light - simple terminal color setup
// Jannik Siebert (https://github.com/janniks)
static const char *colorname[] = {
	/* Normal colors */
	"#16130F", /*  0: Base 00 - Black   */
	"#826D57", /*  1: Base 08 - Red     */
	"#57826D", /*  2: Base 0B - Green   */
	"#6D8257", /*  3: Base 0A - Yellow  */
	"#6D5782", /*  4: Base 0D - Blue    */
	"#82576D", /*  5: Base 0E - Magenta */
	"#576D82", /*  6: Base 0C - Cyan    */
	"#A39A90", /*  7: Base 05 - White   */

	/* Bright colors */
	"#5A5047", /*  8: Base 03 - Bright Black */
	"#826D57", /*  9: Base 08 - Red          */
	"#57826D", /* 10: Base 0B - Green        */
	"#6D8257", /* 11: Base 0A - Yellow       */
	"#6D5782", /* 12: Base 0D - Blue         */
	"#82576D", /* 13: Base 0E - Magenta      */
	"#576D82", /* 14: Base 0C - Cyan         */
	"#DBD6D1", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#828257", /* 16: Base 09 */
	"#825757", /* 17: Base 0F */
	"#2C2620", /* 18: Base 01 */
	"#433B32", /* 19: Base 02 */
	"#8A8075", /* 20: Base 04 */
	"#BEB6AE", /* 21: Base 06 */

	[255] = 0,

	[256] = "#433B32", /* default fg: Base 02 */
	[257] = "#DBD6D1", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


