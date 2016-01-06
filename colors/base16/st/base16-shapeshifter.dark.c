

// Base16 shapeshifter dark - simple terminal color setup
// Tyler Benziger (http://tybenz.com)
static const char *colorname[] = {
	/* Normal colors */
	"#000000", /*  0: Base 00 - Black   */
	"#e92f2f", /*  1: Base 08 - Red     */
	"#0ed839", /*  2: Base 0B - Green   */
	"#dddd13", /*  3: Base 0A - Yellow  */
	"#3b48e3", /*  4: Base 0D - Blue    */
	"#f996e2", /*  5: Base 0E - Magenta */
	"#23edda", /*  6: Base 0C - Cyan    */
	"#ababab", /*  7: Base 05 - White   */

	/* Bright colors */
	"#343434", /*  8: Base 03 - Bright Black */
	"#e92f2f", /*  9: Base 08 - Red          */
	"#0ed839", /* 10: Base 0B - Green        */
	"#dddd13", /* 11: Base 0A - Yellow       */
	"#3b48e3", /* 12: Base 0D - Blue         */
	"#f996e2", /* 13: Base 0E - Magenta      */
	"#23edda", /* 14: Base 0C - Cyan         */
	"#f9f9f9", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#e09448", /* 16: Base 09 */
	"#69542d", /* 17: Base 0F */
	"#040404", /* 18: Base 01 */
	"#102015", /* 19: Base 02 */
	"#555555", /* 20: Base 04 */
	"#e0e0e0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#ababab", /* default fg: Base 05 */
	[257] = "#000000", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

