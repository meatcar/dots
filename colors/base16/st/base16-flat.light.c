

// Base16 Flat light - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#2C3E50", /*  0: Base 00 - Black   */
	"#E74C3C", /*  1: Base 08 - Red     */
	"#2ECC71", /*  2: Base 0B - Green   */
	"#F1C40F", /*  3: Base 0A - Yellow  */
	"#3498DB", /*  4: Base 0D - Blue    */
	"#9B59B6", /*  5: Base 0E - Magenta */
	"#1ABC9C", /*  6: Base 0C - Cyan    */
	"#e0e0e0", /*  7: Base 05 - White   */

	/* Bright colors */
	"#95A5A6", /*  8: Base 03 - Bright Black */
	"#E74C3C", /*  9: Base 08 - Red          */
	"#2ECC71", /* 10: Base 0B - Green        */
	"#F1C40F", /* 11: Base 0A - Yellow       */
	"#3498DB", /* 12: Base 0D - Blue         */
	"#9B59B6", /* 13: Base 0E - Magenta      */
	"#1ABC9C", /* 14: Base 0C - Cyan         */
	"#ECF0F1", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#E67E22", /* 16: Base 09 */
	"#be643c", /* 17: Base 0F */
	"#34495E", /* 18: Base 01 */
	"#7F8C8D", /* 19: Base 02 */
	"#BDC3C7", /* 20: Base 04 */
	"#f5f5f5", /* 21: Base 06 */

	[255] = 0,

	[256] = "#7F8C8D", /* default fg: Base 02 */
	[257] = "#ECF0F1", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


