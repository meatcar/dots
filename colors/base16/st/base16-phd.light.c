

// Base16 PhD light - simple terminal color setup
// Hennig Hasemann (http://leetless.de/vim.html)
static const char *colorname[] = {
	/* Normal colors */
	"#061229", /*  0: Base 00 - Black   */
	"#d07346", /*  1: Base 08 - Red     */
	"#99bf52", /*  2: Base 0B - Green   */
	"#fbd461", /*  3: Base 0A - Yellow  */
	"#5299bf", /*  4: Base 0D - Blue    */
	"#9989cc", /*  5: Base 0E - Magenta */
	"#72b9bf", /*  6: Base 0C - Cyan    */
	"#b8bbc2", /*  7: Base 05 - White   */

	/* Bright colors */
	"#717885", /*  8: Base 03 - Bright Black */
	"#d07346", /*  9: Base 08 - Red          */
	"#99bf52", /* 10: Base 0B - Green        */
	"#fbd461", /* 11: Base 0A - Yellow       */
	"#5299bf", /* 12: Base 0D - Blue         */
	"#9989cc", /* 13: Base 0E - Magenta      */
	"#72b9bf", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#f0a000", /* 16: Base 09 */
	"#b08060", /* 17: Base 0F */
	"#2a3448", /* 18: Base 01 */
	"#4d5666", /* 19: Base 02 */
	"#9a99a3", /* 20: Base 04 */
	"#dbdde0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#4d5666", /* default fg: Base 02 */
	[257] = "#ffffff", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


