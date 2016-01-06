

// Base16 Chalk light - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#151515", /*  0: Base 00 - Black   */
	"#fb9fb1", /*  1: Base 08 - Red     */
	"#acc267", /*  2: Base 0B - Green   */
	"#ddb26f", /*  3: Base 0A - Yellow  */
	"#6fc2ef", /*  4: Base 0D - Blue    */
	"#e1a3ee", /*  5: Base 0E - Magenta */
	"#12cfc0", /*  6: Base 0C - Cyan    */
	"#d0d0d0", /*  7: Base 05 - White   */

	/* Bright colors */
	"#505050", /*  8: Base 03 - Bright Black */
	"#fb9fb1", /*  9: Base 08 - Red          */
	"#acc267", /* 10: Base 0B - Green        */
	"#ddb26f", /* 11: Base 0A - Yellow       */
	"#6fc2ef", /* 12: Base 0D - Blue         */
	"#e1a3ee", /* 13: Base 0E - Magenta      */
	"#12cfc0", /* 14: Base 0C - Cyan         */
	"#f5f5f5", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#eda987", /* 16: Base 09 */
	"#deaf8f", /* 17: Base 0F */
	"#202020", /* 18: Base 01 */
	"#303030", /* 19: Base 02 */
	"#b0b0b0", /* 20: Base 04 */
	"#e0e0e0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#303030", /* default fg: Base 02 */
	[257] = "#f5f5f5", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


