

// Base16 Apathy dark - simple terminal color setup
// Jannik Siebert (https://github.com/janniks)
static const char *colorname[] = {
	/* Normal colors */
	"#031A16", /*  0: Base 00 - Black   */
	"#3E9688", /*  1: Base 08 - Red     */
	"#883E96", /*  2: Base 0B - Green   */
	"#3E4C96", /*  3: Base 0A - Yellow  */
	"#96883E", /*  4: Base 0D - Blue    */
	"#4C963E", /*  5: Base 0E - Magenta */
	"#963E4C", /*  6: Base 0C - Cyan    */
	"#81B5AC", /*  7: Base 05 - White   */

	/* Bright colors */
	"#2B685E", /*  8: Base 03 - Bright Black */
	"#3E9688", /*  9: Base 08 - Red          */
	"#883E96", /* 10: Base 0B - Green        */
	"#3E4C96", /* 11: Base 0A - Yellow       */
	"#96883E", /* 12: Base 0D - Blue         */
	"#4C963E", /* 13: Base 0E - Magenta      */
	"#963E4C", /* 14: Base 0C - Cyan         */
	"#D2E7E4", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#3E7996", /* 16: Base 09 */
	"#3E965B", /* 17: Base 0F */
	"#0B342D", /* 18: Base 01 */
	"#184E45", /* 19: Base 02 */
	"#5F9C92", /* 20: Base 04 */
	"#A7CEC8", /* 21: Base 06 */

	[255] = 0,

	[256] = "#81B5AC", /* default fg: Base 05 */
	[257] = "#031A16", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

