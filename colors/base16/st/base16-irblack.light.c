

// Base16 IR Black light - simple terminal color setup
// Timothée Poisot (http://timotheepoisot.fr)
static const char *colorname[] = {
	/* Normal colors */
	"#000000", /*  0: Base 00 - Black   */
	"#ff6c60", /*  1: Base 08 - Red     */
	"#a8ff60", /*  2: Base 0B - Green   */
	"#ffffb6", /*  3: Base 0A - Yellow  */
	"#96cbfe", /*  4: Base 0D - Blue    */
	"#ff73fd", /*  5: Base 0E - Magenta */
	"#c6c5fe", /*  6: Base 0C - Cyan    */
	"#b5b3aa", /*  7: Base 05 - White   */

	/* Bright colors */
	"#6c6c66", /*  8: Base 03 - Bright Black */
	"#ff6c60", /*  9: Base 08 - Red          */
	"#a8ff60", /* 10: Base 0B - Green        */
	"#ffffb6", /* 11: Base 0A - Yellow       */
	"#96cbfe", /* 12: Base 0D - Blue         */
	"#ff73fd", /* 13: Base 0E - Magenta      */
	"#c6c5fe", /* 14: Base 0C - Cyan         */
	"#fdfbee", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#e9c062", /* 16: Base 09 */
	"#b18a3d", /* 17: Base 0F */
	"#242422", /* 18: Base 01 */
	"#484844", /* 19: Base 02 */
	"#918f88", /* 20: Base 04 */
	"#d9d7cc", /* 21: Base 06 */

	[255] = 0,

	[256] = "#484844", /* default fg: Base 02 */
	[257] = "#fdfbee", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


