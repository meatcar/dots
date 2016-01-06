

// Base16 Eighties light - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#2d2d2d", /*  0: Base 00 - Black   */
	"#f2777a", /*  1: Base 08 - Red     */
	"#99cc99", /*  2: Base 0B - Green   */
	"#ffcc66", /*  3: Base 0A - Yellow  */
	"#6699cc", /*  4: Base 0D - Blue    */
	"#cc99cc", /*  5: Base 0E - Magenta */
	"#66cccc", /*  6: Base 0C - Cyan    */
	"#d3d0c8", /*  7: Base 05 - White   */

	/* Bright colors */
	"#747369", /*  8: Base 03 - Bright Black */
	"#f2777a", /*  9: Base 08 - Red          */
	"#99cc99", /* 10: Base 0B - Green        */
	"#ffcc66", /* 11: Base 0A - Yellow       */
	"#6699cc", /* 12: Base 0D - Blue         */
	"#cc99cc", /* 13: Base 0E - Magenta      */
	"#66cccc", /* 14: Base 0C - Cyan         */
	"#f2f0ec", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#f99157", /* 16: Base 09 */
	"#d27b53", /* 17: Base 0F */
	"#393939", /* 18: Base 01 */
	"#515151", /* 19: Base 02 */
	"#a09f93", /* 20: Base 04 */
	"#e8e6df", /* 21: Base 06 */

	[255] = 0,

	[256] = "#515151", /* default fg: Base 02 */
	[257] = "#f2f0ec", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


