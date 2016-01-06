

// Base16 Pop dark - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#000000", /*  0: Base 00 - Black   */
	"#eb008a", /*  1: Base 08 - Red     */
	"#37b349", /*  2: Base 0B - Green   */
	"#f8ca12", /*  3: Base 0A - Yellow  */
	"#0e5a94", /*  4: Base 0D - Blue    */
	"#b31e8d", /*  5: Base 0E - Magenta */
	"#00aabb", /*  6: Base 0C - Cyan    */
	"#d0d0d0", /*  7: Base 05 - White   */

	/* Bright colors */
	"#505050", /*  8: Base 03 - Bright Black */
	"#eb008a", /*  9: Base 08 - Red          */
	"#37b349", /* 10: Base 0B - Green        */
	"#f8ca12", /* 11: Base 0A - Yellow       */
	"#0e5a94", /* 12: Base 0D - Blue         */
	"#b31e8d", /* 13: Base 0E - Magenta      */
	"#00aabb", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#f29333", /* 16: Base 09 */
	"#7a2d00", /* 17: Base 0F */
	"#202020", /* 18: Base 01 */
	"#303030", /* 19: Base 02 */
	"#b0b0b0", /* 20: Base 04 */
	"#e0e0e0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#d0d0d0", /* default fg: Base 05 */
	[257] = "#000000", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

