

// Base16 Macintosh dark - simple terminal color setup
// Rebecca Bettencourt (http://www.kreativekorp.com)
static const char *colorname[] = {
	/* Normal colors */
	"#000000", /*  0: Base 00 - Black   */
	"#dd0907", /*  1: Base 08 - Red     */
	"#1fb714", /*  2: Base 0B - Green   */
	"#fbf305", /*  3: Base 0A - Yellow  */
	"#0000d3", /*  4: Base 0D - Blue    */
	"#4700a5", /*  5: Base 0E - Magenta */
	"#02abea", /*  6: Base 0C - Cyan    */
	"#c0c0c0", /*  7: Base 05 - White   */

	/* Bright colors */
	"#808080", /*  8: Base 03 - Bright Black */
	"#dd0907", /*  9: Base 08 - Red          */
	"#1fb714", /* 10: Base 0B - Green        */
	"#fbf305", /* 11: Base 0A - Yellow       */
	"#0000d3", /* 12: Base 0D - Blue         */
	"#4700a5", /* 13: Base 0E - Magenta      */
	"#02abea", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#ff6403", /* 16: Base 09 */
	"#90713a", /* 17: Base 0F */
	"#404040", /* 18: Base 01 */
	"#404040", /* 19: Base 02 */
	"#808080", /* 20: Base 04 */
	"#c0c0c0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#c0c0c0", /* default fg: Base 05 */
	[257] = "#000000", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

