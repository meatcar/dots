

// Base16 Summerfruit light - simple terminal color setup
// Christopher Corley (http://cscorley.github.io/)
static const char *colorname[] = {
	/* Normal colors */
	"#151515", /*  0: Base 00 - Black   */
	"#FF0086", /*  1: Base 08 - Red     */
	"#00C918", /*  2: Base 0B - Green   */
	"#ABA800", /*  3: Base 0A - Yellow  */
	"#3777E6", /*  4: Base 0D - Blue    */
	"#AD00A1", /*  5: Base 0E - Magenta */
	"#1faaaa", /*  6: Base 0C - Cyan    */
	"#D0D0D0", /*  7: Base 05 - White   */

	/* Bright colors */
	"#505050", /*  8: Base 03 - Bright Black */
	"#FF0086", /*  9: Base 08 - Red          */
	"#00C918", /* 10: Base 0B - Green        */
	"#ABA800", /* 11: Base 0A - Yellow       */
	"#3777E6", /* 12: Base 0D - Blue         */
	"#AD00A1", /* 13: Base 0E - Magenta      */
	"#1faaaa", /* 14: Base 0C - Cyan         */
	"#FFFFFF", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#FD8900", /* 16: Base 09 */
	"#cc6633", /* 17: Base 0F */
	"#202020", /* 18: Base 01 */
	"#303030", /* 19: Base 02 */
	"#B0B0B0", /* 20: Base 04 */
	"#E0E0E0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#303030", /* default fg: Base 02 */
	[257] = "#FFFFFF", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


