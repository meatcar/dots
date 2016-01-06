

// Base16 Bright light - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#000000", /*  0: Base 00 - Black   */
	"#fb0120", /*  1: Base 08 - Red     */
	"#a1c659", /*  2: Base 0B - Green   */
	"#fda331", /*  3: Base 0A - Yellow  */
	"#6fb3d2", /*  4: Base 0D - Blue    */
	"#d381c3", /*  5: Base 0E - Magenta */
	"#76c7b7", /*  6: Base 0C - Cyan    */
	"#e0e0e0", /*  7: Base 05 - White   */

	/* Bright colors */
	"#b0b0b0", /*  8: Base 03 - Bright Black */
	"#fb0120", /*  9: Base 08 - Red          */
	"#a1c659", /* 10: Base 0B - Green        */
	"#fda331", /* 11: Base 0A - Yellow       */
	"#6fb3d2", /* 12: Base 0D - Blue         */
	"#d381c3", /* 13: Base 0E - Magenta      */
	"#76c7b7", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#fc6d24", /* 16: Base 09 */
	"#be643c", /* 17: Base 0F */
	"#303030", /* 18: Base 01 */
	"#505050", /* 19: Base 02 */
	"#d0d0d0", /* 20: Base 04 */
	"#f5f5f5", /* 21: Base 06 */

	[255] = 0,

	[256] = "#505050", /* default fg: Base 02 */
	[257] = "#ffffff", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


