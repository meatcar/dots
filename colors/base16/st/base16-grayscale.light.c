

// Base16 Grayscale light - simple terminal color setup
// Alexandre Gavioli (https://github.com/Alexx2/)
static const char *colorname[] = {
	/* Normal colors */
	"#101010", /*  0: Base 00 - Black   */
	"#7c7c7c", /*  1: Base 08 - Red     */
	"#8e8e8e", /*  2: Base 0B - Green   */
	"#a0a0a0", /*  3: Base 0A - Yellow  */
	"#686868", /*  4: Base 0D - Blue    */
	"#747474", /*  5: Base 0E - Magenta */
	"#868686", /*  6: Base 0C - Cyan    */
	"#b9b9b9", /*  7: Base 05 - White   */

	/* Bright colors */
	"#525252", /*  8: Base 03 - Bright Black */
	"#7c7c7c", /*  9: Base 08 - Red          */
	"#8e8e8e", /* 10: Base 0B - Green        */
	"#a0a0a0", /* 11: Base 0A - Yellow       */
	"#686868", /* 12: Base 0D - Blue         */
	"#747474", /* 13: Base 0E - Magenta      */
	"#868686", /* 14: Base 0C - Cyan         */
	"#f7f7f7", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#999999", /* 16: Base 09 */
	"#5e5e5e", /* 17: Base 0F */
	"#252525", /* 18: Base 01 */
	"#464646", /* 19: Base 02 */
	"#ababab", /* 20: Base 04 */
	"#e3e3e3", /* 21: Base 06 */

	[255] = 0,

	[256] = "#464646", /* default fg: Base 02 */
	[257] = "#f7f7f7", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


