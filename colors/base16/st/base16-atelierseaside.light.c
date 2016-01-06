

// Base16 Atelier Seaside light - simple terminal color setup
// Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/seaside/)
static const char *colorname[] = {
	/* Normal colors */
	"#131513", /*  0: Base 00 - Black   */
	"#e6193c", /*  1: Base 08 - Red     */
	"#29a329", /*  2: Base 0B - Green   */
	"#98981b", /*  3: Base 0A - Yellow  */
	"#3d62f5", /*  4: Base 0D - Blue    */
	"#ad2bee", /*  5: Base 0E - Magenta */
	"#1999b3", /*  6: Base 0C - Cyan    */
	"#8ca68c", /*  7: Base 05 - White   */

	/* Bright colors */
	"#687d68", /*  8: Base 03 - Bright Black */
	"#e6193c", /*  9: Base 08 - Red          */
	"#29a329", /* 10: Base 0B - Green        */
	"#98981b", /* 11: Base 0A - Yellow       */
	"#3d62f5", /* 12: Base 0D - Blue         */
	"#ad2bee", /* 13: Base 0E - Magenta      */
	"#1999b3", /* 14: Base 0C - Cyan         */
	"#f4fbf4", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#87711d", /* 16: Base 09 */
	"#e619c3", /* 17: Base 0F */
	"#242924", /* 18: Base 01 */
	"#5e6e5e", /* 19: Base 02 */
	"#809980", /* 20: Base 04 */
	"#cfe8cf", /* 21: Base 06 */

	[255] = 0,

	[256] = "#5e6e5e", /* default fg: Base 02 */
	[257] = "#f4fbf4", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


