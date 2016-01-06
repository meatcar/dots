

// Base16 3024 dark - simple terminal color setup
// Jan T. Sott (http://github.com/idleberg)
static const char *colorname[] = {
	/* Normal colors */
	"#090300", /*  0: Base 00 - Black   */
	"#db2d20", /*  1: Base 08 - Red     */
	"#01a252", /*  2: Base 0B - Green   */
	"#fded02", /*  3: Base 0A - Yellow  */
	"#01a0e4", /*  4: Base 0D - Blue    */
	"#a16a94", /*  5: Base 0E - Magenta */
	"#b5e4f4", /*  6: Base 0C - Cyan    */
	"#a5a2a2", /*  7: Base 05 - White   */

	/* Bright colors */
	"#5c5855", /*  8: Base 03 - Bright Black */
	"#db2d20", /*  9: Base 08 - Red          */
	"#01a252", /* 10: Base 0B - Green        */
	"#fded02", /* 11: Base 0A - Yellow       */
	"#01a0e4", /* 12: Base 0D - Blue         */
	"#a16a94", /* 13: Base 0E - Magenta      */
	"#b5e4f4", /* 14: Base 0C - Cyan         */
	"#f7f7f7", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#e8bbd0", /* 16: Base 09 */
	"#cdab53", /* 17: Base 0F */
	"#3a3432", /* 18: Base 01 */
	"#4a4543", /* 19: Base 02 */
	"#807d7c", /* 20: Base 04 */
	"#d6d5d4", /* 21: Base 06 */

	[255] = 0,

	[256] = "#a5a2a2", /* default fg: Base 05 */
	[257] = "#090300", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

