

// Base16 Yesterday dark - simple terminal color setup
// FroZnShiva (https://github.com/FroZnShiva)
static const char *colorname[] = {
	/* Normal colors */
	"#1d1f21", /*  0: Base 00 - Black   */
	"#c82829", /*  1: Base 08 - Red     */
	"#718c00", /*  2: Base 0B - Green   */
	"#eab700", /*  3: Base 0A - Yellow  */
	"#4271ae", /*  4: Base 0D - Blue    */
	"#8959a8", /*  5: Base 0E - Magenta */
	"#3e999f", /*  6: Base 0C - Cyan    */
	"#d6d6d6", /*  7: Base 05 - White   */

	/* Bright colors */
	"#969896", /*  8: Base 03 - Bright Black */
	"#c82829", /*  9: Base 08 - Red          */
	"#718c00", /* 10: Base 0B - Green        */
	"#eab700", /* 11: Base 0A - Yellow       */
	"#4271ae", /* 12: Base 0D - Blue         */
	"#8959a8", /* 13: Base 0E - Magenta      */
	"#3e999f", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#f5871f", /* 16: Base 09 */
	"#7f2a1d", /* 17: Base 0F */
	"#282a2e", /* 18: Base 01 */
	"#4d4d4c", /* 19: Base 02 */
	"#8e908c", /* 20: Base 04 */
	"#efefef", /* 21: Base 06 */

	[255] = 0,

	[256] = "#d6d6d6", /* default fg: Base 05 */
	[257] = "#1d1f21", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

