

// Base16 Green Screen light - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#001100", /*  0: Base 00 - Black   */
	"#007700", /*  1: Base 08 - Red     */
	"#00bb00", /*  2: Base 0B - Green   */
	"#007700", /*  3: Base 0A - Yellow  */
	"#009900", /*  4: Base 0D - Blue    */
	"#00bb00", /*  5: Base 0E - Magenta */
	"#005500", /*  6: Base 0C - Cyan    */
	"#00bb00", /*  7: Base 05 - White   */

	/* Bright colors */
	"#007700", /*  8: Base 03 - Bright Black */
	"#007700", /*  9: Base 08 - Red          */
	"#00bb00", /* 10: Base 0B - Green        */
	"#007700", /* 11: Base 0A - Yellow       */
	"#009900", /* 12: Base 0D - Blue         */
	"#00bb00", /* 13: Base 0E - Magenta      */
	"#005500", /* 14: Base 0C - Cyan         */
	"#00ff00", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#009900", /* 16: Base 09 */
	"#005500", /* 17: Base 0F */
	"#003300", /* 18: Base 01 */
	"#005500", /* 19: Base 02 */
	"#009900", /* 20: Base 04 */
	"#00dd00", /* 21: Base 06 */

	[255] = 0,

	[256] = "#005500", /* default fg: Base 02 */
	[257] = "#00ff00", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


