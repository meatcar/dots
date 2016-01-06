

// Base16 Atelier Forest light - simple terminal color setup
// Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/forest)
static const char *colorname[] = {
	/* Normal colors */
	"#1b1918", /*  0: Base 00 - Black   */
	"#f22c40", /*  1: Base 08 - Red     */
	"#7b9726", /*  2: Base 0B - Green   */
	"#c38418", /*  3: Base 0A - Yellow  */
	"#407ee7", /*  4: Base 0D - Blue    */
	"#6666ea", /*  5: Base 0E - Magenta */
	"#3d97b8", /*  6: Base 0C - Cyan    */
	"#a8a19f", /*  7: Base 05 - White   */

	/* Bright colors */
	"#766e6b", /*  8: Base 03 - Bright Black */
	"#f22c40", /*  9: Base 08 - Red          */
	"#7b9726", /* 10: Base 0B - Green        */
	"#c38418", /* 11: Base 0A - Yellow       */
	"#407ee7", /* 12: Base 0D - Blue         */
	"#6666ea", /* 13: Base 0E - Magenta      */
	"#3d97b8", /* 14: Base 0C - Cyan         */
	"#f1efee", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#df5320", /* 16: Base 09 */
	"#c33ff3", /* 17: Base 0F */
	"#2c2421", /* 18: Base 01 */
	"#68615e", /* 19: Base 02 */
	"#9c9491", /* 20: Base 04 */
	"#e6e2e0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#68615e", /* default fg: Base 02 */
	[257] = "#f1efee", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


